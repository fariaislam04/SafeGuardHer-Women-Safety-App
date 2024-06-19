import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:safeguardher_flutter_app/screens/home_screen/home_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                SvgPicture.asset(
                  'assets/logos/logo.svg',
                  height: 60,
                ),
                const SizedBox(height: 5),
                SvgPicture.asset(
                  'assets/illustrations/login.svg',
                  height: 300,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    // Add your login logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD20451), // Button color
                    padding: const EdgeInsets.symmetric(
                        horizontal: 150, vertical: 8),
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white, // Hex color
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text('Or'),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    // Add your Google login logic here
                  },
                  icon: const Icon(Icons.account_circle),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4C85EA), // Button color
                    padding: const EdgeInsets.symmetric(
                        horizontal: 70, vertical: 10),
                  ),
                  label: const Text(
                    "Continue using Google",
                    style: TextStyle(
                      color: Colors.white, // Hex color
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(color: Colors.black),
                    ),
                    TextButton(
                      onPressed: () {
                        // Add your sign-up navigation logic here
                      },
                      child: const Text(
                        "SIgn up here",
                        style: TextStyle(color: Colors.pink),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Want to start right away?',
                      style: TextStyle(color: Colors.black),
                    ),
                    TextButton(
                      onPressed: () {
                        // Add your quick start logic here
                      },
                      child: const Text(
                        'Click here',
                        style: TextStyle(color: Colors.pink),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
