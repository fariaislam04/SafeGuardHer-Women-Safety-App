import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:safeguardher_flutter_app/screens/login_screen/login_screen.dart';
import 'package:safeguardher_flutter_app/screens/home_screen/home_screen.dart';
import 'package:safeguardher_flutter_app/screens/signup_screen/signup_otp_screen.dart';

void main() {
  runApp(SignUpDoneScreen());
}


class SignUpDoneScreen extends StatefulWidget {
  const SignUpDoneScreen({super.key});

  @override
  _SignUpDoneScreenState createState() => _SignUpDoneScreenState();
}

class _SignUpDoneScreenState extends State<SignUpDoneScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignUpOTPScreen()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SvgPicture.asset(
                'assets/logos/logo.svg',
                height: 60,
              ),
              const SizedBox(height: 30),
              SvgPicture.asset(
                'assets/illustrations/signupdone.svg',
                height: 350,
              ),
              const SizedBox(height: 20),
              const Text(
                'Sign Up Successful!',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Thank you for signing up at SafeGuardHer! ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                key: null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD20451),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 143, vertical: 14),
                ),
                child: const Text(
                  "Begin",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
