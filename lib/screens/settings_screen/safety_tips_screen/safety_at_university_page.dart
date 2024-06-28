import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const MaterialApp(
    home: SafetyAtUniversityPage(),
  ));
}

class SafetyAtUniversityPage extends StatelessWidget {
  const SafetyAtUniversityPage({super.key});

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
                    'assets/illustrations/safety_at_university.svg',
                    height: 200,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Safety for Women at University',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Color(0xFF831D2D), // Adjust color if needed
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Ensuring safety for women at university is crucial. Here are some tips to help you keep yourself safe:',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins', // Adjust font family if needed
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  '1. Be Aware of Your Surroundings:\n'
                      'Always stay alert and be aware of your surroundings, especially in secluded or poorly lit areas.',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins', // Adjust font family if needed
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  '2. Use Campus Security Services:\n'
                      'Make use of campus security services such as escort services and emergency call boxes if available.',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins', // Adjust font family if needed
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  '3. Stay Connected:\n'
                      'Always let someone know your whereabouts and have a friend or family member you can check in with regularly.',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins', // Adjust font family if needed
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  '4. Attend Safety Workshops:\n'
                      'Participate in any safety workshops or self-defense classes offered by the university.',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins', // Adjust font family if needed
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  '5. Trust Your Instincts:\n'
                      'If something doesn’t feel right, trust your instincts and seek help immediately.',
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
