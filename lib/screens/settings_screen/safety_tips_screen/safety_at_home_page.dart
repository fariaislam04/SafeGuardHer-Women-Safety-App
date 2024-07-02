import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: SafetyAtHomePage(),
  ));
}

class SafetyAtHomePage extends StatelessWidget {
  const SafetyAtHomePage({super.key});

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
                  child: Image.asset(
                    'assets/illustrations/stay-home.png',
                    height: 200,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Safety for Women at Home',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Color(0xFF831D2D),
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Ensuring safety for women at home is crucial. Here are some tips to help you keep yourself safe:',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  '1. Secure Your Doors and Windows:\n'
                      'Always keep your doors and windows locked, even when you\'re at home.',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins', // Adjust font family if needed
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  '2. Install Security Systems:\n'
                      'Use security cameras, alarm systems, and motion sensor lights for added protection.',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  '3. Know Your Neighbors:\n'
                      'Build a rapport with your neighbors so you can watch out for each other.',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  '4. Be Cautious with Strangers:\n'
                      'Don\'t open the door to strangers and verify the identity of service people.',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  '5. Use Peepholes and Door Chains:\n'
                      'Use peepholes and door chains to check who is at the door before opening it.',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  '6. Keep Emergency Contacts Handy:\n'
                      'Have a list of emergency contacts easily accessible.',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  '7. Be Careful with Social Media:\n'
                      'Avoid posting your location or plans online.',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  '8. Trust Your Instincts:\n'
                      'If something feels off, trust your instincts and take action to protect yourself.',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
