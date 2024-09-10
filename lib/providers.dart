import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:async/async.dart';  // Import the async package
import 'models/emergency_contact_model.dart';
import 'models/user_model.dart';
import 'models/unsafe_place_model.dart';
import 'models/alert_model.dart';

final userStreamProvider = StreamProvider<User?>((ref) async* {
  const phoneNumber = '01719958727';

  final userStream = FirebaseFirestore.instance
      .collection('users')
      .doc(phoneNumber)
      .snapshots();

  await for (final snapshot in userStream) {
    if (snapshot.exists) {
      final userData = snapshot.data()!;
      final unsafePlaces = await fetchUnsafePlaces();
      yield User(
        name: userData['name'] ?? '',
        pwd: userData['pwd'] ?? '',
        profilePic: userData['profilePicUrl'] ?? 'assets/placeholders/default_profile_pic.png',
        email: userData['email'] ?? '',
        dob: userData['DOB'] ?? '',
        emergencyContacts: List<String>.from(userData['emergency_contacts'] ?? []),
        alerts: (userData['alerts'] as List<dynamic>? ?? []).map((alert) => Alert.fromFirestore(alert)).toList(),
        unsafePlaces: unsafePlaces,
      );
    } else {
      yield User(
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
  }
});

final unsafePlacesStreamProvider = StreamProvider<List<UnsafePlace>>((ref) async* {
  yield* FirebaseFirestore.instance
      .collection('unsafe_places')
      .doc('unsafe_places')
      .snapshots()
      .map((snapshot) {
    if (snapshot.exists) {
      final data = snapshot.data()!;
      final placesList = data['places'] as List<dynamic>? ?? [];
      return placesList.map((place) => UnsafePlace.fromFirestore(place)).toList();
    } else {
      return [];
    }
  });
});

Future<List<UnsafePlace>> fetchUnsafePlaces() async {
  try {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection('unsafe_places')
        .doc('unsafe_places')
        .get();

    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data()!;
      List<dynamic> placesList = data['places'] ?? [];
      return placesList.map((place) => UnsafePlace.fromFirestore(place)).toList();
    } else {
      print('No unsafe places document found.');
      return [];
    }
  } catch (e) {
    print('Error fetching unsafe places: $e');
    return [];
  }
}