import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const MaterialApp(
    home: WomenSafetyAtOnlinePage(),
  ));
}

class WomenSafetyAtOnlinePage extends StatelessWidget {
  const WomenSafetyAtOnlinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SvgPicture.asset(
                    'assets/illustrations/safety_at_online.svg', // Ensure you have this SVG file
                    height: 200,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Safety for Women Online',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Color(0xFF831D2D), // Adjust color if needed
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Ensuring safety for women online is crucial. Here are some tips to help you keep yourself safe:',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins', // Adjust font family if needed
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  '1. Be Mindful of What You Share:\n'
                      'Avoid sharing personal details like your address, phone number, or financial information online.',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins', // Adjust font family if needed
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  '2. Use Strong, Unique Passwords:\n'
                      'Create strong, unique passwords for each of your accounts and update them regularly.',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins', // Adjust font family if needed
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  '3. Enable Two-Factor Authentication:\n'
                      'Use two-factor authentication for added security.',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins', // Adjust font family if needed
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  '4. Protect Your Privacy:\n'
                      'Regularly review and update your privacy settings on social media and other platforms.',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins', // Adjust font family if needed
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  '5. Recognize and Report Cyberbullying:\n'
                      'Block and report individuals who harass or bully you online.',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins', // Adjust font family if needed
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  '6. Be Cautious with Online Interactions:\n'
                      'Be wary of interacting with strangers and avoid sharing personal details in public forums.',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins', // Adjust font family if needed
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  '7. Secure Your Devices:\n'
                      'Use antivirus software and keep your devices updated to protect against malware and other threats.',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins', // Adjust font family if needed
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  '8. Trust Your Instincts:\n'
                      'If something feels off, trust your instincts and take action to protect yourself.',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins', // Adjust font family if needed
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16.0),
                // ... Add more safety tips here ...
              ],
            ),
          ),
        ),
      ),
    );
  }
}
