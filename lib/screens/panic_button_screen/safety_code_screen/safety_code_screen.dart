import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SafetyCodeScreen extends StatefulWidget {
  const SafetyCodeScreen({super.key});

  @override
  SafetyCodeScreenState createState() => SafetyCodeScreenState();
}

class SafetyCodeScreenState extends State<SafetyCodeScreen> {
  final List<TextEditingController> _controllers = List.generate(4, (index) => TextEditingController());
  final String _correctCode = "2001";
  String _message = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6C022A),
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        // Handle back button logic here
                      },
                    ),
                    const Spacer(flex: 5),
                    SvgPicture.asset('assets/logos/logo_dark_theme.svg', height: 80),
                    const Spacer(flex: 2),
                  ],
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 30),
                      const Text(
                        'Your close contacts have been\nnotified and help will arrive soon',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      const SizedBox(height: 40),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: SvgPicture.asset('assets/icons/bell_ring.svg', height: 60),
                        ),
                      ),
                      const SizedBox(height: 40),
                      _message.isEmpty
                          ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(4, (index) {
                          return Container(
                            width: 50,
                            height: 50,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: TextField(
                              controller: _controllers[index],
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              textAlign: TextAlign.center,
                              decoration: const InputDecoration(
                                counterText: '',
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                if (value.length == 1 && index < 3) {
                                  FocusScope.of(context).nextFocus();
                                }
                              },
                            ),
                          );
                        }),
                      )
                          : Text(
                        _message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _verifyCode,
                        child: const Text('Verify Code'),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          // Handle resend OTP logic here
                        },
                        child: const Text(
                          'Resend safe OTP',
                          style: TextStyle(color: Color(0xFF6C022A)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _verifyCode() {
    String inputCode = _controllers.map((e) => e.text).join();
    if (inputCode == _correctCode) {
      setState(() {
        _message =
        "Safe Code Verified!\nYou will be redirected to Report Incident page soon.";
      });
    } else {
      setState(() {
        _message = "Please try again";
      });
      for (var controller in _controllers) {
        controller.clear();
      }
    }
  }
}
