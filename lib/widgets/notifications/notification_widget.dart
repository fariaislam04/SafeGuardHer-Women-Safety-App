import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safeguardher_flutter_app/utils/constants/colors.dart';
import 'package:safeguardher_flutter_app/utils/constants/sizes.dart';
import 'package:avatar_glow/avatar_glow.dart';
import '../../models/alert_model.dart';
import '../../screens/tracking_screen/track_others_bottom_drawer.dart';

class NotificationWidget extends ConsumerWidget {
  final String panickedPersonName;
  final String panickedPersonProfilePic;
  final String panickedPersonSafetyCode;
  final Alert panickedPersonAlertDetails;

  const NotificationWidget({
    super.key,
    required this.panickedPersonName,
    required this.panickedPersonProfilePic,
    required this.panickedPersonSafetyCode,
    required this.panickedPersonAlertDetails,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TrackOthersBottomDrawer(
              panickedPersonName: panickedPersonName,
              panickedPersonProfilePic: panickedPersonProfilePic,
              panickedPersonSafetyCode: panickedPersonSafetyCode,
              panickedPersonAlertDetails: panickedPersonAlertDetails,
            ),
          ),
        );
      },
      child: Container(
        height: 105.0,
        padding: const EdgeInsets.all(15.0),
        decoration: const BoxDecoration(
          color: AppColors.error,
        ),
        child: Row(
          children: [
            AvatarGlow(
              child: Container(
                padding: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 2.0,
                  ),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[100],
                  radius: 30.0,
                  backgroundImage: panickedPersonProfilePic != null && panickedPersonProfilePic!.isNotEmpty
                      ? AssetImage(panickedPersonProfilePic!)
                      : const AssetImage('assets/placeholders/default_profile_pic.png') as ImageProvider,
                ),
              ),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    panickedPersonName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Triggered SOS alert",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontSize: 11,
                    ),
                  ),
                  const Text(
                    "Tap for more details",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontSize: Sizes.fontSubtitle,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Safety Code",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: Sizes.fontHeading,
                  ),
                ),
                Text(
                  panickedPersonSafetyCode,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: Sizes.fontLarge,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}