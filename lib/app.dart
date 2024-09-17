import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen/home_screen.dart';
import 'screens/auth_screen/login_screen/login_screen.dart';
import 'screens/splash_screen/splash_screen.dart';

class SafeGuardHer extends ConsumerWidget {
  const SafeGuardHer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref)
  {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot)
      {
        if (snapshot.connectionState == ConnectionState.waiting)
        {
          return const SplashScreen();
        }
        else if (snapshot.hasError)
        {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        else if (snapshot.hasData)
        {
          final prefs = snapshot.data!;
          final phoneNumber = prefs.getString('phoneNumber');

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'SafeGuardHer',
            theme: ThemeData(
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
            home: phoneNumber != null ? const HomeScreen() : const LoginScreen(),
          );
        }
        else
        {
          return const Center(child: Text('Unexpected error occurred.'));
        }
      },
    );
  }
}
