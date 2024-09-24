import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:safeguardher_flutter_app/widgets/notifications/notification_widget.dart';
import 'package:safeguardher_flutter_app/widgets/custom_widgets/add_contact_widget.dart';
import '../../providers.dart';
import '../../utils/constants/colors.dart';
import '../../widgets/notifications/track_me_notification_widget.dart';
import '../tracking_screen/custom_marker.dart';
import '../tracking_screen/track_me_modal.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends ConsumerState<MapScreen> {
  GoogleMapController? mapController;
  Location location = Location();
  Set<Marker> markers = {};
  late Future<BitmapDescriptor> dangerMarkerIconFuture;
  LatLng? userLocation;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    dangerMarkerIconFuture = CustomMarker().createDangerMarker();
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
        this.userLocation = LatLng(userLocation.latitude!, userLocation.longitude!);
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
        return const TrackMeModal();
      },
    );
  }

  void _centerOnUserLocation() {
    if (userLocation != null && mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(userLocation!, 15.0),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final unsafePlacesAsyncValue = ref.watch(unsafePlacesStreamProvider);
    final emergencyContactAlertsAsyncValue = ref.watch(emergencyContactAlertsStreamProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Render the Google Map
          FutureBuilder<BitmapDescriptor>(
            future: dangerMarkerIconFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                if (kDebugMode) {
                  print('Error creating danger marker icon: ${snapshot.error}');
                }
                return const Center(child: Text('Error creating marker icon'));
              }
              final dangerMarkerIcon = snapshot.data;

              return GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: const CameraPosition(
                  target: LatLng(26.675200, 85.166800),
                  zoom: 10.0,
                ),
                markers: markers,
                mapType: MapType.normal,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: true,
                onCameraIdle: () {
                  unsafePlacesAsyncValue.when(
                    data: (unsafePlaces) {
                      final newMarkers = <Marker>{};
                      int i = 0;

                      for (var place in unsafePlaces) {
                        newMarkers.add(
                          Marker(
                            markerId: MarkerId('$i'),
                            position: LatLng(place.location.latitude, place.location.longitude),
                            infoWindow: InfoWindow(title: place.type, snippet: place.description),
                            icon: dangerMarkerIcon!,
                          ),
                        );
                        ++i;
                      }

                      setState(() {
                        markers.addAll(newMarkers);
                      });
                    },
                    loading: () => {},
                    error: (error, stack) {
                      if (kDebugMode) {
                        print('Error fetching unsafe places: $error');
                      }
                    },
                  );
                },
              );
            },
          ),
          // Render NotificationWidget(s) or AddContactWidget
          // Render NotificationWidget(s) or AddContactWidget
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: emergencyContactAlertsAsyncValue.when(
              data: (alertsWithContacts) {
                if (alertsWithContacts.isEmpty) {
                  return const AddContactWidget();
                }
                return Column(
                  children: alertsWithContacts.map((alertWithContact) {
                    if (alertWithContact.alert.alertType == 'trackMe') {
                      return TrackEmergencyContactLocationNotificationWidget(
                        panickedPersonName: alertWithContact.contactName,
                        panickedPersonProfilePic: alertWithContact.contactProfilePic,
                        panickedPersonAlertDetails: alertWithContact.alert,
                      );
                    } else if (alertWithContact.alert.alertType == 'panic') {
                      return NotificationWidget(
                        panickedPersonName: alertWithContact.contactName,
                        panickedPersonProfilePic: alertWithContact.contactProfilePic,
                        panickedPersonSafetyCode: alertWithContact.alert.safetyCode,
                        panickedPersonAlertDetails: alertWithContact.alert,
                      );
                    }
                    return Container(); // Fallback if type doesn't match
                  }).toList(),
                );
              },
              loading: () => Center(child: Container()),
              error: (error, stack) {
                if (kDebugMode) {
                  print('Error fetching active alerts: $error');
                }
                return Center(child: Container());
              },
            ),
          ),

          // Render Track Me Button
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 110.0),
              child: SizedBox(
                height: 50,
                child: TextButton(
                  onPressed: _showTrackMeModal,
                  style: TextButton.styleFrom(
                    backgroundColor: AppColors.secondary,
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
          Positioned(
            top: emergencyContactAlertsAsyncValue.when(
              data: (alertsWithContacts)
              {
                if (alertsWithContacts.isEmpty)
                {
                  return 80;
                }
                else
                {
                  return 120;
                }
              },
              loading: () => 80,
              error: (error, stack) => 80,
            ),
            right: 16,
            child: FloatingActionButton(
              onPressed: _centerOnUserLocation,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(Icons.my_location, color: AppColors.secondary),
            ),
          ),
        ],
      ),
    );
  }
}