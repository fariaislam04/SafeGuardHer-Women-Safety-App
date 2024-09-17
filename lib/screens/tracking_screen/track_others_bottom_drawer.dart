import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import if you're using Firestore for GeoPoint
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:geocoding/geocoding.dart'; // Import for geocoding
import 'package:flutter_svg/flutter_svg.dart'; // Import for SVG icons
import 'package:safeguardher_flutter_app/screens/tracking_screen/track_others_screen.dart';
import 'package:safeguardher_flutter_app/utils/constants/colors.dart';
import '../../models/alert_model.dart';
import '../../widgets/navigations/track_others_app_bar.dart';

class TrackOthersBottomDrawer extends StatefulWidget {
  final String panickedPersonName;
  final String panickedPersonProfilePic;
  final String panickedPersonSafetyCode;
  final Alert panickedPersonAlertDetails;

  const TrackOthersBottomDrawer({
    super.key,
    required this.panickedPersonName,
    required this.panickedPersonProfilePic,
    required this.panickedPersonSafetyCode,
    required this.panickedPersonAlertDetails,
  });

  @override
  TrackCloseContactState createState() => TrackCloseContactState();
}

class TrackCloseContactState extends State<TrackOthersBottomDrawer> {
  double _currentChildSize = 0.2;
  String _userLocationStart = '';
  String _formattedTimestamp = '';

  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  Future<void> _fetchDetails() async {
    // Convert timestamp to readable format
    _formattedTimestamp = _formatTimestamp(widget.panickedPersonAlertDetails.alertStart);

    // Convert GeoPoint to location name
    _userLocationStart = await _convertGeoPointToString(widget.panickedPersonAlertDetails.userLocationStart);

    setState(() {}); // Refresh UI after fetching details
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TrackOthersAppBar(
        panickedPersonName: widget.panickedPersonName,
        userEndLocation: widget.panickedPersonAlertDetails.userLocationEnd,
        currentLocation: const GeoPoint(0,0)
      ),
      body: Stack(
        children: [
           TrackOthersScreen(
            panickedPersonName: widget.panickedPersonName,
            panickedPersonProfilePic : widget.panickedPersonProfilePic,
             panickedPersonSafetyCode : widget.panickedPersonSafetyCode,
           ),
          DraggableScrollableSheet(
            initialChildSize: 0.2,
            minChildSize: 0.2,
            maxChildSize: 0.5,
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
                      if (_currentChildSize <= 0.2)
                        _buildMinimizedUI()
                      else
                        _buildExpandedUI(),
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

  Widget _buildMinimizedUI() {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0, left: 8.0, top: 12.0, bottom: 10.0),
      child: Column(
        children: [
          Container(
            height: 5,
            width: 45,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.secondary, width: 2), // Border color and width
                  ),
                  child: CircleAvatar(
                    backgroundImage: widget.panickedPersonProfilePic != null &&
                        widget.panickedPersonProfilePic!.isNotEmpty
                        ? AssetImage(widget.panickedPersonProfilePic!)
                        : const AssetImage('assets/placeholders/default_profile_pic.png') as ImageProvider,
                    radius: 30,
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
              SizedBox(width: 5, height: 10),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.panickedPersonName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'has triggered panic alert!',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.call),
                    onPressed: () {
                      // Handle call action
                    },
                  ),
                  Text('Call', style: TextStyle(fontSize: 10)),
                ],
              ),
              SizedBox(width: 20),
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.share),
                    onPressed: () {
                      // Handle share action
                    },
                  ),
                  const Text('Share', style: TextStyle(fontSize: 10)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0, top: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.secondary, width: 2), // Border color and width
              ),
              child: CircleAvatar(
                backgroundImage: widget.panickedPersonProfilePic != null &&
                    widget.panickedPersonProfilePic!.isNotEmpty
                    ? AssetImage(widget.panickedPersonProfilePic!)
                    : const AssetImage('assets/placeholders/default_profile_pic.png') as ImageProvider,
                radius: 33,
                backgroundColor: Colors.transparent,
              ),
            ),
            title: Text(
              widget.panickedPersonName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            subtitle: Text(
              'Alert sent on $_formattedTimestamp from $_userLocationStart',
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 11,
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 5,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Handle view captured images action
                  },
                  icon: SvgPicture.asset(
                    'assets/icons/view_image.svg',
                    width: 35, // Increase the width of SVG icon
                    height: 35, // Increase the height of SVG icon
                  ),
                  label: Text(
                    'View captured images',
                    style: TextStyle(
                      fontSize: 11, // Decrease font size
                      color: Colors.grey[600], // Color for the label
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(color: AppColors.secondary,),
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.call),
                      onPressed: () {
                        // Handle call action
                      },
                    ),
                    Text('Call', style: TextStyle(fontSize: 10)),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.share),
                      onPressed: () {
                        // Handle share action
                      },
                    ),
                    Text('Share', style: TextStyle(fontSize: 10)),
                  ],
                ),
              ),
            ],
          ),
          Divider(),
          SizedBox(height: 10),
          Text(
            'Tap on “Get Directions” button to navigate in Google Maps',
            style: TextStyle(
              fontWeight: FontWeight.w100,
              fontSize: 9,
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // Handle get directions action
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              minimumSize: Size(double.infinity, 50), // Full width button
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/directions.svg',
                  width: 24, // Adjust the size of SVG icon
                  height: 24, // Adjust the size of SVG icon
                ),
                SizedBox(width: 10),
                const Text(
                  'Get Directions',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    final date = timestamp.toDate();
    final DateFormat formatter = DateFormat('MMMM d, yyyy h:mm a');
    return formatter.format(date);
  }

  Future<String> _convertGeoPointToString(GeoPoint geoPoint) async {
    final placemarks = await placemarkFromCoordinates(geoPoint.latitude, geoPoint.longitude);
    final placemark = placemarks.first;
    return '${placemark.name}, ${placemark.locality}';
  }
}