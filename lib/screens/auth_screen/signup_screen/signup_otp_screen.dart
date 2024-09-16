import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:safeguardher_flutter_app/screens/auth_screen/signup_screen/signup_done_screen.dart';
import 'package:safeguardher_flutter_app/screens/auth_screen/signup_screen/signup_screen2.dart';

class SignUpOTPScreen extends StatefulWidget {
  final String username;
  final String phoneNumber;
  final String gender;
  final String email;
  final String password;
  final String otpCode;

  const SignUpOTPScreen({
    Key? key,
    required this.username,
    required this.phoneNumber,
    required this.gender,
    required this.email,
    required this.password,
    required this.otpCode,
  }) : super(key: key);

  @override
  _SignUpOTPScreenState createState() => _SignUpOTPScreenState();
}

class _SignUpOTPScreenState extends State<SignUpOTPScreen> {
  final List<TextEditingController> _controllers =
      List.generate(4, (index) => TextEditingController());
  late final String _correctCode = widget.otpCode;

  bool get _isButtonEnabled =>
      _controllers.every((controller) => controller.text.isNotEmpty) &&
      _otpInput == _correctCode;

  String _otpInput = '';
  int _resendCountdown = 30;
  Timer? _resendTimer;

  @override
  void initState() {
    super.initState();
    startResendTimer();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }

  void startResendTimer() {
    _resendTimer?.cancel(); // Cancel any existing timer
    _resendCountdown = 30; // Reset the countdown
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        setState(() {
          _resendCountdown--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void resendOTP() {
    startResendTimer(); // Reset and start the timer again
  }

  // Function to write to Firestore
  Future<void> _addUserToFirestore() async {
    final firestore = FirebaseFirestore.instance;

    // Create a document in the 'users' collection using the phoneNumber as the document ID
    await firestore.collection('users').doc(widget.phoneNumber).set({
      'name': widget.username,
      'phone': widget.phoneNumber,
      'gender': widget.gender,
      'email': widget.email,
      'pwd': widget.password,
    });

    // After successfully adding to Firestore, navigate to SignUpDoneScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const SignUpDoneScreen(),
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
                            builder: (context) => const SignUpScreen2(
                                  username: '',
                                  phoneNumber: '',
                                  gender: '',
                                )),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 100),
              SvgPicture.asset(
                'assets/logos/logo.svg',
                height: 60,
              ),
              const SizedBox(height: 30),
              const Text(
                'Verify OTP',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Please enter the OTP verification code sent to your email (fa***@gmail.com)',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  return _buildOtpBox(index);
                }),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isButtonEnabled
                    ? () async {
                        await _addUserToFirestore(); // Save data to Firestore
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      _isButtonEnabled ? const Color(0xFFD20451) : Colors.grey,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 120, vertical: 14),
                ),
                child: const Text(
                  "Verify",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Didn't receive the code? ",
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins',
                        fontSize: 12),
                  ),
                  TextButton(
                    onPressed: resendOTP, // Always allow to resend
                    child: Text(
                      _resendCountdown > 0
                          ? "Resend ($_resendCountdown s)"
                          : "Resend",
                      style: TextStyle(
                          color:
                              _resendCountdown > 0 ? Colors.grey : Colors.pink,
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

  Widget _buildOtpBox(int index) {
    return Container(
      width: 50,
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: TextFormField(
          controller: _controllers[index],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 1,
          onChanged: (value) {
            setState(() {
              _otpInput =
                  _controllers.map((controller) => controller.text).join();
            });
            if (value.isNotEmpty && index < 3) {
              FocusScope.of(context).nextFocus();
            }
          },
          decoration: const InputDecoration(
            counterText: '',
            border: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
