// providers.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

      List<EmergencyContact> emergencyContacts = [];
      if (userData.containsKey('emergency_contacts')) {
        try {
          final contactsList = userData['emergency_contacts'] as List<dynamic>;
          emergencyContacts = contactsList.map((contact) {
            if (contact is Map<String, dynamic>) {
              return EmergencyContact.fromFirestore(contact);
            } else {
              print(
                  'Unexpected type in emergency_contacts: ${contact.runtimeType}');
              return EmergencyContact(
                name: '',
                number: '',
                profilePic: 'assets/placeholders/default_profile_pic.png',
              );
            }
          }).toList();
        } catch (e) {
          print('Error parsing emergency_contacts: $e');
        }
      }

      yield User(
        name: userData['name'] ?? '',
        pwd: userData['pwd'] ?? '',
        profilePic: userData['profilePicUrl'] ??
            'assets/placeholders/default_profile_pic.png',
        email: userData['email'] ?? '',
        dob: userData['DOB'] ?? '',
        emergencyContacts: emergencyContacts,
        alerts: (userData['alerts'] as List<dynamic>? ?? [])
            .map((alert) => Alert.fromFirestore(alert))
            .toList(),
        unsafePlaces: unsafePlaces,
      );
    } else {
      yield User.empty();
    }
  }
});

final unsafePlacesStreamProvider =
    StreamProvider<List<UnsafePlace>>((ref) async* {
  yield* FirebaseFirestore.instance
      .collection('unsafe_places')
      .doc('unsafe_places')
      .snapshots()
      .map((snapshot) {
    if (snapshot.exists) {
      final data = snapshot.data()!;
      final placesList = data['place'] as List<dynamic>? ?? [];
      return placesList
          .map((place) => UnsafePlace.fromFirestore(place))
          .toList();
    } else {
      return [];
    }
  });
});

Future<List<UnsafePlace>> fetchUnsafePlaces() async {
  try {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('unsafe_places')
        .doc('unsafe_places')
        .get();

    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data()!;
      List<dynamic> placesList = data['place'] ?? [];
      return placesList
          .map((place) => UnsafePlace.fromFirestore(place))
          .toList();
    } else {
      print('No unsafe places document found.');
      return [];
    }
  } catch (e) {
    print('Error fetching unsafe places: $e');
    return [];
  }
}

final emergencyContactsProvider = Provider<List<EmergencyContact>>((ref) {
  final userAsyncValue = ref.watch(userStreamProvider);

  return userAsyncValue.when(
    data: (user) => user?.emergencyContacts ?? [],
    loading: () => [],
    error: (error, stack) => [],
  );
});

final selectedContactsProvider = StateProvider<List<int>>((ref) => []);
final searchQueryProvider = StateProvider<String>((ref) => "");
final selectedOptionProvider = StateProvider<int>((ref) => 1);
