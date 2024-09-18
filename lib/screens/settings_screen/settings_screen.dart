import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safeguardher_flutter_app/screens/settings_screen/safety_tips_screen/safety_edu.dart';
import 'package:safeguardher_flutter_app/utils/constants/colors.dart';
import 'package:safeguardher_flutter_app/utils/helpers/helper_functions.dart';
import 'package:safeguardher_flutter_app/widgets/templates/settings_template.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user_model.dart';
import '../../providers.dart';
import '../edit_profile_screen/edit_profile_screen.dart';
import 'contacts_screen/contacts_screen.dart';
import 'devices_screen/devices_screen.dart';
import 'history/history_screen.dart';

AppHelperFunctions appHelperFunctions = AppHelperFunctions();

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // Show loading indicator
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}')); // Show error message
        } else if (snapshot.hasData) {
          final prefs = snapshot.data!;
          final phoneNumber = prefs.getString('phoneNumber');

          if (phoneNumber == null) {
            return Center(child: Text('Phone number not found')); // Handle missing phone number
          }

          final userAsyncValue = ref.watch(userStreamProvider);

          return userAsyncValue.when(
            data: (user) {
              return SettingsTemplate(
                child: Column(
                  children: [
                    buildProfileContainer(context, user!),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildButton(context, Icons.history, 'History', () {
                          appHelperFunctions.goToScreenAndComeBack(
                              context, const HistoryPage());
                        }),
                        buildButton(context, Icons.perm_contact_calendar_rounded, 'Contacts', () {
                          appHelperFunctions.goToScreenAndComeBack(
                              context, const ContactsScreen());
                        }),
                        buildButton(context, Icons.security, 'Safety Tips', () {
                          appHelperFunctions.goToScreenAndComeBack(
                              context, SafetyTipsPage());
                        }),
                        // Uncomment when `DevicesScreen` is implemented
                        // buildButton(context, Icons.devices_other_rounded, 'Devices', () {
                        //   appHelperFunctions.goToScreenAndComeBack(context, const DevicesScreen());
                        // }),
                      ],
                    ),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, stack) => Center(child: Text('Error: $e')),
          );
        } else {
          return const Center(child: Text('Unexpected error occurred.'));
        }
      },
    );
  }

  Widget buildButton(BuildContext context, IconData icon, String text, VoidCallback onPressed) {
    return SizedBox(
      width: 110,
      height: 100,
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
                size: 40.0,
              ),
              const SizedBox(height: 8),
              Text(
                text,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProfileContainer(BuildContext context, User user) {
    final String profilePicUrl = user.profilePic.isNotEmpty
        ? user.profilePic
        : 'https://firebasestorage.googleapis.com/v0/b/safeguardher-app.appspot.com/o/profile_pics%2F01719958727%2F1000007043.png?alt=media&token=34a85510-d1e2-40bd-b84b-5839bef880bc';

    return Container(
      height: 100.0,
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        border: Border.all(color: const Color(0XFFE8DCDC), width: 1.0),
      ),
      child: Row(
        children: [
          const SizedBox(width: 20.0),
          Flexible(
            flex: 1,
            child: CircleAvatar(
              backgroundImage: NetworkImage(profilePicUrl),
              radius: 30.0,
              onBackgroundImageError: (exception, stackTrace) {
                if (kDebugMode) {
                  print('Error loading image: $exception');
                }
              },
            ),

          ),
          const SizedBox(width: 10.0),
          Flexible(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20.0),
                Text(
                  user.name.isNotEmpty ? user.name : 'No Name',
                  style: const TextStyle(
                    fontSize: 13.0,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  user.email.isNotEmpty ? user.email : 'No Email',
                  style: const TextStyle(
                    fontSize: 11.0,
                    fontFamily: 'Poppins',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: AppColors.primary),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EditProfileScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
