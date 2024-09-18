import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../utils/constants/colors.dart';

class TrackOthersAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String panickedPersonName;
  final GeoPoint userEndLocation;
  final GeoPoint? currentLocation;

  const TrackOthersAppBar({
    super.key,
    required this.panickedPersonName,
    required this.userEndLocation,
    this.currentLocation,
  });

  @override
  _TrackOthersAppBarState createState() => _TrackOthersAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(150);
}

class _TrackOthersAppBarState extends State<TrackOthersAppBar> {
  String address = "Loading...";

  @override
  void initState() {
    super.initState();
    _getAddress();
  }

  Future<void> _getAddress() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        widget.userEndLocation.latitude,
        widget.userEndLocation.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        String postalCode = placemark.postalCode ?? 'N/A';
        String locality = placemark.locality ?? 'Unknown locality';
        String street = placemark.thoroughfare ?? '';
        String subLocality = placemark.subLocality ?? '';

        List<String> addressComponents = [];
        if (street.isNotEmpty) addressComponents.add(street);
        if (subLocality.isNotEmpty) addressComponents.add(subLocality);
        if (locality.isNotEmpty) addressComponents.add(locality);
        if (postalCode.isNotEmpty) addressComponents.add(postalCode);

        String addressLine = addressComponents.join(', ');

        setState(() {
          address = addressLine.isEmpty ? "No address found" : addressLine;
        });
      } else {
        setState(() {
          address = "No address found";
        });
      }
    } catch (e) {
      setState(() {
        address = "Error fetching address";
      });
      print("Error fetching address: $e");
    }
  }



  @override
  Widget build(BuildContext context) {
    final LatLng userEndLatLng = _geoPointToLatLng(widget.userEndLocation);
    final LatLng currentLatLng = _geoPointToLatLng(widget.currentLocation!);
    final distance = _calculateDistance(currentLatLng, userEndLatLng);
    final distanceText = distance < 1
        ? "${(distance * 1000).toInt()} meters"
        : "${distance.toStringAsFixed(2)} km";
    final estimatedTime = _estimateTravelTime(distance);

    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            Text(
              "${widget.panickedPersonName}’s Current Location",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.my_location_rounded, color: AppColors
                    .secondary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "$address ($distanceText away)",
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.7),
                      fontSize: 12,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, color: AppColors.secondary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Estimated time: $estimatedTime",
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.7),
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  LatLng _geoPointToLatLng(GeoPoint geoPoint) {
    return LatLng(geoPoint.latitude, geoPoint.longitude);
  }

  double _calculateDistance(LatLng start, LatLng end) {
    const double earthRadius = 6371.0; // Radius of the Earth in kilometers

    double lat1 = start.latitude;
    double lon1 = start.longitude;
    double lat2 = end.latitude;
    double lon2 = end.longitude;

    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
            sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  String _estimateTravelTime(double distance) {
    const double averageSpeedKmH = 40.0; // Average speed in km/h
    const double averageSpeedKmPerMinute = averageSpeedKmH / 60.0; // km/min

    if (distance <= 0) return "N/A";

    double minutes = distance / averageSpeedKmPerMinute;
    if (minutes < 60) {
      return "${minutes.toInt()} minutes";
    } else if (minutes < 1440) { // less than a day
      int hours = (minutes / 60).toInt();
      int mins = (minutes % 60).toInt();
      return "$hours hours $mins minutes";
    } else { // more than a day
      int days = (minutes / 1440).toInt();
      int hours = ((minutes % 1440) / 60).toInt();
      return "$days days $hours hours";
    }
  }

  double _toRadians(double degree) {
    return degree * pi / 180;
  }
}
