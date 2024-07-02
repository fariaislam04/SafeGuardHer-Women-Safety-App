import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() {
  runApp(const MaterialApp(
    home: SafetyOnTheStreetsPage(),
  ));
}

class SafetyOnTheStreetsPage extends StatelessWidget {
  const SafetyOnTheStreetsPage({super.key});

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
                    'assets/illustrations/safety_at_street.svg',
                    height: 200,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Safety for Women on the Streets',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Color(0xFF831D2D),
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Ensuring safety on the streets is crucial. Here are some tips to help you keep yourself safe:',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  '1. Stay Alert:\n'
                      'Always be aware of your surroundings and avoid distractions like using your phone while walking.',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  '2. Walk in Well-Lit Areas:\n'
                      'Stick to well-lit streets and avoid dark alleys or isolated areas.',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  '3. Keep Your Hands Free:\n'
                      'Avoid carrying too many things in your hands so you can react quickly if needed.',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  '4. Trust Your Instincts:\n'
                      'If something doesn’t feel right, trust your instincts and move to a safer location.',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  '5. Share Your Location:\n'
                      'Let someone know where you are and where you are going, especially if you are out late.',
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
