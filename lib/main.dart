import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api/firebase_api.dart';
import 'example.dart';
import 'firebase_options.dart';
import 'app.dart';
import 'screens/auth_screen/signup_screen/signup_screen1.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
  //bool appOpenedBefore = prefs.getBool('appOpenedBefore') ?? false;
  //bool loggedIn = prefs.getBool('loggedIn') ?? false;

  bool appOpenedBefore = false;
  bool loggedIn = false;

  runApp(
   ProviderScope(
     child: SafeGuardHer(appOpenedBefore: appOpenedBefore, loggedIn: loggedIn),
   ),
  );

  /*
  runApp(const MaterialApp(
    home: SignUpScreen1(),
  )); */
}
