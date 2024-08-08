import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:safeguardher_flutter_app/screens/auth_screen/login_screen/login_screen.dart';
import 'package:safeguardher_flutter_app/screens/home_screen/home_screen.dart';
import 'package:safeguardher_flutter_app/screens/splash_screen/splash_screen.dart';
import 'api/firebase_api.dart';
import 'firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotification();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool appOpenedBefore = prefs.getBool('appOpenedBefore') ?? false;
  bool loggedIn = prefs.getBool('loggedIn') ?? false;

  //appOpenedBefore = false; loggedIn = false; //comment this on production

  runApp(ProviderScope(
    child: SafeGuardHer(appOpenedBefore: appOpenedBefore, loggedIn: loggedIn),
  ));
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
  Widget build(BuildContext context)
  {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SafeGuardHer',
      theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
      ),
      home: FutureBuilder<bool>(
        future: isAppOpeningForFirstTime(),
        builder: (context, snapshot)
        {
          if (snapshot.connectionState == ConnectionState.waiting)
          {
            return const SplashScreen();
          }
          else
          {
            bool isFirstTime = snapshot.data ?? true;
            return isFirstTime
                ? const SplashScreen()
                : loggedIn
                ? const HomeScreen()
                : const LoginScreen();
          }
        },
      ),
    );
  }

  Future<bool> isAppOpeningForFirstTime() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool result = prefs.getBool('appOpenedBefore') ?? false;
   // result = true; //Comment this on production
    if (!result)
    {
     await prefs.setBool('appOpenedBefore', true);
    }
    return result;
  }
}
