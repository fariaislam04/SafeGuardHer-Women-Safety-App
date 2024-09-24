import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:safeguardher_flutter_app/models/alert_model.dart';

import '../../screens/tracking_screen/track_emergency_contact_location_map.dart';
import '../../utils/constants/colors.dart';

class TrackEmergencyContactLocationNotificationWidget extends ConsumerWidget {
  final String panickedPersonName;
  final String panickedPersonProfilePic;
  final Alert panickedPersonAlertDetails;

  const TrackEmergencyContactLocationNotificationWidget({
    super.key,
    required this.panickedPersonName,
    required this.panickedPersonProfilePic,
    required this.panickedPersonAlertDetails,

  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fetching screen size to make the widget responsive
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        // Optional onTap handler for the entire container if needed
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: screenHeight * 0.02,
          horizontal: screenWidth * 0.05,
        ),
        decoration: BoxDecoration(
          color: Colors.white, // Change background color to white
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3), // Add a shadow for depth
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // Shadow position
            ),
          ],

        ),
        child: Row(
          children: [
            AvatarGlow(
              glowColor: Colors.pinkAccent,
             glowRadiusFactor: 0.3,
              child: Container(
                padding: EdgeInsets.all(screenWidth * 0.01),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.pinkAccent,
                    width: 2.0,
                  ),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[100],
                  radius: screenWidth * 0.08,
                  backgroundImage: panickedPersonProfilePic.isNotEmpty
                      ? NetworkImage(panickedPersonProfilePic)
                      : const NetworkImage(
                    'https://firebasestorage.googleapis.com/v0/b/safeguardher-app.appspot.com/o/profile_pics%2F01719958727%2F1000007043.png?alt=media&token=34a85510-d1e2-40bd-b84b-5839bef880bc',
                  ),
                ),
              ),
            ),
            SizedBox(width: screenWidth * 0.05),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    panickedPersonName,
                    style: TextStyle(
                      color: Colors.black87,
                      fontFamily: 'Poppins',
                      fontSize: screenWidth * 0.03,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    "Shared their live location with you.",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: screenWidth * 0.022,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: screenWidth * 0.03),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TrackEmergencyContactLocationMap(
                          panickedPersonName: panickedPersonName,
                          panickedPersonProfilePic: panickedPersonProfilePic,
                          panickedPersonAlertDetails: panickedPersonAlertDetails
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: Text(
                    "Track them",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: screenWidth * 0.03,
                      color: Colors.white,
                    ),
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
