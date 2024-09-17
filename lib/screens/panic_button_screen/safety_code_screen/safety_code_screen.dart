import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../../report_incident_screen/report_incident_screen.dart';

AppHelperFunctions appHelperFunctions = AppHelperFunctions();

class SafetyCodeScreen extends StatefulWidget {
  final String safetyCode;
  final String userId;
  final String alertId;

  const SafetyCodeScreen({
    super.key,
    required this.safetyCode,
    required this.userId,
    required this.alertId,
  });

  @override
  SafetyCodeScreenState createState() => SafetyCodeScreenState();
}

class SafetyCodeScreenState extends State<SafetyCodeScreen> {
  final List<TextEditingController> _controllers =
  List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes =
  List.generate(4, (index) => FocusNode());
  int _correctCodeEntered = -1;
  late Position _userLocation;
  Timer? _locationUpdateTimer;

  @override
  void initState() {
    super.initState();
    _focusNodes[0].requestFocus();
    _startLocationUpdates();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    _locationUpdateTimer?.cancel();
    super.dispose();
  }

  void _startLocationUpdates() {
    _locationUpdateTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      _userLocation = position;
      await _updateUserLocationInFirestore();
    });
  }

  Future<void> _updateUserLocationInFirestore() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('alerts')
          .doc(widget.alertId)  // Update specific alert document
          .update({
        'user_locations.user_location_end': GeoPoint(
          _userLocation.latitude,
          _userLocation.longitude,
        ),
      });
    } catch (e) {
      print('Error updating user location: $e');
    }
  }

  Future<void> navigateToReportIncidentPage(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ReportIncidentPage(),
        ),
      );
    }
  }

  void _verifyCode() {
    String inputCode = _controllers.map((e) => e.text).join();
    setState(() {
      if (widget.safetyCode == inputCode) {
        _correctCodeEntered = 1;
        _locationUpdateTimer?.cancel(); // Stop location updates
        _markAlertAsResolved();  // Mark alert as resolved in Firestore
        navigateToReportIncidentPage(context);
      } else {
        _correctCodeEntered = 0;
        for (var controller in _controllers) {
          controller.clear();
        }
        _focusNodes[0].requestFocus();
      }
    });
  }

  void _checkAndVerifyCode() {
    String inputCode = _controllers.map((e) => e.text).join();
    if (inputCode.length == 4) {
      _verifyCode();
    }
  }

  Future<void> _markAlertAsResolved() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('alerts')
          .doc(widget.alertId)  // Update specific alert document
          .update({
        'alert_duration.alert_end': Timestamp.now(),
        'isActive' : false
      });
    } catch (e) {
      print('Error marking alert as resolved: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6C022A),
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: SvgPicture.asset(
            'assets/logos/logo_dark_theme.svg',
            height: 70,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(right: 20.0, left: 20.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        width: 150,
                        height: 150,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFD4C00),
                        ),
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/icons/bell_ring.svg',
                            height: 80,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _correctCodeEntered != 1
                          ? const Text(
                        'Your close contacts have been notified and help will arrive soon',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      )
                          : const Text(
                        'Safety code verified! You will be redirected to '
                            'report incident page soon.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _correctCodeEntered != 1
                          ? Container(
                        padding: const EdgeInsets.all(30.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6C022A),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          children: [
                            _correctCodeEntered != 1
                                ? const Text(
                              'Enter Safe Code',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            )
                                : const SizedBox.shrink(),
                            const SizedBox(height: 10),
                            _correctCodeEntered == -1
                                ? const Text(
                              'To stop panic alert, please enter the safe code sent to your close contacts',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontSize: 12,
                              ),
                            )
                                : _correctCodeEntered == 0
                                ? const Text(
                              'Wrong safety code. Please try again.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                fontSize: 12,
                              ),
                            )
                                : const SizedBox.shrink(),
                            const SizedBox(height: 20),
                            _correctCodeEntered != 1
                                ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(4, (index) {
                                return Container(
                                  width: 50,
                                  height: 50,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 5.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: TextField(
                                    controller: _controllers[index],
                                    focusNode: _focusNodes[index],
                                    keyboardType: TextInputType.number,
                                    cursorColor: const Color(0xFF6C022A),
                                    cursorErrorColor: Colors.red,
                                    cursorHeight: 30.0,
                                    enabled: true,
                                    style: const TextStyle(
                                        fontSize: 20, fontWeight: FontWeight.w600),
                                    maxLength: 1,
                                    textAlign: TextAlign.center,
                                    decoration: const InputDecoration(
                                      counterText: '',
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (value) {
                                      if (value.length == 1) {
                                        if (index < 3) {
                                          FocusScope.of(context).nextFocus();
                                        } else {
                                          FocusScope.of(context).unfocus();
                                          _checkAndVerifyCode();
                                        }
                                      }
                                    },
                                  ),
                                );
                              }),
                            )
                                : const SizedBox.shrink(),
                            const SizedBox(height: 20),
                          ],
                        ),
                      )
                          : Container(),
                      const SizedBox(height: 20),
                      _correctCodeEntered != 1
                          ? TextButton(
                        onPressed: () {
                          // Handle resend OTP logic here
                        },
                        child: const Text(
                          'Resend safe OTP',
                          style: TextStyle(
                            color: Color(0xFF6C022A),
                            fontFamily: 'Poppins',
                          ),
                        ),
                      )
                          : TextButton(onPressed: () {}, child: Container()),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}