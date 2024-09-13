import 'dart:async';
import 'dart:math';
import 'package:awesome_ripple_animation/awesome_ripple_animation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vibration/vibration.dart';
import '../../../services/background/sms_service/sms_sender.dart';
import '../safety_code_screen/safety_code_screen.dart';
import '../stop_panic_alert_screen/stop_panic_alert_screen.dart';
import '../../../utils/helpers/timer_util.dart';

class TenSecondPanicScreen extends StatefulWidget {
  const TenSecondPanicScreen({super.key});

  @override
  TenSecondPanicScreenState createState() => TenSecondPanicScreenState();
}

class TenSecondPanicScreenState extends State<TenSecondPanicScreen>
{
  late Timer _timer;
  int _countdown = 3;
  final SMSSender smsSender = SMSSender();
  late Position _userLocation;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer = TimerUtil.startCountdown(
      initialCount: _countdown,
      onTick: (currentCount) {
        setState(() {
          _countdown = currentCount;
          _vibrate();
        });
      },
      onComplete: () async {
        _timer.cancel();
        await _fetchAndSendEmergencyContacts();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SafetyCodeScreen(),
          ),
        );
      },
    );
  }

  String _generateSafeCode() {
    final random = Random();
    return (1000 + random.nextInt(9000)).toString();
  }

  Future<void> _vibrate() async {
    await Vibration.vibrate(duration: 500);
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    // If permissions are granted, get the current position
    return await Geolocator.getCurrentPosition();
  }
  Future<void> _getUserLocation() async {
    _userLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> _fetchAndSendEmergencyContacts() async
  {
    try {
      // Fetch user document from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc('01719958727')
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data();
        final emergencyContacts =
            userData?['emergency_contacts'] as List<dynamic>? ?? [];

        if (emergencyContacts.isNotEmpty)
        {
          final alertEntry = {
            'alerted_contacts': emergencyContacts.map((contact) {
              return {
                'alerted_contact_name': contact['emergency_contact_name'],
                'alerted_contact_number': contact['emergency_contact_number'],
                'safety_code': _generateSafeCode(),
              };
            }).toList(),
            'alert_id': {
              'alert_start': Timestamp.now(),
            },
            'type': 'panic',
            'user_locations': {
              'user_location_start': GeoPoint(
                  _userLocation.latitude, _userLocation.longitude),
            },
          };

          await FirebaseFirestore.instance
              .collection('users')
              .doc('01719958727')
              .update({
            'alerts': FieldValue.arrayUnion([alertEntry])
          });

          final phoneNumbers = emergencyContacts.map((contact)
          {
            return contact['emergency_contact_number'] as String? ?? '';
          }).toList();

          final Position position = await _determinePosition();
          final String locationMessage = 'I need help! My current location is: '
              'https://maps.google.com/?q=${position.latitude},${position.longitude}';

          // Check if there are valid phone numbers
          if (phoneNumbers.isNotEmpty) {
            try {
              await smsSender.sendAndNavigate(
                context,
                locationMessage,
                phoneNumbers,
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error sending SMS: $e')),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('No valid phone numbers available.')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No emergency contacts available.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User document not found.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch user data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 140),
            RippleAnimation(
              key: UniqueKey(),
              repeat: true,
              duration: const Duration(milliseconds: 900),
              ripplesCount: 5,
              color: const Color(0xFFFF9B70),
              minRadius: 100,
              size: const Size(170, 170),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: const Color(0xFFFB6829),
                child: Text(
                  '$_countdown',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 80,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 100),
            const Text(
              'KEEP CALM!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Color(0xFFD20451),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  text: 'Within ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: '5 seconds,',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextSpan(
                      text: ' your ',
                    ),
                    TextSpan(
                      text: 'close contacts',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextSpan(
                      text: ' will be alerted of your whereabouts.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 60),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Press the button below to stop SOS alert.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: ElevatedButton(
                onPressed: () {
                  _timer.cancel();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StopPanicAlertScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFFD20452),
                  minimumSize: const Size(200, 70),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: const Text(
                  'STOP SENDING SOS ALERT',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}