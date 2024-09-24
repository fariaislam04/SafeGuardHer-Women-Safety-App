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
  final List<Alert>? myAlerts;
  final List<UnsafePlace>? unsafePlaces;
  final List<String>? emergencyContactOf;
  final List<Alert>? myEmergencyContactAlerts;
  final DocumentReference documentRef;

  User({
    required this.name,
    required this.pwd,
    required this.profilePic,
    required this.email,
    required this.dob,
    this.emergencyContacts = const [],
    this.myAlerts = const [],
    this.myEmergencyContactAlerts = const [],
    this.unsafePlaces = const [],
    this.emergencyContactOf = const [],
    required this.documentRef,
  });

  factory User.empty() {
    return User(
      name: 'User',
      pwd: '',
      profilePic: 'https://firebasestorage.googleapis.com/v0/b/safeguardher-app.appspot.com/o/profile_pics%2F01719958727%2F1000007043.png?alt=media&token=34a85510-d1e2-40bd-b84b-5839bef880bc',
      email: '',
      dob: '',
      documentRef: FirebaseFirestore.instance.collection('users').doc('empty'),
    );
  }

  factory User.fromFirestore(Map<String, dynamic> data, DocumentReference docRef) {
    return User(
      name: data['name'] ?? 'User',
      pwd: data['pwd'] ?? '',
      profilePic: data['profilePicUrl'] ?? 'https://firebasestorage.googleapis.com/v0/b/safeguardher-app.appspot.com/o/profile_pics%2F01719958727%2F1000007043.png?alt=media&token=34a85510-d1e2-40bd-b84b-5839bef880bc',
      email: data['email'] ?? '',
      dob: data['DOB'] ?? '',
      emergencyContacts: (data['emergency_contacts'] as List<dynamic>? ?? [])
          .map((contact) => EmergencyContact.fromFirestore(contact as Map<String, dynamic>))
          .toList(),
      myAlerts: (data['alerts'] as List<dynamic>?)?.map((alertDoc) {
        final alertId = alertDoc.id;
        final alertData = alertDoc.data() as Map<String, dynamic>;
        return Alert.fromFirestore(alertData, alertId);
      }).toList(),
      unsafePlaces: (data['unsafe_places'] as List<dynamic>? ?? [])
          .map((place) => UnsafePlace.fromFirestore(place as Map<String, dynamic>))
          .toList(),
      emergencyContactOf: (data['emergency_contact_of'] as List<dynamic>? ?? [])
          .map((contactNumber) => contactNumber.toString())
          .toList(),
      documentRef: docRef,
      myEmergencyContactAlerts: [],
    );
  }

  Future<void> fetchEmergencyContactAlerts() async {
    try {
      List<Alert> alerts = [];
      for (String contactNumber in emergencyContactOf!) {
        final contactAlertsSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(contactNumber)
            .collection('alerts')
            .get();

        for (var alertDoc in contactAlertsSnapshot.docs) {
          final alertData = alertDoc.data();
          alerts.add(Alert.fromFirestore(alertData, alertDoc.id));
        }
      }
      myEmergencyContactAlerts?.addAll(alerts);
    } catch (e) {
      print('Error fetching emergency contact alerts: $e');
    }
  }
}