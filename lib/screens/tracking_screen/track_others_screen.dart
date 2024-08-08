import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:safeguardher_flutter_app/utils/constants/colors.dart';
import '../../env/env.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Marker Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TrackOthersScreen(),
    );
  }
}

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
  late BitmapDescriptor userMarkerIcon;
  String googleMapsAPI = Env.googleMapsAPI;

  late AnimationController _rippleAnimationController;
  late Animation<double> _rippleAnimation;

  @override
  void initState() {
    super.initState();
    getCurrentUserLocation();

    _rippleAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _rippleAnimation = Tween<double>(begin: 50.0, end: 70.0).animate(
      CurvedAnimation(
        parent: _rippleAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _rippleAnimationController.dispose();
    super.dispose();
  }

  Future<void> getCurrentUserLocation() async {
    Location location = Location();
    currentLocationOfTheUser = await location.getLocation();

    // Create the user marker
    await updateUserMarker();

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

      // Update the user marker with the new location
      await updateUserMarker();
    });

    getPolyPoints();
  }

  Future<void> updateUserMarker() async {
    if (currentLocationOfTheUser != null) {
      userMarkerIcon = await createCustomMarker(
        currentLocationOfTheUser!.latitude!,
        currentLocationOfTheUser!.longitude!,
      );

      setState(() {});
    }
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
          ? Center(child: CircularProgressIndicator())
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
              ),
            },
            onMapCreated: (mapController) {
              _controller.complete(mapController);
            },
            markers: {
              if (currentLocationOfTheUser != null)
                Marker(
                  markerId: const MarkerId('user_location'),
                  position: LatLng(
                    currentLocationOfTheUser!.latitude!,
                    currentLocationOfTheUser!.longitude!,
                  ),
                  icon: userMarkerIcon,
                  infoWindow: const InfoWindow(
                    title: 'Binita Sarker',
                    snippet: 'Safe Code: 5678',
                  ),
                ),
            },
            zoomGesturesEnabled: true,
            scrollGesturesEnabled: true,
            rotateGesturesEnabled: true,
            tiltGesturesEnabled: true,
          ),
          Positioned(
            top: 20.0,
            left: 10.0,
            right: 10.0,
            child: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(30.0),
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
          if (currentLocationOfTheUser != null)
            AnimatedBuilder(
              animation: _rippleAnimation,
              builder: (context, child) {
                return CustomPaint(
                  painter: RipplePainter(
                    radius: _rippleAnimation.value,
                    center: Offset(
                      MediaQuery.of(context).size.width / 2,
                      MediaQuery.of(context).size.height / 2.53,
                    ),
                  ),
                  child: Container(
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Future<BitmapDescriptor> createCustomMarker(
      double latitude, double longitude) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    const double radius = 75.0;
    const double borderWidth = 7.0;

    // Draw the white border circle
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
    canvas.drawCircle(Offset(radius, radius), radius + borderWidth / 2, borderPaint);

    // Create a circular path for clipping
    final path = Path()
      ..addOval(Rect.fromCircle(center: Offset(radius, radius), radius: radius));
    canvas.clipPath(path);

    // Load the image
    final imageProvider = AssetImage('assets/placeholders/binita.png');
    final Completer<ui.Image> imageCompleter = Completer();
    final ImageStreamListener listener = ImageStreamListener((imageInfo, synchronousCall) {
      final image = imageInfo.image;
      imageCompleter.complete(image);
    });
    imageProvider.resolve(ImageConfiguration()).addListener(listener);

    // Wait for the image to load
    final ui.Image image = await imageCompleter.future;

    // Draw the image, scaling it to fit within the circle
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromLTWH(0, 0, radius * 2, radius * 2), // Scale image to fill the circle
      Paint(),
    );

    // End the picture and convert to image
    final img = await pictureRecorder.endRecording()
        .toImage((radius * 2 + borderWidth).toInt(), (radius * 2 + borderWidth).toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(pngBytes);
  }
}

class RipplePainter extends CustomPainter {
  final double radius;
  final Offset center;

  RipplePainter({required this.radius, required this.center});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withOpacity(0.0),
          Colors.red.withOpacity(0.4),
        ],
        stops: const [0.0, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(RipplePainter oldDelegate) {
    return radius != oldDelegate.radius || center != oldDelegate.center;
  }
}
