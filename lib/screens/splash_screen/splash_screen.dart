import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:safeguardher_flutter_app/screens/home_screen/home_screen.dart';
import 'package:safeguardher_flutter_app/screens/onboarding_screen/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../../utils/constants/colors/colors.dart';
import '../../utils/constants/image_strings/image_strings.dart';
import '../../utils/helpers/helper_functions.dart';

AppHelperFunctions appHelperFunctions = AppHelperFunctions();

/// This screen shows itself the first time the user opens the app. If the
/// user has not screen onboarding screen yet, then it shows the onboarding screen. Otherwise, it shows the Home screen.

class SplashScreen extends StatefulWidget
{
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
{
  @override
  void initState()
  {
    super.initState();
    _startTimer();
  }

  Future<void> _startTimer() async
  {
    final prefs = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 3));
    bool appOpenedBefore = prefs.getBool('appOpenedBefore') ?? false;
    appOpenedBefore = false; //comment this on production

    if (appOpenedBefore)
    {
       appHelperFunctions.goTo(context, const HomeScreen());
    }
    else
    {
       appHelperFunctions.goTo(context, OnboardingScreen());
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double logoHeight = constraints.maxHeight * 0.3;
          return Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Padding(
                      padding: const EdgeInsets.only(left: 40, right: 40),
                      child: SvgPicture.asset(
                        ImageStrings.splashLogo,
                        height: logoHeight,
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 60),
                      child: LinearProgressIndicator(
                        color: Colors.white,
                        backgroundColor: Colors.white24,
                      ),
                    ),
                  ],
                ),
              ),
              const Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    '© 2024 SafeGuardHer',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}