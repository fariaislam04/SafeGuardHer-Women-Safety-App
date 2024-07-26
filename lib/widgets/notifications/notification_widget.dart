import 'package:flutter/material.dart';
import 'package:safeguardher_flutter_app/screens/home_screen/home_screen.dart';
import '../../screens/tracking_screen/track_others_bottom_drawer.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';
import 'package:avatar_glow/avatar_glow.dart';

class NotificationWidget extends StatelessWidget {
  final String name;
  final String code;

  const NotificationWidget({
    super.key,
    required this.name,
    required this.code,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        appHelperFunctions.goToScreenAndComeBack(context, const TrackCloseContact());
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
                  backgroundImage: const AssetImage(
                    'assets/placeholders/binita.png',
                  ),
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
                    name,
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
                  "Safe Code",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: Sizes.fontHeading,
                  ),
                ),
                Text(
                  code,
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
