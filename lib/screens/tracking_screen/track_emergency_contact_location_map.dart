import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safeguardher_flutter_app/models/alert_with_contact_model.dart';
import '../../models/alert_model.dart';
import '../../providers.dart';
import 'custom_marker.dart';

class TrackEmergencyContactLocationMap extends ConsumerStatefulWidget {
  final String panickedPersonName;
  final Alert panickedPersonAlertDetails;
  final String panickedPersonProfilePic;

  const TrackEmergencyContactLocationMap({
    super.key,
    required this.panickedPersonName,
    required this.panickedPersonAlertDetails,
    required this.panickedPersonProfilePic,
  });

  @override
  _TrackEmergencyContactLocationMapState createState() =>
      _TrackEmergencyContactLocationMapState();
}

class _TrackEmergencyContactLocationMapState
    extends ConsumerState<TrackEmergencyContactLocationMap> {
  GoogleMapController? mapController;
  LatLng? startLocation;
  LatLng? endLocation;
  List<LatLng> polylineCoordinates = [];
  Set<Polyline> polyLines = {};
  Set<Marker> markers = {};
  BitmapDescriptor? userProfilePicMarker;

  // Placeholder coordinates
  LatLng placeholderStartLocation = LatLng(0,0);
  LatLng placeholderEndLocation = LatLng(0,0);
  // in San Francisco

  @override
  void initState() {
    super.initState();

    // Set placeholder coordinates
    startLocation = placeholderStartLocation;
    endLocation = placeholderEndLocation;
    updatePolyline();
    updateMarkers();
    _initializeUserProfileMarker(widget.panickedPersonProfilePic);
  }

  Future<void> _initializeUserProfileMarker(String profilePicUrl) async {
    BitmapDescriptor marker = await CustomMarker()
        .createCustomTeardropMarker(profilePicUrl, Colors.blue);
    setState(() {
      userProfilePicMarker = marker;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Listen to real-time updates using emergencyContactAlertsStreamProvider
    ref.listen<AsyncValue<List<AlertWithContact>>>(
      emergencyContactAlertsStreamProvider,
          (previous, next) {
        next.whenData((alerts) {
          // Look for the specific alert by alertId
          var alert = alerts.firstWhere(
                (a) => a.alert.alertId == widget.panickedPersonAlertDetails.alertId,
//orElse: () => null,
          );

          if (alert != null) {
            var startGeoPoint = alert.alert.userLocationStart;
            var endGeoPoint = alert.alert.userLocationEnd;

            LatLng newStartLocation =
            LatLng(startGeoPoint.latitude, startGeoPoint.longitude);
            LatLng newEndLocation =
            LatLng(endGeoPoint.latitude, endGeoPoint.longitude);

            setState(() {
              startLocation = newStartLocation;
              endLocation = newEndLocation;
              updatePolyline();
              updateMarkers();

              // Move the camera to the updated end location in real-time
              if (mapController != null) {
                mapController!.animateCamera(
                  CameraUpdate.newLatLng(newEndLocation),
                );
              }
            });
          }
        });
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.panickedPersonName} - Location Tracker'),
        centerTitle: true,
      ),
      body: startLocation == null || endLocation == null
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
              mapController!.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: startLocation!,
                    zoom: 15.0,
                    tilt: 80.0,  // Set the tilt to 80 degrees
                    bearing: 30.0, // Set the bearing to 30 degrees
                  ),
                ),
                );
            },
            initialCameraPosition: CameraPosition(
              target: startLocation!,
              zoom: 15.0,
              tilt: 80,
              bearing: 30
            ),
            markers: markers,
            polylines: polyLines,
          ),
          Positioned(
            top: 10,
            right: 10,
            left: 10,
            child: _buildAlertInfo(),
          ),
        ],
      ),
    );
  }

  // Update polyline between startLocation and endLocation
  void updatePolyline() {
    if (startLocation != null && endLocation != null) {
      polylineCoordinates.clear();
      polylineCoordinates.add(startLocation!);
      polylineCoordinates.add(endLocation!);

      Polyline polyline = Polyline(
        polylineId: const PolylineId('route'),
        color: Colors.blue,
        width: 5,
        points: polylineCoordinates,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
      );

      setState(() {
        polyLines.clear();
        polyLines.add(polyline);
      });
    }
  }

  // Update markers for start and end locations
  void updateMarkers() {
    if (startLocation != null && endLocation != null) {
      markers.clear();

      // Marker for start location
      markers.add(
        Marker(
          markerId: const MarkerId('startLocation'),
          position: startLocation!,
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(
            title: '${widget.panickedPersonName}\'s Start Location',
          ),
        ),
      );

      // Marker for current/end location
      markers.add(
        Marker(
          markerId: const MarkerId('endLocation'),
          position: endLocation!,
          icon: userProfilePicMarker ?? BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(
            title: '${widget.panickedPersonName}\'s Current Location',
          ),
        ),
      );
    }
  }

  // Widget to display panicked person's info
  Widget _buildAlertInfo() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: widget.panickedPersonProfilePic.isNotEmpty
                ? NetworkImage(widget.panickedPersonProfilePic)
                : const AssetImage('assets/images/default_profile.png')
            as ImageProvider,
            radius: 30,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.panickedPersonName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Shared their live location with you.',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
