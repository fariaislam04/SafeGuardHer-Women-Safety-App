import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safeguardher_flutter_app/screens/login_screen/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:safeguardher_flutter_app/screens/onboarding_screen/onboarding_screen.dart';
import 'package:safeguardher_flutter_app/screens/home_screen/home_screen.dart';
import 'package:safeguardher_flutter_app/screens/signup_screen/signup_otp_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool seenOnboarding = prefs.getBool('seenOnboarding') ?? false;

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(SafeGuardHer(seenOnboarding: seenOnboarding));
  });
}

class SafeGuardHer extends StatelessWidget {
  final bool seenOnboarding;
  const SafeGuardHer({super.key, required this.seenOnboarding});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      //home: seenOnboarding ? const HomeScreen() : OnboardingScreen(),
      //home: OnboardingScreen(),
      home: LoginScreen(),
      //home: SignUpOTPScreen(),
    );
  }
}
