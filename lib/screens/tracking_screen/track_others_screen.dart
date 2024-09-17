import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../utils/constants/colors.dart';
import '../home_screen/home_screen.dart';
import 'custom_marker.dart';
import 'networking.dart';
import '../../providers.dart';

class TrackOthersScreen extends ConsumerStatefulWidget {
  const TrackOthersScreen({
    super.key,
    required this.panickedPersonName,
    required this.panickedPersonProfilePic,
    required this.panickedPersonSafetyCode,
  });

  final String panickedPersonName;
  final String panickedPersonProfilePic;
  final String panickedPersonSafetyCode;

  @override
  ConsumerState<TrackOthersScreen> createState() => _TrackOthersScreenState();
}

class _TrackOthersScreenState extends ConsumerState<TrackOthersScreen> with SingleTickerProviderStateMixin {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng destination = LatLng(23.775236, 90.389920); // Default destination

  List<LatLng> polylineCoordinates = [];
  Set<Polyline> polyLines = {};
  final Set<Marker> _markers = {};

  LocationData? currentLocationOfTheUser;
  bool loading = true;
  CustomMarker customMarker = CustomMarker();

  @override
  void initState() {
    super.initState();
    getCurrentUserLocation();
  }

  Future<void> createAndUpdateCustomMarker() async {
    if (currentLocationOfTheUser == null) return;

    String profilePicUrl = 'assets/placeholders/default_profile_pic.png';

    BitmapDescriptor customDestinationMarkerIcon = await customMarker
        .createCustomTeardropMarker(profilePicUrl, const Color(0xFFF4327B));

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

    BitmapDescriptor customSourceMarkerIcon = await customMarker
        .createCustomTeardropMarker('assets/placeholders/profile.png', const Color(0xFF6393F2));

    setState(() {
      _markers.removeWhere((marker) => marker.markerId.value == 'source');
      _markers.add(
        Marker(
          markerId: const MarkerId('source'),
          position: center,
          icon: customSourceMarkerIcon,
          infoWindow: const InfoWindow(
            title: "Source",
          ),
        ),
      );
    });
  }

  Future<void> getCurrentUserLocation() async {
    Location location = Location();

    currentLocationOfTheUser = await location.getLocation();

    setState(() {
      loading = false;
    });

    setMarkers();
    createAndUpdateSourceMarker();
    getRouteData();

    location.onLocationChanged.listen((newLocation) {
      if (currentLocationOfTheUser == null ||
          (currentLocationOfTheUser!.latitude != newLocation.latitude ||
              currentLocationOfTheUser!.longitude != newLocation.longitude)) {
        currentLocationOfTheUser = newLocation;
        setMarkers();
        createAndUpdateSourceMarker();
        getRouteData();
        _goToUserLocation();
        setState(() {});
      }
    });
  }

  void setMarkers() async {
    if (currentLocationOfTheUser != null) {
      _markers.clear();

      BitmapDescriptor customSourceMarkerIcon = await customMarker.createCustomTeardropMarker(
          'assets/placeholders/profile.png', const Color(0xFF6393F2));

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

      final asyncValue = ref.watch(emergencyContactAlertsStreamProvider);
      asyncValue.when(
        data: (alerts) async {
          final alert = alerts.isNotEmpty ? alerts.first : null;
          if (alert != null) {
            destination = LatLng(
              alert.alert.userLocationEnd.latitude,
              alert.alert.userLocationEnd.longitude,
            );

            await createAndUpdateCustomMarker();
          }

          final asyncValue = ref.watch(unsafePlacesStreamProvider);
          asyncValue.when(
            data: (unsafePlaces) async {
              int i = 0;

              for (final place in unsafePlaces) {
                final placeLocation = LatLng(place.location.latitude, place.location.longitude);
                final dangerMarkerIcon = await customMarker.createDangerMarker(); // Using the custom danger marker
                final marker = Marker(
                  markerId: MarkerId('$i'),
                  position: placeLocation,
                  icon: dangerMarkerIcon,
                  infoWindow: InfoWindow(
                    title: place.type,
                    snippet: place.description,
                  ),
                );
                ++i;
                _markers.add(marker);
              }

              setState(() {});
            },
            loading: () => null,
            error: (error, stack) => print("Error fetching unsafe places: $error"),
          );
        },
        error: (Object error, StackTrace stackTrace) {},
        loading: () {},
      );
    }
  }

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
          ? Center(child: appHelperFunctions.appLoader(context))
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
            onCameraIdle: () {},
          ),
          Positioned(
            top: 20.0,
            right: 10.0,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary,
              ),
              child: IconButton(
                icon: const Icon(Icons.my_location, color: Colors.white),
                onPressed: _goToUserLocation,
              ),
            ),
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
              child: Text(
                'Safe Code: ${widget.panickedPersonSafetyCode}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
