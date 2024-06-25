import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: SafetyAtWorkPage(),
  ));
}

class SafetyAtWorkPage extends StatelessWidget {
  const SafetyAtWorkPage({super.key});

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
                    'assets/illustrations/safety_at_work.png',
                    height: 200,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Safety for Women at Work',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Color(0xFF831D2D), // Adjust color if needed
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Ensuring safety for women in the workplace is crucial. Here are some tips to help you keep yourself safe:',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins', // Adjust font family if needed
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  '1. Be Aware of Your Surroundings:\n'
                      'Always be mindful of what is happening around you. Avoid secluded areas and always let someone know where you are.',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins', // Adjust font family if needed
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  '2. Know Your Workplace Policies:\n'
                      'Familiarize yourself with your workplace safety policies and procedures. This includes knowing how to report incidents and where to go for help.',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins', // Adjust font family if needed
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  '3. Trust Your Instincts:\n'
                      'If something doesn’t feel right, trust your instincts. It’s better to be safe and report any suspicious activity or behavior to the appropriate authorities.',
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
