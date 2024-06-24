import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingsTemplate extends StatelessWidget {
  final Widget child;

  const SettingsTemplate({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFF831D2D),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0),
            child: ClipRRect(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      buildLogo(),
                      IconButton(
                        icon: const Icon(Icons.close),
                        color: Colors.white,
                        padding: const EdgeInsets.only(right: 30.0),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.0),
                          topRight: Radius.circular(16.0),
                          bottomRight: Radius.circular(0.0),
                          bottomLeft: Radius.circular(0.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 30.0),
                        child: child,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLogo() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 30.0),
      child: SvgPicture.asset(
        'assets/logos/logo_dark_theme.svg',
        height: 60.0,
      ),
    );
  }
}
