import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:safeguardher_flutter_app/utils/helpers/helper_functions.dart';
import '../../utils/constants/colors.dart';
import 'custom_marker.dart';

AppHelperFunctions appHelperFunctions = AppHelperFunctions();
CustomMarker customMarker = CustomMarker();


class TrackOthersScreen extends StatefulWidget {
  const TrackOthersScreen({super.key});

  @override
  State<TrackOthersScreen> createState() => TrackOthersScreenState();
}

class TrackOthersScreenState extends State<TrackOthersScreen>
    with SingleTickerProviderStateMixin {
  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng destination = LatLng(23.775236, 90.389916);

  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocationOfTheUser;
  late List<Marker> _markers = [];
  late Set<Circle> _circles = {}; // To store circles

  late AnimationController _controllerRipple;
  late Animation<double> _rippleAnimation;
  Timer? _rippleTimer;

  @override
  void initState() {
    super.initState();
    getCurrentUserLocation();
    _addStaticMarkers();

    _controllerRipple = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _rippleAnimation = Tween<double>(begin: 70.0, end: 80.0).animate(
      CurvedAnimation(
        parent: _controllerRipple,
        curve: Curves.easeInOut,
      ),
    );

    _rippleTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (currentLocationOfTheUser != null) {
        createAndUpdateCustomMarker();
        updateCircle();
      }
    });
  }

  @override
  void dispose() {
    _controllerRipple.dispose();
    _rippleTimer?.cancel();
    super.dispose();
  }

  Future<void> getCurrentUserLocation() async {
    Location location = Location();
    currentLocationOfTheUser = await location.getLocation();

    setState(() {});

    GoogleMapController googleMapController = await _controller.future;

    location.onLocationChanged.listen((newLocation) async {
      currentLocationOfTheUser = newLocation;
      googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          zoom: 18,
          target: LatLng(
            newLocation.latitude!,
            newLocation.longitude!,
          ),
        ),
      ));

      await createAndUpdateCustomMarker();
      updateCircle();
    });
    getPolyPoints();
  }

  void getPolyPoints() {
    List<LatLng> customPoints = [
      const LatLng(23.7727, 90.3925),
      const LatLng(23.7730, 90.3923),
      const LatLng(23.7733, 90.3921),
      const LatLng(23.7736, 90.3919),
      const LatLng(23.7739, 90.3917),
      const LatLng(23.7742, 90.3915),
      const LatLng(23.7745, 90.3913),
      const LatLng(23.7748, 90.3911),
      const LatLng(23.7751, 90.3909),
      const LatLng(23.7754, 90.3907),
    ];

    setState(() {
      polylineCoordinates = customPoints;
    });
  }

  void updateCircle() {
    if (currentLocationOfTheUser == null) return;

    setState(() {
      _circles = {
        Circle(
          circleId: CircleId('current_location_circle'),
          center: LatLng(
            currentLocationOfTheUser!.latitude!,
            currentLocationOfTheUser!.longitude!,
          ),
          radius: 20, // Radius in meters
          strokeColor: Colors.blue,
          strokeWidth: 1,
          fillColor: Colors.blue.withOpacity(0.1),
        ),
      };
    });
  }

  Future<void> createAndUpdateCustomMarker() async {
    if (currentLocationOfTheUser == null) return;

    BitmapDescriptor customDestinationMarkerIcon = await
    customMarker.createCustomDestinationMarker(
      destination.latitude,
      destination.longitude,
      _rippleAnimation.value,
      'assets/placeholders/binita.png',
    );

    setState(() {
      _markers.removeWhere((marker) => marker.markerId.value == 'destination');
      _markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: destination,
          icon: customDestinationMarkerIcon,
        ),
      );
    });
  }

  Future<void> _addStaticMarkers() async {
    List<LatLng> staticMarkerPositions = [
      LatLng(23.7755, 90.3895), // Marker 1
      LatLng(23.7750, 90.3900), // Marker 2
      LatLng(23.7760, 90.3910), // Marker 3
      LatLng(23.7745, 90.3920), // Marker 4
    ];

    for (int i = 0; i < staticMarkerPositions.length; i++) {
      _markers.add(
        Marker(
          markerId: MarkerId('static_marker_$i'),
          position: staticMarkerPositions[i],
          icon: await customMarker.createWarningMarker(),
          infoWindow: const InfoWindow(
            title: "Warning",
            snippet: "Something happened here\nPlease stay safe!"
          )
        ),
      );
    }
  }

  Future<void> _goToUserLocation() async {
    if (currentLocationOfTheUser != null) {
      GoogleMapController googleMapController = await _controller.future;
      googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            currentLocationOfTheUser!.latitude!,
            currentLocationOfTheUser!.longitude!,
          ),
          zoom: 18,
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentLocationOfTheUser == null
          ? Center(child: appHelperFunctions.appLoader(context))
          : Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                currentLocationOfTheUser!.latitude!,
                currentLocationOfTheUser!.longitude!,
              ),
              zoom: 16.0,
            ),
            polylines: {
              Polyline(
                polylineId: const PolylineId("route"),
                points: polylineCoordinates,
                color: Colors.blueAccent,
                width: 6,
                startCap: Cap.roundCap,
                endCap: Cap.roundCap,
                geodesic: false,
                jointType: JointType.round,
              )
            },
            onMapCreated: (mapController) {
              _controller.complete(mapController);
            },
            markers: Set<Marker>.from(_markers),
            circles: _circles,
            zoomGesturesEnabled: true,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            trafficEnabled: true,
            mapType: MapType.normal,
            buildingsEnabled: true,
            compassEnabled: true,
            fortyFiveDegreeImageryEnabled: true,
            indoorViewEnabled: true,
            mapToolbarEnabled: true,
            rotateGesturesEnabled: true,
            scrollGesturesEnabled: true,
            tiltGesturesEnabled: true,
          ),
          Positioned(
            top: 20.0,
            left: 10.0,
            right: 140.0,
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(40.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Text(
                'Safe Code: 5678',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            top: 18.0,
            left: 300.0,
            child: FloatingActionButton(
              onPressed: _goToUserLocation,
              backgroundColor: AppColors.secondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(Icons.my_location, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}