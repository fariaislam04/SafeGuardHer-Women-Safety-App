import 'dart:async';
import 'dart:math';
import 'package:awesome_ripple_animation/awesome_ripple_animation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/emergency_contact_model.dart';
import '../../../providers.dart';
import '../../../services/background/sms_service/sms_sender.dart';
import '../safety_code_screen/safety_code_screen.dart';
import '../stop_panic_alert_screen/stop_panic_alert_screen.dart';
import '../../../utils/helpers/timer_util.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class TenSecondPanicScreen extends ConsumerWidget {
  const TenSecondPanicScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsyncValue = ref.watch(userStreamProvider);
    final emergencyContacts = ref.watch(emergencyContactsProvider);

    return userAsyncValue.when(
      data: (_) => _TenSecondPanicScreenBody(emergencyContacts: emergencyContacts),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}

class _TenSecondPanicScreenBody extends StatefulWidget {
  final List<EmergencyContact> emergencyContacts;

  const _TenSecondPanicScreenBody({required this.emergencyContacts});

  @override
  State<_TenSecondPanicScreenBody> createState() => _TenSecondPanicScreenBodyState();
}

class _TenSecondPanicScreenBodyState extends State<_TenSecondPanicScreenBody> {
  late Timer _timer;
  int _countdown = 10;
  late Position _userLocation;
  final SMSSender smsSender = SMSSender();
  late String safetyCode;
  late String alertId;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _startCountdown();
    safetyCode = _generateSafetyCode();
    alertId = FirebaseFirestore.instance.collection('alerts').doc().id;
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
        setState(() => _countdown = currentCount);
        Vibration.vibrate(duration: 500);
      },
      onComplete: () async {
        await _sendAlertAndNavigate();
      },
    );
  }

  Future<void> _getUserLocation() async {
    _userLocation = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
  Future<void> _sendAlertAndNavigate() async {
    // Check if emergency contacts exist
    if (widget.emergencyContacts.isEmpty) {
      _showSnackBar('No emergency contacts available.');
      // If no emergency contacts, still proceed with a default emergency number
      String number = '999'; // Default emergency number if no contacts
      await FlutterPhoneDirectCaller.callNumber(number);
    } else {
      final locationMessage =
          'SOS Alert! My location: https://maps.google.com/?q=${_userLocation.latitude},${_userLocation.longitude}';
      final phoneNumbers = widget.emergencyContacts.map((contact) => contact.number).toList();

      try {
        await _logAlertToFirestore(); // Log alert to Firestore

        // Send SMS to all emergency contacts
        await smsSender.sendAndNavigate(context, locationMessage, phoneNumbers);

        // Make a call to the first contact
        String number = widget.emergencyContacts[0].number;
        await FlutterPhoneDirectCaller.callNumber(number);
      } catch (e) {
        _showSnackBar('Failed to send alert: $e');
        return; // Exit function if an error occurs
      }
    }

    // After SMS and phone call, navigate to SafetyCodeScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SafetyCodeScreen(
          safetyCode: safetyCode,
          userId: '01719958727', // Example userId
          alertId: alertId,
        ),
      ),
    );
  }


  Future<void> _logAlertToFirestore() async {
    final alertEntry = {
      'alert_duration': {'alert_start': Timestamp.now()},
      'alerted_contacts': widget.emergencyContacts.map((contact) {
        return {
          'alerted_contact_name': contact.name,
          'alerted_contact_number': contact.number,
        };
      }).toList(),
      'type': 'panic',
      'safety_code': safetyCode,
      'user_locations': {
        'user_location_start': GeoPoint(_userLocation.latitude, _userLocation.longitude),
      },
    };

    await FirebaseFirestore.instance
        .collection('users')
        .doc('01719958727')
        .collection('alerts')
        .doc(alertId)
        .set(alertEntry); // Use set to create the document

    print('Alert created with alert_id: $alertId');
  }

  String _generateSafetyCode() {
    return (1000 + Random().nextInt(9000)).toString();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

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
              ripplesCount: 10,
              color: const Color(0xFFF8BDBB),
              minRadius: 100,
              size: const Size(170, 170),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: const Color(0xFFEC4A46),
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
                      text: '10 seconds,',
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