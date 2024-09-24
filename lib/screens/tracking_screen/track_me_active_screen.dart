import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../home.dart';
import '../../models/alert_model.dart';
import '../../models/track_me_alert_model.dart';
import '../../providers.dart';
import '../../widgets/custom_widgets/track_me_countdown_widget.dart';
import '../../widgets/navigations/bottom_navbar.dart';
import '../home_screen/home_screen.dart';
import '../tracking_screen/custom_marker.dart';
import 'networking.dart';

class TrackMeActiveScreen extends ConsumerStatefulWidget {
  final TrackMeAlert alert;

  const TrackMeActiveScreen({Key? key, required this.alert}) : super(key: key);

  @override
  _TrackMeActiveScreenState createState() => _TrackMeActiveScreenState();
}

class _TrackMeActiveScreenState extends ConsumerState<TrackMeActiveScreen> {
  GoogleMapController? mapController;
  Location location = Location();
  LatLng? currentLocation;
  LatLng? alertLocation;
  BitmapDescriptor? userProfilePicMarker;
  StreamSubscription<LocationData>? locationSubscription;

  Set<Polyline> polyLines = {};
  List<LatLng> polylineCoordinates = [];

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    alertLocation = LatLng(
      widget.alert.userLocationStart.latitude,
      widget.alert.userLocationStart.longitude,
    );
    _initializeLocationListener();
  }

  void _initializeLocationListener() {
    locationSubscription =
        location.onLocationChanged.listen((LocationData locData) {
          setState(() {
            currentLocation = LatLng(locData.latitude!, locData.longitude!);
          });

          if (mapController != null) {
            mapController!.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: currentLocation!,
                  zoom: 15.0,
                  tilt: 80,
                  bearing: 30,
                ),
              ),
            );
          }

          getRouteData();
          _updateLocationInFirestore();
        });
  }

  void getRouteData() async {
    if (currentLocation != null && alertLocation != null) {
      NetworkHelper network = NetworkHelper(
        startLat: currentLocation!.latitude,
        startLng: currentLocation!.longitude,
        endLat: alertLocation!.latitude,
        endLng: alertLocation!.longitude,
      );

      try {
        var data = await network.getData();
        if (data != null && data['features'] != null && data['features'].isNotEmpty) {
          List<dynamic> coordinates = data['features'][0]['geometry']['coordinates'];
          polylineCoordinates.clear();

          for (var point in coordinates) {
            polylineCoordinates.add(LatLng(point[1], point[0]));
          }

          if (polylineCoordinates.isNotEmpty) {
            setPolyLines();
          }
        } else {
          print("Invalid response structure or empty features.");
        }
      } catch (e) {
        print("Error: $e");
      }
    }
  }

  void setPolyLines() {
    Polyline polyline = Polyline(
      polylineId: const PolylineId("route"),
      points: polylineCoordinates,
      color: Colors.blue,
      width: 5,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      geodesic: false,
      jointType: JointType.round,
    );

    setState(() {
      polyLines.clear();
      polyLines.add(polyline);
    });
  }

  Future<void> _initializeUserProfileMarker(String profilePicUrl) async {
    BitmapDescriptor marker = await CustomMarker()
        .createCustomTeardropMarker(profilePicUrl, Colors.blue);
    setState(() {
      userProfilePicMarker = marker;
    });
  }

  Future<void> _updateLocationInFirestore() async {
    final firestore = FirebaseFirestore.instance;

    final userAsyncValue = ref.watch(userStreamProvider);
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? phoneNumber = pref.getString("phoneNumber");

    userAsyncValue.whenData((user) async {
      if (user != null) {
        try {
          final alertDocRef = firestore
              .collection("users")
              .doc(phoneNumber)
              .collection('alerts')
              .doc(widget.alert.alertId);

          await firestore.runTransaction((transaction) async {
            final alertDoc = await transaction.get(alertDocRef);
            if (!alertDoc.exists) {
              throw Exception("Alert document does not exist!");
            }

            transaction.update(alertDocRef, {
              'user_locations.user_location_end': GeoPoint(
                currentLocation!.latitude,
                currentLocation!.longitude,
              ),
              'alert_duration.alert_end': Timestamp.now()
            });
          });

          print('User location updated in Firestore');
        } catch (e) {
          print('Error updating location in Firestore: $e');
        }
      }
    });
  }

  Future<void> _navigateToHome() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  void dispose() {
    locationSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userAsyncValue = ref.watch(userStreamProvider);

    userAsyncValue.whenData((user) {
      if (user != null && userProfilePicMarker == null) {
        _initializeUserProfileMarker(user.profilePic);
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              onMapCreated: (controller) {
                setState(() {
                  mapController = controller;
                });
              },
              initialCameraPosition: CameraPosition(
                target: currentLocation ?? alertLocation!,
                zoom: 15.0,
                tilt: 80,
                bearing: 30,
              ),
              markers: {
                if (alertLocation != null)
                  Marker(
                    markerId: const MarkerId('alertLocation'),
                    position: alertLocation!,
                    icon: BitmapDescriptor.defaultMarker,
                    infoWindow: const InfoWindow(title: 'Alert Location'),
                  ),
                if (currentLocation != null && userProfilePicMarker != null)
                  Marker(
                    markerId: const MarkerId('currentLocation'),
                    position: currentLocation!,
                    icon: userProfilePicMarker!,
                    infoWindow: const InfoWindow(title: 'Your Current Location'),
                  ),
              },
              polylines: polyLines,
            ),
            Positioned(
              top: 10,
              right: 10,
              left: 10,
              child: TrackMeCountdownWidget(
                alertedContacts: widget.alert.alertedContacts,
                alertLimit: widget.alert.trackMeLimit,
                alertId: widget.alert.alertId,
                userCurrentLocation: currentLocation,
                onConfirm: _navigateToHome, // Callback for navigation
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
