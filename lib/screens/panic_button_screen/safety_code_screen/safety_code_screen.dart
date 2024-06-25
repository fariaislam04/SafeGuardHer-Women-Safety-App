import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:safeguardher_flutter_app/screens/report_incident_screen/report_incident_screen.dart';
import 'package:safeguardher_flutter_app/widgets/templates/settings_template.dart';

void main() {
  runApp(const MaterialApp(
    home: SafetyCodeScreen(),
  ));
}

class SafetyCodeScreen extends StatefulWidget {
  const SafetyCodeScreen({super.key});

  @override
  SafetyCodeScreenState createState() => SafetyCodeScreenState();
}

class SafetyCodeScreenState extends State<SafetyCodeScreen> {
  final List<TextEditingController> _controllers = List.generate(
      4, (index) => TextEditingController());
  final String _correctCode = "2001";
  String _message = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6C022A),
      body: SettingsTemplate(
        child: Stack(
          children: [
            Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 30),
                      const Text(
                        'Your close contacts have been notified and help will'
                            ' arrive soon',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 17,
                            fontFamily: 'Poppins'),
                      ),
                      const SizedBox(height: 40),
                      _message.isEmpty
                          ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(4, (index) {
                          return Container(
                            width: 70,
                            height: 70,
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
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
                              onChanged: (value)
                              {
                                if (value.length == 1 && index < 3)
                                {
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
                        style: const TextStyle(
                            color: Colors.black, fontSize: 20),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _verifyCode,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF831D2D),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text('Verify Code',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            color: Colors.white
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: ()
                        {
                          // Handle resend OTP logic here
                        },
                        child: const Text(
                          'Resend safe OTP',
                          style: TextStyle(color: Color(0xFF6C022A),
                              fontFamily: 'Poppins'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> navigateToReportIncidentPage(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ReportIncidentPage()),
      );
    }
  }


  void _verifyCode() {
    String inputCode = _controllers.map((e) => e.text).join();
    if (inputCode == _correctCode) {
      setState(() {
        _message =
        "Safe Code Verified!\nYou will be redirected to Report Incident page soon.";
      });
      try {
        navigateToReportIncidentPage(context);
      } catch (error) {
        if (kDebugMode) {
          print("Error navigating to ReportIncidentPage: $error");
        }
        // Handle the error here (e.g., display an error message)
      }
    } else
    {
      setState(()
      {
        _message = "Please try again";
      });
      for (var controller in _controllers) {
        controller.clear();
      }
    }
  }
}