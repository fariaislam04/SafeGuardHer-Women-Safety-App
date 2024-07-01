import 'package:flutter/material.dart';
import 'package:safeguardher_flutter_app/screens/track_close_contacts_screen/track_close_contact_map.dart';
import 'package:safeguardher_flutter_app/utils/constants/colors/colors.dart';
import '../../utils/constants/sizes/sizes.dart';
import '../../widgets/navigations/app_bar.dart';

class TrackCloseContact extends StatefulWidget {
  const TrackCloseContact({super.key});

  @override
  TrackCloseContactState createState() =>
      TrackCloseContactState();
}

class TrackCloseContactState extends State<TrackCloseContact> {
  double _currentChildSize = 0.4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Stack(
        children: [
          const TrackCloseContactMap(),
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
                        padding: const EdgeInsets.only(top: 20, bottom: 13.0,
                            left: 20.0, right: 20.0),
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
                            //-- Shrunk drawer
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
                                    child: const Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(Icons.share_location_rounded, color: Colors.white, 
                                            size: Sizes.iconMedium),
                                        SizedBox(width: 5),
                                        Text(
                                          '5.47 Km away',
                                          style: TextStyle(
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
                                        onTap: ()
                                        {

                                        },
                                        child: const Column(
                                          children: [
                                            Icon(Icons.call),
                                            SizedBox(height: 8),
                                            Text('Call', style: TextStyle
                                              (fontFamily: 'Poppins',
                                                fontSize: 11),),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 30),
                                      GestureDetector(
                                        onTap: ()
                                        {

                                        },
                                        child: const Column(
                                          children: [
                                            Icon(Icons.share),
                                            SizedBox(height: 8),
                                            Text('Share',style: TextStyle
                                              (fontFamily: 'Poppins',
                                                fontSize: 11)),
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
                              // -- Expanded Drawer
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Binita Sarker',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Alert sent on Tues, June 4 2024 1:30 AM',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Lalbagh, Dhaka district',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    width: 500,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: const Row(
                                      children: [Icon(Icons
                                          .share_location_rounded, color: Colors.white,
                                          size: Sizes.iconMedium),
                                      SizedBox(width: 5),
                                      Text(
                                        '5.47 Km away',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ]
                                    )
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          // Handle call action
                                        },
                                        child: const Column(
                                          children: [
                                            Icon(Icons.call, color: AppColors.iconPrimary),
                                            SizedBox(height: 8),
                                            Text('Call', style: TextStyle
                                              (fontFamily: 'Poppins'),),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          // Handle message action
                                        },
                                        child: const Column(
                                          children: [
                                            Icon(Icons.message, color: AppColors.iconPrimary),
                                            SizedBox(height: 8),
                                            Text('Message',style: TextStyle
                                                (fontFamily: 'Poppins'),),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: ()
                                        {

                                        },
                                        child: const Column(
                                          children: [
                                            Icon(Icons.share, color: AppColors.iconPrimary),
                                            SizedBox(height: 8),
                                            Text('Share', style: TextStyle
                                              (fontFamily: 'Poppins'),),
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
}
