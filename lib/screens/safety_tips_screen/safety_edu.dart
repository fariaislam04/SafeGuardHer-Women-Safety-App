import 'package:flutter/material.dart';
import 'safety_at_work_page.dart';
import 'safety_at_home_page.dart';
import 'safety_at_university_page.dart';
import 'women_safety_online_page.dart';
import 'safety_on_the_streets_page.dart';

void main() {
  runApp(SafeGuardHerApp());
}

class SafeGuardHerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeGuardHer',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: SafetyTipsPage(),
    );
  }
}

class SafetyTipsPage extends StatelessWidget {
  final List<String> safetyTips = [
    'Safety at Work',
    'Safety at Home',
    'Safety at University',
    'Women Safety Online',
    'Safety on the Streets',
  ];

  final Color customColor = const Color(0xFF6C022A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Safety Tips'),
        backgroundColor: customColor,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: safetyTips.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: customColor,
                padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () {
                _navigateToPage(context, index);
              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  safetyTips[index],
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _navigateToPage(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SafetyAtWorkPage()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SafetyAtHomePage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SafetyAtUniversityPage()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WomenSafetyOnlinePage()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SafetyOnTheStreetsPage()),
        );
        break;
    }
  }
}
