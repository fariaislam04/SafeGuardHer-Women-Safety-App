import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../utils/constants/colors/colors.dart';
import '../auth_screen/login_screen/login_screen.dart';

class OnboardingScreen extends StatelessWidget {
  final List<PageViewModel> pages = [
    PageViewModel(
      titleWidget: Column(
        children: [
          const SizedBox(height: 40),
          SvgPicture.asset('assets/logos/logo.svg', height: 60),
          const SizedBox(height: 30),
        ],
      ),
      bodyWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/illustrations/Onboarding01.svg',
              height: 300),
          const SizedBox(height: 50),
          const Text(
            "Track Anytime, Anywhere!",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Text(
              "Share your route with trusted contacts and enable real-time tracking to ensure your safety, whether you're on a short walk or a long journey!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Poppins',
                  color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    ),
    PageViewModel(
      titleWidget: Column(
        children: [
          const SizedBox(height: 40),
          SvgPicture.asset('assets/logos/logo.svg', height: 60),
          const SizedBox(height: 20),
        ],
      ),
      bodyWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/illustrations/Onboarding02.svg',
              height: 300),
          const SizedBox(height: 50),
          const Text(
            "Instantly Inform Emergency Contacts by One Single Press!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Text(
              "With just a single press, send an emergency alert to your pre-selected contacts, sharing your real-time location and a distress signal for immediate assistance",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF777B84), // Hex color
              ),
            ),
          ),
        ],
      ),
    ),
    PageViewModel(
      titleWidget: Column(
        children: [
          const SizedBox(height: 40),
          SvgPicture.asset('assets/logos/logo.svg', height: 60),
          const SizedBox(height: 0),
        ],
      ),
      bodyWidget: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/illustrations/Onboarding03.svg',
              height: 300),
          const SizedBox(height: 50),
          const Text(
            "View Safe Locations While Travelling!",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Text(
              "Find and navigate to nearby safe zones marked on the map to ensure a secure journey. Access real-time information about well-lit areas, police stations, and trusted public spaces to enhance your safety on the go.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Color(0xFF777B84), // Hex color
              ),
            ),
          ),
        ],
      ),
    ),
  ];

  void _onIntroEnd(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalBackgroundColor: Colors.white,
      pages: pages,
      onDone: () => _onIntroEnd(context),
      showSkipButton: true,
      skip: const Text(
        "Skip",
        style: TextStyle(
          color: Color(0xFFD20451), // Hex color
        ),
      ),
      next: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFD20451), // Cool background color
          borderRadius: BorderRadius.circular(20), // Rounded corners
        ),
        child: const Text(
          "Continue",
          style: TextStyle(
            color: Colors.white, // Text color
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      done: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFD20451), // Cool background color
          borderRadius: BorderRadius.circular(20), // Rounded corners
        ),
        child: const Text(
          "Done",
          style: TextStyle(
            color: Colors.white, // Text color
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeColor: Color(0xFFD20451),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
