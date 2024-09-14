import 'package:cloud_firestore/cloud_firestore.dart';
import 'alert_model.dart';
import 'emergency_contact_model.dart';
import 'unsafe_place_model.dart';

class User {
  final String name;
  final String pwd;
  final String profilePic;
  final String email;
  final String dob;
  final List<EmergencyContact> emergencyContacts;
  final List<Alert> myAlerts;
  final List<UnsafePlace> unsafePlaces;
  final List<String> emergencyContactOf;
  final List<Alert> myEmergencyContactAlerts;
  final DocumentReference documentRef;

  User({
    required this.name,
    required this.pwd,
    required this.profilePic,
    required this.email,
    required this.dob,
    required this.emergencyContacts,
    required this.myAlerts,
    required this.myEmergencyContactAlerts,
    required this.unsafePlaces,
    required this.emergencyContactOf,
    required this.documentRef,
  });

  factory User.empty() {
    return User(
      name: 'User',
      pwd: '',
      profilePic: 'assets/placeholders/default_profile_pic.png',
      email: '',
      dob: '',
      emergencyContacts: [],
      myAlerts: [],
      unsafePlaces: [],
      myEmergencyContactAlerts: [],
      emergencyContactOf: [],
      documentRef: FirebaseFirestore.instance.collection('users').doc('empty'),
    );
  }

  factory User.fromFirestore(Map<String, dynamic> data, DocumentReference docRef) {
    return User(
      name: data['name'] ?? 'User',
      pwd: data['pwd'] ?? '',
      profilePic: data['profilePicUrl'] ?? 'assets/placeholders/default_profile_pic.png',
      email: data['email'] ?? '',
      dob: data['DOB'] ?? '',
      emergencyContacts: (data['emergency_contacts'] as List<dynamic>? ?? [])
          .map((contact) => EmergencyContact.fromFirestore(contact as Map<String, dynamic>))
          .toList(),
      myAlerts: (data['alerts'] as List<dynamic>? ?? [])
          .map((alertDoc) {
        final alertId = alertDoc.id; // Assuming alertDoc has an 'id' property
        final alertData = alertDoc.data() as Map<String, dynamic>;
        return Alert.fromFirestore(alertData, alertId);
      })
          .toList(),
      unsafePlaces: (data['unsafe_places'] as List<dynamic>? ?? [])
          .map((place) => UnsafePlace.fromFirestore(place as Map<String, dynamic>))
          .toList(),
      emergencyContactOf: (data['emergency_contact_of'] as List<dynamic>? ?? [])
          .map((contactNumber) => contactNumber.toString())
          .toList(),
      documentRef: docRef,
      myEmergencyContactAlerts: [], // Initialize with empty list
    );
  }

  Future<void> fetchEmergencyContactAlerts() async {
    try {
      List<Alert> alerts = [];
      for (String contactNumber in emergencyContactOf) {
        final contactAlertsSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(contactNumber)
            .collection('alerts')
            .get();

        for (var alertDoc in contactAlertsSnapshot.docs) {
          final alertData = alertDoc.data();
          alerts.add(Alert.fromFirestore(alertData, alertDoc.id)); // Pass the document ID
        }
      }
      myEmergencyContactAlerts.addAll(alerts);
    } catch (e) {
      print('Error fetching emergency contact alerts: $e');
    }
  }
}
