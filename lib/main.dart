import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:safeguardher_flutter_app/screens/auth_screen/login_screen/login_screen.dart';
import 'package:safeguardher_flutter_app/screens/home_screen/home_screen.dart';
import 'package:safeguardher_flutter_app/screens/splash_screen/splash_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // New import for connectivity
import 'api/firebase_api.dart';
import 'firebase_options.dart';
import 'dart:async';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotification();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool appOpenedBefore = prefs.getBool('appOpenedBefore') ?? false;
  bool loggedIn = prefs.getBool('loggedIn') ?? false;

  runApp(ProviderScope(
    child: SafeGuardHer(appOpenedBefore: appOpenedBefore, loggedIn: loggedIn),
  ));
}

Future<bool> isConnected() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  return connectivityResult != ConnectivityResult.none;
}

// Retry mechanism with exponential backoff
Future<T> retry<T>({
  required Future<T> Function() action,
  int retries = 5, // Increased retries
  Duration delay = const Duration(seconds: 2), // Initial delay
}) async {
  for (int attempt = 0; attempt < retries; attempt++) {
    try {
      return await action();
    } catch (e) {
      if (attempt == retries - 1) {
        rethrow; // Rethrow the exception after final retry
      }
      await Future.delayed(delay * (attempt + 1)); // Exponential backoff
    }
  }
  throw Exception('Failed after $retries retries');
}

Future<void> fetchUnsafePlaces() async {
  try {
    if (await isConnected()) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await retry(
        action: () => FirebaseFirestore.instance
            .collection('unsafe_places')
            .doc('unsafe_places')
            .get(),
      );

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data()!;
        print('Unsafe Places: ${data['place']}');
      } else {
        print('No unsafe places found.');
      }
    } else {
      print('No internet connection. Please check your connection and try again.');
    }
  } catch (e) {
    if (e is FirebaseException && e.code == 'unavailable') {
      print('Firestore service is temporarily unavailable. Please try again later.');
    } else {
      print('Error fetching unsafe places: $e');
    }
  }
}

Future<void> fetchUserData(String phoneNumber) async {
  try {
    if (await isConnected()) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await retry(
        action: () => FirebaseFirestore.instance
            .collection('users')
            .doc(phoneNumber)
            .get(),
      );

      if (snapshot.exists) {
        Map<String, dynamic> userData = snapshot.data()!;
        print('User Data: $userData');
      } else {
        print('No user found with phone number: $phoneNumber');
      }
    } else {
      print('No internet connection. Please check your connection and try again.');
    }
  } catch (e) {
    if (e is FirebaseException && e.code == 'unavailable') {
      print('Firestore service is temporarily unavailable. Please try again later.');
    } else {
      print('Error fetching user data: $e');
    }
  }
}

class SafeGuardHer extends StatelessWidget {
  final bool appOpenedBefore;
  final bool loggedIn;

  const SafeGuardHer({
    super.key,
    required this.appOpenedBefore,
    required this.loggedIn,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SafeGuardHer',
      theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      home: FutureBuilder<bool>(
        future: isAppOpeningForFirstTime(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          } else {
            bool isFirstTime = snapshot.data ?? true;
            if (isFirstTime) {
              // Call fetchUserData and fetchUnsafePlaces after determining the screen
              fetchUserData('01719958727');
              fetchUnsafePlaces();
              return const SplashScreen();
            } else if (loggedIn) {
              // Call fetchUserData and fetchUnsafePlaces after determining the screen
              fetchUserData('01719958727');
              fetchUnsafePlaces();
              return const HomeScreen();
            } else {
              // Call fetchUserData and fetchUnsafePlaces after determining the screen
              fetchUserData('01719958727');
              fetchUnsafePlaces();
              return const LoginScreen();
            }
          }
        },
      ),
    );
  }

  Future<bool> isAppOpeningForFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool result = prefs.getBool('appOpenedBefore') ?? false;

    // If it's the first time, set the flag to true
    if (!result) {
      await prefs.setBool('appOpenedBefore', true);
    }

    return result;
  }
}
