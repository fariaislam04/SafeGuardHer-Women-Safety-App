import 'package:flutter/material.dart';
import 'package:safeguardher_flutter_app/screens/tracking_screen/track_others_screen.dart';
import 'package:safeguardher_flutter_app/utils/constants/colors.dart';
import 'package:safeguardher_flutter_app/utils/constants/sizes.dart';
import '../../widgets/navigations/app_bar.dart';
import '../../models/alert_model.dart'; // Import the Alert model if it's not already imported

// This screen contains the bottom drawer sheet that displays contact distance and details.

class TrackCloseContact extends StatefulWidget {
  final String panickedPersonName;
  final String? panickedPersonProfilePic;
  final String panickedPersonSafetyCode;
  final Alert panickedPersonAlertDetails;

  const TrackCloseContact({
    super.key,
    required this.panickedPersonName,
    this.panickedPersonProfilePic,
    required this.panickedPersonSafetyCode,
    required this.panickedPersonAlertDetails,
  });

  @override
  TrackCloseContactState createState() => TrackCloseContactState();
}

class TrackCloseContactState extends State<TrackCloseContact> {
  double _currentChildSize = 0.4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Stack(
        children: [
          const TrackOthersScreen(),
          DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.15,
            maxChildSize: 0.4,
            expand: true,
            builder: (BuildContext context, ScrollController scrollController) {
              return NotificationListener<DraggableScrollableNotification>(
                onNotification: (notification) {
                  setState(() {
                    _currentChildSize = notification.extent;
                  });
                  return true;
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListView(
                    controller: scrollController,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_currentChildSize <= 0.2)
                              Center(
                                child: Container(
                                  width: 70,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            const SizedBox(height: 10),
                            if (_currentChildSize <= 0.2)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(Icons.share_location_rounded, color: Colors.white, size: Sizes.iconMedium),
                                        const SizedBox(width: 5),
                                        Text(
                                          '10 km away',
                                         // '${widget.panickedPersonAlertDetails.distance} Km away',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          // Handle call action
                                          _handleCall();
                                        },
                                        child: const Column(
                                          children: [
                                            Icon(Icons.call),
                                            SizedBox(height: 8),
                                            Text('Call', style: TextStyle(fontFamily: 'Poppins', fontSize: 11)),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 30),
                                      GestureDetector(
                                        onTap: () {
                                          // Handle share action
                                          _handleShare();
                                        },
                                        child: const Column(
                                          children: [
                                            Icon(Icons.share),
                                            SizedBox(height: 8),
                                            Text('Share', style: TextStyle(fontFamily: 'Poppins', fontSize: 11)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            AnimatedOpacity(
                              opacity: _currentChildSize > 0.2 ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 100),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.panickedPersonName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Alert sent on ${widget.panickedPersonAlertDetails.alertStart}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    widget.panickedPersonAlertDetails.userLocationStart as String,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.share_location_rounded, color: Colors.white, size: Sizes.iconMedium),
                                        const SizedBox(width: 5),
                                        Text(
                                         // '${widget.panickedPersonAlertDetails.distance} Km away',
                                          '10 km away',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          // Handle call action
                                          _handleCall();
                                        },
                                        child: const Column(
                                          children: [
                                            Icon(Icons.call, color: AppColors.iconPrimary),
                                            SizedBox(height: 8),
                                            Text('Call', style: TextStyle(fontFamily: 'Poppins')),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          // Handle message action
                                          _handleMessage();
                                        },
                                        child: const Column(
                                          children: [
                                            Icon(Icons.message, color: AppColors.iconPrimary),
                                            SizedBox(height: 8),
                                            Text('Message', style: TextStyle(fontFamily: 'Poppins')),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          // Handle share action
                                          _handleShare();
                                        },
                                        child: const Column(
                                          children: [
                                            Icon(Icons.share, color: AppColors.iconPrimary),
                                            SizedBox(height: 8),
                                            Text('Share', style: TextStyle(fontFamily: 'Poppins')),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _handleCall() {
    // Implement call action here
  }

  void _handleMessage() {
    // Implement message action here
  }

  void _handleShare() {
    // Implement share action here
  }
}
