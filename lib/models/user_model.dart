import 'package:safeguardher_flutter_app/models/unsafe_place_model.dart';
import 'alert_model.dart';

class User {
  final String name;
  final String pwd;
  final String profilePic;
  final String email;
  final String dob;
  final List<String> emergencyContacts;
  final List<dynamic> alerts;
  final List<UnsafePlace> unsafePlaces;

  User({
    required this.name,
    required this.pwd,
    required this.profilePic,
    required this.email,
    required this.dob,
    required this.emergencyContacts,
    required this.alerts,
    required this.unsafePlaces,
  });

  factory User.empty()
  {
    return User(
      name: 'User',
      pwd: '',
      profilePic: 'assets/placeholders/default_profile_pic.png',
      email: '',
      dob: '',
      emergencyContacts: [],
      alerts: [],
      unsafePlaces: [],
    );
  }

  factory User.fromFirestore(Map<String, dynamic> data)
  {
    return User(
      name: data['name'] ?? 'User',
      pwd: data['pwd'] ?? '',
      profilePic: data['profilePicUrl'] ?? 'assets/placeholders/default_profile'
          '_pic.png',
      email: data['email'] ?? '',
      dob: data['DOB'] ?? '',
      emergencyContacts: List<String>.from(data['emergency_contacts'] ?? []),
      alerts: (data['alerts'] as List<dynamic>? ?? []).map((alert) => Alert.fromFirestore(alert)).toList(),
      unsafePlaces: (data['unsafe_places'] as List<dynamic>? ?? []).map((place) => UnsafePlace.fromFirestore(place)).toList(),
    );
  }
}