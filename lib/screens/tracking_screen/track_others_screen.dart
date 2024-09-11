import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../../utils/constants/colors.dart';
import 'custom_bubble_marker.dart';
import 'custom_marker.dart';
import 'networking.dart'; // Import the networking class for API

void main() {
  runApp(const MaterialApp(
    home: TrackOthersScreen(),
  ));
}

class TrackOthersScreen extends StatefulWidget {
  const TrackOthersScreen({super.key});

  @override
  State<TrackOthersScreen> createState() => _TrackOthersScreenState();
}

class _TrackOthersScreenState extends State<TrackOthersScreen> with SingleTickerProviderStateMixin {
  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng destination = LatLng(23.775236, 90.389920); // Pre-defined destination

  List<LatLng> polylineCoordinates = []; // For holding the polyline points
  Set<Polyline> polyLines = {}; // For holding the polyline instance
  Set<Marker> _markers = {}; // For holding the marker instances

  LocationData? currentLocationOfTheUser;
  bool loading = true;
  CustomMarker customMarker = CustomMarker(); // Instance of CustomMarker
  late AnimationController _controllerRipple;
  late Animation<double> _rippleAnimation;

  Timer? _rippleTimer;
  Timer? _destinationUpdateTimer;

  @override
  void initState() {
    super.initState();

    _controllerRipple = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )
      ..repeat(reverse: true);

    _rippleAnimation = Tween<double>(begin: 70.0, end: 80.0).animate(
      CurvedAnimation(
        parent: _controllerRipple,
        curve: Curves.easeInOut,
      ),
    );

