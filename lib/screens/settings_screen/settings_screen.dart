import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFF831D2D),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0),
            child: ClipRRect( // Wrap content with ClipRRect for rounded border
              borderRadius: BorderRadius.circular(16.0),
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
                          Navigator.pop(context); // Close SettingsScreen
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
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0,
                            vertical: 30.0),
                        child: Column(
                          children: [
                            buildTopContainer(),
                            Wrap(
                              spacing: 20.0,
                              runSpacing: 20.0,
                              children: [
                                buildButton(Icons.history, 'History'),
                                buildButton(Icons.perm_contact_calendar_rounded, 'Contacts'),
                                buildButton(Icons.security, 'Safety Tips'),
                                buildButton(Icons.devices_other_rounded, 'Devices'),
                              ],
                            ),
                          ],
                        ),
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

  Widget buildButton(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Stack(
        children: [
          ElevatedButton(
            onPressed: () {
              //Handle settings option press
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(100, 100),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: const SizedBox(),
          ),
          Positioned(
            top: 10.0,
            left: 0,
            right: 0,
            child: Center(
              child: Icon(
                icon,
                color: const Color(0xFF6C022A),
                size: 50.0,
              ),
            ),
          ),
          Positioned(
            bottom: 10.0,
            left: 0,
            right: 0,
            child: Center(
              child: Text(text,
              style: const TextStyle(color: Color(0xFF6C022A), fontFamily:
    'Poppins', fontWeight: FontWeight.w500, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget buildTopContainer() {
    return Container(
      height: 100.0,
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
          bottomLeft: Radius.circular(16.0),
          bottomRight: Radius.circular(16.0),
        ),
        border: Border.all(color: const Color(0XFFE8DCDC), width: 1.0),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/placeholders/profile.png'),
                  radius: 30.0,
                ),
                SizedBox(width: 10.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mayeesha Musarrat',
                      style: TextStyle(fontSize: 14.0, fontFamily: 'Poppins'),
                    ),
                    Text(
                      'mayeesha.musarrat@gmail.com',
                      style: TextStyle(fontSize: 11.0, color: Colors.grey, fontFamily: 'Poppins'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLogo()
  {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 30.0),
      child: SvgPicture.asset(
        'assets/logos/logo_dark_theme.svg',
        height: 60.0,
      ),
    );
  }
}
