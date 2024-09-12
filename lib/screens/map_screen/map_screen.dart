import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safeguardher_flutter_app/screens/tracking_screen/custom_marker.dart';
import 'package:safeguardher_flutter_app/widgets/notifications/notification_widget.dart';
import '../../providers.dart';
import '../../utils/constants/colors.dart';
import '../../utils/helpers/helper_functions.dart';
import '../tracking_screen/track_me_modal.dart';

AppHelperFunctions appHelperFunctions = AppHelperFunctions();

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

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    dangerMarkerIconFuture = CustomMarker().createDangerMarker(); // Initialize the Future
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
        return const TrackMeModal();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final unsafePlacesAsyncValue = ref.watch(unsafePlacesStreamProvider);

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              const NotificationWidget(name: "Binita Sarker", code: "5678"),
              Expanded(
                child: FutureBuilder<BitmapDescriptor>(
                  future: dangerMarkerIconFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      if (kDebugMode) {
                        print('Error creating danger marker icon: ${snapshot.error}');
                      }
                      return Center(child: Text('Error creating marker icon'));
                    }
                    final dangerMarkerIcon = snapshot.data;

                    return GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: const CameraPosition(
                        target: LatLng(26.675200, 85.166800),
                        zoom: 1.0,
                      ),
                      markers: markers,
                      mapType: MapType.normal,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      zoomControlsEnabled: true,
                      onCameraIdle: () {
                        unsafePlacesAsyncValue.when(
                          data: (unsafePlaces)
                          {
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

                            setState(()
                            {
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
        ],
      ),
    );
  }
}
