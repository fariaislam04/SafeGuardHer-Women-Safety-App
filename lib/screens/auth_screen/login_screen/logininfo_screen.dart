import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore import
import 'package:shared_preferences/shared_preferences.dart';
import '../signup_screen/signup_screen1.dart';
import '../../home_screen/home_screen.dart';
import 'package:safeguardher_flutter_app/models/user_model.dart';
import 'login_screen.dart';

void main() {
  runApp(const LoginInfoScreen());
}

class LoginInfoScreen extends StatefulWidget {
  const LoginInfoScreen({super.key});

  @override
  _LoginInfoScreenState createState() => _LoginInfoScreenState();
}

class _LoginInfoScreenState extends State<LoginInfoScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;

  bool get _isButtonEnabled {
    return _phoneNumberController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    _phoneNumberController.addListener(_updateButtonState);
    _passwordController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      // Just trigger a rebuild to update the button state
    });
  }

  // Function to handle login logic
  Future<void> _handleLogin() async {
    String phoneNumber = _phoneNumberController.text;
    String password = _passwordController.text;

    try {
      // Query Firestore for the user document by phone number
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(phoneNumber)
          .get();

      if (userDoc.exists) {
        // Document exists, now check the password
        String storedPassword = userDoc.get('pwd');

        if (storedPassword == password) {
          // Password matches, proceed to the next screen
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('phoneNumber', phoneNumber);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );

        } else {
          // Password does not match
          _showErrorDialog('Incorrect password. Please try again.');
        }
      } else {
        // Phone number does not exist
        _showErrorDialog('Phone number not found. Please sign up.');
      }
    } catch (e) {
      // Handle any errors here (e.g., network issues)
      _showErrorDialog('An error occurred. Please try again later.');
    }
  }

  // Function to show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Failed'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

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
                            builder: (context) => const LoginScreen()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 90),
              SvgPicture.asset(
                'assets/logos/logo.svg',
                height: 60,
              ),
              const SizedBox(height: 30),
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Phone Number                                                                                ',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  hintText:
                      'Enter your phone number', // Placeholder text inside the box
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  prefixIcon: const Icon(Icons.person),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 1.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Password                                                                          ',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText:
                      'Enter your password', // Placeholder text inside the box
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 1.0),
                  ),
                ),
                obscureText: !_passwordVisible,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Add your forgot password logic here
                  },
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      color: Colors.pink,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isButtonEnabled ? _handleLogin : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isButtonEnabled ? const Color(0xFFD20451) : Colors.grey,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 120, vertical: 13),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins',
                        fontSize: 12),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SignUpScreen1()),
                      );
                    },
                    child: const Text(
                      "Sign up here",
                      style: TextStyle(
                          color: Colors.pink,
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
