import 'package:flutter/material.dart';

class AppColors
{
  AppColors._();

  //App colors
  static const Color primary = Color(0xFF6C022A);
  static const Color secondary = Color(0xFFD20451);
  static const Color accent = Color(0xFFF96A66);

  //Text colors
  static const Color textPrimary = Color(0xFF263238);
  static const Color textSecondary = Color(0xFF777B84);
  static const Color textEmphasis = Color(0xFF6C022A);

  //Background color
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundDark = Color(0xFF6C022A);

  //Panic button gradient color
  static const Gradient panicButtonPressed = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF8E0E3E),
      Color(0xFFD20452)
    ],
  );
  static const Gradient panicButtonUnpressed = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFD20452),
      Color(0xFF8E0E3E)
    ],
  );

  //Button colors
  static const Color buttonPrimary = Color(0xFF6C022A);
  static const Color buttonSecondary = Color(0xFFD20451);
  static const Color buttonDisabled = Color(0xFFB7BBC1);

  //Border colors
  static const Color borderPrimary = Color(0xFF808080);
  static const Color borderFocused = Color(0xFF6C022A);

  //Icon colors
  static const Color iconPrimary = Color(0xFF222222);

  //Divider colors
  static const Color dividerPrimary = Color(0xFFEDEDED);

  //Badge colors
  static const Color badgePrimary = Color(0xFFCE0450);

  //Notification colors
  static const Color error = Color(0xFFF84343);

}