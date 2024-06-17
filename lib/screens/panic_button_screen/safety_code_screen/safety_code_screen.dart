import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SafetyCodeScreen extends StatefulWidget {
  @override
  _SafetyCodeScreenState createState() => _SafetyCodeScreenState();
}

class _SafetyCodeScreenState extends State<SafetyCodeScreen> {
  final TextEditingController codeController1 = TextEditingController();
  final TextEditingController codeController2 = TextEditingController();
  final TextEditingController codeController3 = TextEditingController();
  final TextEditingController codeController4 = TextEditingController();

  String verificationStatus = '';

  @override
  void initState() {
    super.initState();
    // Clear the verification status when initializing the screen
    resetVerificationStatus();
  }

  // Function to reset verification status
  void resetVerificationStatus() {
    setState(() {
      verificationStatus = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6C022A),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            SvgPicture.asset('assets/icons/bell_ring.svg'), // Replace with your logo asset
            const SizedBox(height: 30),
            Text(
              'Your close contacts have been notified and help will arrive soon',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 50),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Text(
                    'Enter safe code',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'To stop panic alert, enter the safe code sent to your close contacts',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      buildCodeTextField(codeController1, 1),
                      buildCodeTextField(codeController2, 2),
                      buildCodeTextField(codeController3, 3),
                      buildCodeTextField(codeController4, 4),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    verificationStatus,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      // Resend OTP function
                    },
                    child: Text(
                      'Resend safe OTP',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCodeTextField(TextEditingController controller, int index) {
    return Container(
      width: 50,
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: InputDecoration(
          border: InputBorder.none,
          counterText: "",
        ),
        style: TextStyle(fontSize: 24, color: Colors.black),
        onChanged: (value) {
          // Handle onChanged event
          if (value.length == 1) {
            // Move focus to the next TextField or handle validation
            FocusScope.of(context).nextFocus();

            // Check if all fields are filled
            if (codeController1.text.isNotEmpty &&
                codeController2.text.isNotEmpty &&
                codeController3.text.isNotEmpty &&
                codeController4.text.isNotEmpty) {
              // Check the entered code
              String enteredCode = codeController1.text +
                  codeController2.text +
                  codeController3.text +
                  codeController4.text;
              if (enteredCode == '2001') {
                setState(() {
                  verificationStatus = 'Verified';
                });
              } else {
                setState(() {
                  verificationStatus = 'Please try again';
                  // Clear text fields for retry
                  codeController1.clear();
                  codeController2.clear();
                  codeController3.clear();
                  codeController4.clear();
                });
              }
            }
          }
        },
      ),
    );
  }
}
