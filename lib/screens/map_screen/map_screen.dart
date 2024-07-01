import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../../widgets/custom_widgets/add_contact_widget.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  Location location = Location();
  Set<Marker> markers = {};

  @override
  void initState()
  {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    final status = await location.requestPermission();
    if (status != PermissionStatus.granted) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Location Permission Required'),
          content: const Text('Please grant location access to use this app.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                _getUserLocation();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    } else {
      _getUserLocation();
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  Future<void> _getUserLocation() async {
    try {
      var userLocation = await location.getLocation();
      setState(() {
        markers.add(
          Marker(
            markerId: const MarkerId('userLocation'),
            position: LatLng(userLocation.latitude!, userLocation.longitude!),
            infoWindow: const InfoWindow(title: 'Your Location'),
          ),
        );
        mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(userLocation.latitude!, userLocation.longitude!),
            15.0,
          ),
        );
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              const AddContactWidget(),
             // const NotificationWidget(name: "Binita Sarker", code: "5678")
              // , // -- Add notification manually
              Expanded(
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(26.675200, 85.166800), // Initial position (Dhaka, Bangladesh)
                    zoom: 1.0,
                  ),
                  markers: markers,
                  mapType: MapType.normal,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  zoomControlsEnabled: true,
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 110.0),
              child: SizedBox(
                height: 50,
                child: TextButton(
                  onPressed: ()
                  {
                    // Handle button press
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFCE0450),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.my_location_rounded, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'Track Me',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}