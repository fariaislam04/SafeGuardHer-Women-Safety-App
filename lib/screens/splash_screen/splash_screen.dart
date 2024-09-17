import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:safeguardher_flutter_app/screens/error_screen/error_screen.dart';
import 'package:safeguardher_flutter_app/screens/home_screen/home_screen.dart';
import 'package:safeguardher_flutter_app/screens/onboarding_screen/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../home.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/image_strings.dart';
import '../../providers.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  Future<void> _startTimer() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 3));
    bool appOpenedBefore = prefs.getBool('appOpenedBefore') ?? false;

    if (appOpenedBefore) {
      final userAsyncValue = ref.watch(userStreamProvider);

      userAsyncValue.when(
        data: (user) {
          if (user == null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) =>  OnboardingScreen()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          }
        },
        loading: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SplashScreen()),
          );
        },
        error: (error, stackTrace) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ErrorScreen()),
          );
        },
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  OnboardingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      padding: const EdgeInsets.symmetric(horizontal: 40),
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
