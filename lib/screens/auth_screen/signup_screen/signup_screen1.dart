import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore import
import 'package:safeguardher_flutter_app/screens/auth_screen/signup_screen/signup_screen2.dart';
import '../login_screen/logininfo_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SignUpScreen1(),
    );
  }
}

class SignUpScreen1 extends StatefulWidget {
  const SignUpScreen1({super.key});

  @override
  _SignUpScreen1State createState() => _SignUpScreen1State();
}

class _SignUpScreen1State extends State<SignUpScreen1> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  String? _selectedGender;
  IconData _genderIcon = Icons.female; // Default icon

  bool _isUsernameField = false;
  bool _isPhoneNumberField = false;
  bool _isGenderField = false;
  bool _isCheckingPhone = false; // For phone number check loading state

  bool get _isButtonEnabled =>
      _isUsernameField && _isPhoneNumberField && _isGenderField;

  void _updateGenderField(String? newValue) {
    setState(() {
      _selectedGender = newValue;
      _isGenderField = newValue != null;
      if (newValue == 'Male') {
        _genderIcon = Icons.male;
      } else if (newValue == 'Female') {
        _genderIcon = Icons.female;
      } else {
        _genderIcon = Icons.transgender;
      }
    });
  }

  void _updateUsernameField() {
    setState(() {
      _isUsernameField = _usernameController.text.isNotEmpty;
      _isPhoneNumberField = _phoneNumberController.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
    _usernameController.addListener(_updateUsernameField);
    _phoneNumberController.addListener(_updateUsernameField);
  }

  // Function to check if phone number already exists in Firestore
  Future<bool> _isPhoneNumberExists(String phoneNumber) async {
    setState(() {
      _isCheckingPhone = true;
    });

    // Query the 'users' collection in Firestore to see if the phone number exists
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('phone', isEqualTo: phoneNumber)
        .get();

    setState(() {
      _isCheckingPhone = false;
    });

    // If the query has documents, it means the phone number exists
    return querySnapshot.docs.isNotEmpty;
  }

  void _checkAndProceed() async {
    final phoneNumber = _phoneNumberController.text;

    // Check if the phone number is already in the database
    bool exists = await _isPhoneNumberExists(phoneNumber);

    if (exists) {
      // Show a warning if the phone number exists
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Phone Number In Use'),
          content:
              const Text('The phone number you entered is already registered.'),
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
    } else {
      // If the phone number doesn't exist, proceed to the next screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SignUpScreen2(
            username: _usernameController.text,
            phoneNumber: phoneNumber,
            gender: _selectedGender ?? 'Not specified',
          ),
        ),
      );
    }
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
                            builder: (context) => const LoginInfoScreen()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 0),
              SvgPicture.asset(
                'assets/logos/logo.svg',
                height: 60,
              ),
              const SizedBox(height: 30),
              SvgPicture.asset(
                'assets/illustrations/login1.svg',
                height: 45,
              ),
              const SizedBox(height: 30),
              const Text(
                'User Information',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Please fill up some basic information and we can set up your account on SafeGuardHer!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Username                                                                         ',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: 'Enter your username',
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
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              const Text(
                'Phone Number                                                                      ',
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
                  hintText: 'Enter your phone number',
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  prefixIcon: const Icon(Icons.phone_android),
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
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              const Text(
                'Gender                                                                                 ',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  hintText: 'Select your gender',
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  prefixIcon: Icon(_genderIcon),
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
                value: _selectedGender,
                style: const TextStyle(
                    color: Colors.black, fontSize: 16, fontFamily: 'Poppins'),
                items: <String>['Male', 'Female', 'Others'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontFamily: 'Poppins'),
                    ),
                  );
                }).toList(),
                onChanged: _updateGenderField,
              ),
              const SizedBox(height: 35),
              ElevatedButton(
                onPressed: _isButtonEnabled && !_isCheckingPhone
                    ? _checkAndProceed
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isButtonEnabled ? const Color(0xFFD20451) : Colors.grey,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 110, vertical: 14),
                ),
                child: _isCheckingPhone
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Continue",
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
