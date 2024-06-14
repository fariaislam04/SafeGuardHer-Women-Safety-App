import 'package:flutter/material.dart';
import 'package:safeguardher_flutter_app/screens/home_screen/home_screen.dart';
import 'package:safeguardher_flutter_app/screens/panic_button_screen/five_second_panic_screen/five_second_panic_screen.dart';

void main() {
  runApp(const SafeGuardHer());
}

class SafeGuardHer extends StatelessWidget {
  const SafeGuardHer({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