    _rippleTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (currentLocationOfTheUser != null) {
        createAndUpdateCustomMarker();
      }
    });

    _destinationUpdateTimer =
        Timer.periodic(const Duration(minutes: 1), (timer) {
          // Periodically update the destination marker
          if (currentLocationOfTheUser != null) {
            createAndUpdateCustomMarker();
          }
        });

    getCurrentUserLocation();
  }

  @override
  void dispose() {
    _controllerRipple.dispose(); // Dispose of the animation controller
    _rippleTimer?.cancel(); // Cancel the ripple timer
    _destinationUpdateTimer?.cancel(); // Cancel the destination update timer
    super.dispose();
  }

  Future<void> createAndUpdateCustomMarker() async {
    if (currentLocationOfTheUser == null) return;

    BitmapDescriptor customDestinationMarkerIcon = await customMarker
        .createCustomDestinationMarker(
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

  Future<void> createAndUpdateSourceMarker() async {
    if (currentLocationOfTheUser == null) return;

    final center = LatLng(
      currentLocationOfTheUser!.latitude!,
      currentLocationOfTheUser!.longitude!,
    );

    BitmapDescriptor customSourceMarkerIcon =  await CustomBubbleMarker()
        .createCustomBubbleMarker('assets/placeholders/profile.png', 'assets/placeholders/pointer.png');

    setState(() {
      _markers.removeWhere((marker) => marker.markerId.value == 'source');
      _markers.add(
        Marker(
          markerId: const MarkerId('source'),
          position: center, // Ensure the marker is at the circle's center
          icon: customSourceMarkerIcon, // Use custom source marker
          infoWindow: const InfoWindow(
            title: "Source",
          ),
        ),
      );
    });
  }

  Future<void> getCurrentUserLocation() async {
    Location location = Location();

    // Fetch the current location of the user
    currentLocationOfTheUser = await location.getLocation();

    setState(() {
      loading = false; // Stop the loader when the location is fetched
    });

    // Add marker for current location
    setMarkers();

    // Create and update source marker
    createAndUpdateSourceMarker();

    // Get the polyline between the user's location and the destination
    getRouteData();

    // Update the location on change
    location.onLocationChanged.listen((newLocation) {
      if (currentLocationOfTheUser == null ||
          (currentLocationOfTheUser!.latitude != newLocation.latitude ||
              currentLocationOfTheUser!.longitude != newLocation.longitude)) {
        // Update the current location
        currentLocationOfTheUser = newLocation;
        setMarkers(); // Update the marker with the new location
        createAndUpdateSourceMarker(); // Update source marker
        getRouteData(); // Update the route
        _goToUserLocation(); // Move camera to the new location
        setState(() {}); // Refresh the UI
      }
    });
  }

  // Function to add markers (for current location and destination)
  void setMarkers() async {
    if (currentLocationOfTheUser != null) {
      _markers.clear();

      BitmapDescriptor customSourceMarkerIcon =  await CustomBubbleMarker()
          .createCustomBubbleMarker('assets/placeholders/profile.png', 'asset'
          's/placeholders/pointer.png');

      // Marker for user's current location
      _markers.add(
        Marker(
          markerId: const MarkerId("current_location"),
          icon: customSourceMarkerIcon,
          position: LatLng(
            currentLocationOfTheUser!.latitude!,
            currentLocationOfTheUser!.longitude!,
          ),
          infoWindow: const InfoWindow(
            title: "You are here",
          ),
        ),
      );

      // Create and set the custom destination marker
      BitmapDescriptor customDestinationMarkerIcon = await customMarker
          .createCustomDestinationMarker(
        destination.latitude,
        destination.longitude,
        _rippleAnimation.value,
        'assets/placeholders/binita.png',
      );

      // Marker for the destination
      _markers.add(
        Marker(
          markerId: const MarkerId("destination"),
          position: destination,
          icon: customDestinationMarkerIcon,
          infoWindow: const InfoWindow(
            title: "Destination",
          ),
        ),
      );

      setState(() {}); // Refresh the UI with the new markers
    }
  }

  // Function to get route data from OpenRouteService
  void getRouteData() async {
    if (currentLocationOfTheUser != null) {
      NetworkHelper network = NetworkHelper(
        startLat: currentLocationOfTheUser!.latitude!,
        startLng: currentLocationOfTheUser!.longitude!,
        endLat: destination.latitude,
        endLng: destination.longitude,
      );

      try {
        var data = await network.getData();
        print("Response Data: $data"); // For debugging

        // Ensure data has expected keys and is valid
        if (data != null && data['features'] != null &&
            data['features'].isNotEmpty) {
          List<dynamic> coordinates = data['features'][0]['geometry']['coordinates'];

          polylineCoordinates.clear(); // Clear old points if any

          // Parse the polyline coordinates
          for (var point in coordinates) {
            polylineCoordinates.add(LatLng(point[1],
                point[0])); // Remember, OpenRouteService gives [lng, lat]
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

  // Function to draw the polyline on the map
  void setPolyLines() {
    Polyline polyline = Polyline(
      polylineId: const PolylineId("route"),
      points: polylineCoordinates,
      color: Colors.blueAccent,
      width: 6,
      // Set a width for visibility
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      geodesic: false,
      jointType: JointType.round,
    );

    polyLines.clear();
    polyLines.add(polyline);
    setState(() {});
  }

  Future<void> _goToUserLocation() async {
    if (currentLocationOfTheUser != null) {
      final GoogleMapController mapController = await _controller.future;
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              currentLocationOfTheUser!.latitude!,
              currentLocationOfTheUser!.longitude!,
            ),
            zoom: 17.0,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentLocationOfTheUser == null
          ? Center(child: CircularProgressIndicator()) // Loader when location is not available
          : Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                currentLocationOfTheUser!.latitude!,
                currentLocationOfTheUser!.longitude!,
              ),
              zoom: 15.0,
            ),
            polylines: polyLines,
            onMapCreated: (mapController) {
              _controller.complete(mapController);
            },
            markers: Set<Marker>.from(_markers),
            zoomGesturesEnabled: true,
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
            right: 20.0, // Adjusted the position to be more visible
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
