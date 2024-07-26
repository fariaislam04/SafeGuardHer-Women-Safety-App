import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:safeguardher_flutter_app/screens/home_screen/home_screen.dart';
import 'package:safeguardher_flutter_app/utils/constants/colors.dart';
import '../../env/env.dart';

class TrackOthersScreen extends StatefulWidget {
  const TrackOthersScreen({super.key});

  @override
  State<TrackOthersScreen> createState() => TrackOthersScreenState();
}

class TrackOthersScreenState extends State<TrackOthersScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng destination = LatLng(23.775236, 90.389916);

  List<LatLng> polylineCoordinates = [];
  LocationData? currentLocationOfTheUser;
  late List<Marker> _markers = [];
  String googleMapsAPI = Env.googleMapsAPI;

  /*
  void getPolyPoints() async
  {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: googleMapsAPI,
      request: PolylineRequest(
        origin: PointLatLng(currentLocationOfTheUser!.latitude!,
            currentLocationOfTheUser!.longitude!),
        destination: PointLatLng(destination.latitude, destination.longitude),
        mode: TravelMode.driving,
        wayPoints: [PolylineWayPoint(location: "Sabo, Yaba Lagos Nigeria")],
      ),
    );

    if (kDebugMode) {
      print(result.points);
    }
    if (result.points.isNotEmpty)
    {
      for (var point in result.points)
      {
        polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        );
      }
      setState(() {});
    }
  }
   */

  @override
  void initState() {
    super.initState();
    getCurrentUserLocation();
  }

  Future<void> getCurrentUserLocation() async {
    Location location = Location();
    currentLocationOfTheUser = await location.getLocation();

    setState(() {
      _markers = [
        Marker(
          markerId: const MarkerId('destination'),
          position: destination,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
        Marker(
          markerId: const MarkerId('source'),
          position: LatLng(
            currentLocationOfTheUser!.latitude!,
            currentLocationOfTheUser!.longitude!,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        ),
      ];
    });

    GoogleMapController googleMapController = await _controller.future;
    location.onLocationChanged.listen((newLocation)
    {
      currentLocationOfTheUser = newLocation;
      googleMapController.animateCamera(CameraUpdate.newCameraPosition
        (CameraPosition(
        zoom: 18,
        target: LatLng(
            newLocation.latitude!,
            newLocation.longitude!
        ),),
      ),
      );
      setState(()
      {
        currentLocationOfTheUser = newLocation;
      });
    });

/*
    location.onLocationChanged.listen((newLocation) {
      // Update the source marker position with the new location
      setState(() {
        _markers = [
          ..._markers.where((marker) => marker.markerId.value != 'source'),
          Marker(
            markerId: const MarkerId('source'),
            position: LatLng(newLocation.latitude!, newLocation.longitude!),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          ),
        ];
      });
    }); */

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
              )
            },
            onMapCreated: (mapController) {
              _controller.complete(mapController);
            },
            markers: Set<Marker>.from(_markers),
            zoomGesturesEnabled: true,
          ),
          Positioned(
            top: 20.0,
            left: 10.0,
            right: 10.0,
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
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
