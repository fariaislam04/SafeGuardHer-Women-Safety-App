import 'dart:async'; // Import for Timer
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:geolocator/geolocator.dart'; // Import Geolocator
import 'package:safeguardher_flutter_app/app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import '../../models/emergency_contact_model.dart';
import '../../screens/home_screen/home_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Ensure you have this import for LatLng

class TrackMeCountdownWidget extends StatefulWidget {
  final List<EmergencyContact> alertedContacts;
  final String alertLimit;
  final String alertId;
  final VoidCallback onConfirm; // Callback for stop tracking confirmation
  LatLng? userCurrentLocation;

  TrackMeCountdownWidget({
    super.key,
    required this.alertedContacts,
    required this.alertLimit,
    required this.alertId,
    required this.onConfirm, // Initialize the callback
    this.userCurrentLocation,
  });

  @override
  _TrackMeCountdownWidgetState createState() => _TrackMeCountdownWidgetState();
}

class _TrackMeCountdownWidgetState extends State<TrackMeCountdownWidget> {
  late Timer _timer;
  int _secondsElapsed = 0;
  bool _isCounting = true;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsElapsed++;
      });
    });
  }

  void _stopTimer() {
    if (_isCounting) {
      _timer.cancel();
      _isCounting = false;
    }
  }

  String _formatTime(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> _updateAlertStatus() async {
    final firestore = FirebaseFirestore.instance;
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? phoneNumber = pref.getString("phoneNumber");

    try {
      final alertDocRef = firestore
          .collection('users')
          .doc(phoneNumber)
          .collection('alerts')
          .doc(widget.alertId);

      await firestore.runTransaction((transaction) async {
        final alertDoc = await transaction.get(alertDocRef);
        if (!alertDoc.exists) {
          throw Exception("Alert document does not exist!");
        }
        transaction.update(alertDocRef, {'isActive': false});
      });

      print('Alert status updated successfully');
    } catch (e) {
      print('Error updating alert status: $e');
    }
  }

  void _showStopTrackingDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Stop Live Location Tracking',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          content: const Text('Do you want to stop live location tracking to your emergency contacts?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              style: TextButton.styleFrom(
                side: const BorderSide(color: Colors.pink),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.pink),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                _stopTimer(); // Stop the timer

                await _updateAlertStatus();
                // Wait for the alert status update to complete
                await Future.delayed(const Duration(seconds: 2)); // Optional delay for loading

                widget.onConfirm(); // Call the callback for additional actions

                // Optional: Navigate if needed
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => HomeScreen()), // Or whatever screen you want
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.pink,
              ),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.0,
      padding: const EdgeInsets.only(top: 0.0, bottom: 15.0, right: 15.0, left: 15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 5,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Track Me Triggered',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Your live location is being tracked by',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: List.generate(widget.alertedContacts.length, (index) {
                    final contact = widget.alertedContacts[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 6.0),
                      child: contact.profilePic.isNotEmpty // Check if profilePic is not empty
                          ? CircleAvatar(
                        radius: 16,
                        backgroundImage: NetworkImage(contact.profilePic),
                      )
                          : const CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.grey, // Placeholder if no image
                        child: Icon(Icons.person),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Elapsed Time',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTime(_secondsElapsed),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: _showStopTrackingDialog,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.redAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Stop Tracking',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
