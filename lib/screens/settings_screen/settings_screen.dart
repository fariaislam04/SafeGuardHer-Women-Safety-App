import 'package:flutter/material.dart';
import 'package:safeguardher_flutter_app/screens/settings_screen/safety_tips_screen/safety_edu.dart';
import 'package:safeguardher_flutter_app/utils/constants/colors.dart';
import 'package:safeguardher_flutter_app/utils/helpers/helper_functions.dart';
import 'package:safeguardher_flutter_app/widgets/templates/settings_template.dart';
import 'contacts_screen/contacts_screen.dart';
import 'devices_screen/devices_screen.dart';
import 'history/history_screen.dart';

const String userEmail = "musarrat.mayeesha@gmail.com";
const String userName = "Mayeesha Musarrat";
const String userProfileImageUrl = "";

AppHelperFunctions appHelperFunctions = AppHelperFunctions();

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsTemplate(
      child: Column(
        children: [
          buildProfileContainer(),
          const SizedBox(height: 20.0),
          Wrap(
            spacing: 30.0,
            runSpacing: 20.0,
            alignment: WrapAlignment.spaceBetween,
            children: [
              buildButton(context, Icons.history, 'History', () {
                appHelperFunctions.goToScreenAndComeBack(context, const HistoryScreen());
              }),
              buildButton(context, Icons.perm_contact_calendar_rounded, 'Contacts', () {
                appHelperFunctions.goToScreenAndComeBack(context, const ContactsScreen());
              }),
              buildButton(context, Icons.security, 'Safety Tips', () {
                appHelperFunctions.goToScreenAndComeBack(context, SafetyTipsPage());
              }),
              buildButton(context, Icons.devices_other_rounded, 'Devices', () {
                appHelperFunctions.goToScreenAndComeBack(context, const DevicesScreen());
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildButton(BuildContext context, IconData icon, String text, VoidCallback onPressed) {
    return SizedBox(
      width: 130,
      height: 110,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          border: Border.all(color: const Color(0XFFE8DCDC), width: 1.0),
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: AppColors.primary,
                size: 50.0,
              ),
              const SizedBox(height: 10),
              Text(
                text,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfileContainer()
  {
    return Container(
      height: 100.0,
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
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
                      userEmail,
                      style: TextStyle(fontSize: 14.0, fontFamily: 'Poppins'),
                    ),
                    Text(
                      userName,
                      style: TextStyle(
                        fontSize: 11.0,
                        color: Colors.grey,
                        fontFamily: 'Poppins',
                      ),
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
}