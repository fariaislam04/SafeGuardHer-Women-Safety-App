import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:safeguardher_flutter_app/widgets/notifications/notification_widget.dart';
import '../../utils/constants/colors/colors.dart';
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
  void initState() {
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

  void _showTrackMeModal() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return _TrackMeModal();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              const AddContactWidget(),
              //const NotificationWidget(name: "Binita Sarker", code: "5678"),
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
                  onPressed: _showTrackMeModal,
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

class _TrackMeModal extends StatefulWidget {
  @override
  __TrackMeModalState createState() => __TrackMeModalState();
}

class __TrackMeModalState extends State<_TrackMeModal> {
  List<int> selectedContacts = [];
  String searchQuery = "";
  int selectedOption = 1;
  List<String> contacts = [
    'Binita Sarker',
    'Farheen Trisha',
    'Faria Islam',
    'Raisa Rahman',
  ]; // Sample contact names

  @override
  Widget build(BuildContext context) {
    List<String> filteredContacts = contacts
        .where((contact) => contact.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Container(
      padding: const EdgeInsets.only(right: 16.0, left: 16.0, top: 30.0,
          bottom: 10),
      height: 500,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Contacts to Share Location',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 25),
          SizedBox(
            height: 60,
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                ),
                prefixIcon: Icon(Icons.search_rounded),
                focusColor: AppColors.borderFocused,
                contentPadding: EdgeInsets.symmetric(vertical: 5.0),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          const SizedBox(height: 13),
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(
                filteredContacts.length,
                    (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selectedContacts.contains(index)) {
                          selectedContacts.remove(index);
                        } else {
                          selectedContacts.add(index);
                        }
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 16),
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              const CircleAvatar(
                                backgroundImage: AssetImage('assets/placeholders/profile.png'),
                                radius: 40,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                filteredContacts[index],
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                          if (selectedContacts.contains(index))
                            const Positioned(
                              right: 0,
                              child: CircleAvatar(
                                backgroundColor: Colors.green,
                                radius: 12,
                                child: Icon(
                                  Icons.check_rounded,
                                  size: 17,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          RadioButtonRow(
            selectedOption: selectedOption,
            onChanged: (value) {
              setState(() {
                selectedOption = value!;
              });
            },
          ),
          const SizedBox(height: 20),
          Center(
            child: TextButton(
              onPressed: () {
                // Handle continue button press
                Navigator.pop(context); // Close the modal
              },
              style: TextButton.styleFrom(
                backgroundColor: AppColors.secondary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RadioButtonRow extends StatelessWidget {
  final int selectedOption;
  final ValueChanged<int?> onChanged;

  const RadioButtonRow({
    required this.selectedOption,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Radio<int>(
          value: 1,
          groupValue: selectedOption,
          onChanged: onChanged,
          activeColor: AppColors.secondary,
        ),
        const Text('Always', style: TextStyle(fontFamily: 'Poppins')),
        Radio<int>(
          value: 2,
          groupValue: selectedOption,
          onChanged: onChanged,
          activeColor: AppColors.secondary,
        ),
        const Text('1 hour', style: TextStyle(fontFamily: 'Poppins')),
        Radio<int>(
          value: 3,
          groupValue: selectedOption,
          onChanged: onChanged,
          activeColor: AppColors.secondary,
        ),
        const Text('8 hours', style: TextStyle(fontFamily: 'Poppins')),
      ],
    );
  }
}
