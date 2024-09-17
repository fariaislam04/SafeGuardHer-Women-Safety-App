
// providers.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import 'models/alert_with_contact_model.dart';
import 'models/emergency_contact_model.dart';
import 'models/user_model.dart';
import 'models/unsafe_place_model.dart';
import 'models/alert_model.dart';

// Fetch unsafe places data
Future<List<UnsafePlace>> fetchUnsafePlaces() async {
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('unsafe_places')
        .doc('unsafe_places')
        .get();

    if (snapshot.exists) {
      final data = snapshot.data()!;
      final placesList = data['place'] as List<dynamic>? ?? [];
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

final emergencyContactAlertsStreamProvider = StreamProvider<List<AlertWithContact>>((ref) async* {
  final userAsyncValue = ref.watch(userStreamProvider);

  if (userAsyncValue.value == null) {
    yield [];
    return;
  }

  final List<String> emergencyContactOf = userAsyncValue.value?.emergencyContactOf ?? [];

  if (emergencyContactOf.isEmpty) {
    yield [];
    return;
  }

  final streams = emergencyContactOf.map((contactNumber) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(contactNumber)
        .collection('alerts')
        .where('isActive', isEqualTo: true)
        .snapshots()
        .asyncMap((snapshot) async {
      final alerts = snapshot.docs.map((doc) {
        final alertData = doc.data();
        return Alert.fromFirestore(alertData, doc.id);
      }).toList();

      // Fetch contact details
      final contactDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(contactNumber)
          .get();
      final contactData = contactDoc.data() ?? {};
      final contactName = contactData['name'] ?? 'Unknown';
      final contactProfilePic = contactData['profilePicUrl'] ?? 'assets/placeholders/default_profile_pic.png';

      // Combine alerts with contact details
      return alerts.map((alert) => AlertWithContact(
        alert: alert,
        contactName: contactName,
        contactProfilePic: contactProfilePic,
      )).toList();
    });
  }).toList();

  yield* CombineLatestStream.list<List<AlertWithContact>>(streams).map((listOfAlertsLists) {
    return listOfAlertsLists.expand((alerts) => alerts).toList();
  });
});


// Fetch user's alerts sub-collection
Future<List<Alert>> fetchUserAlerts(String phoneNumber) async {
  try {
    final alertsSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(phoneNumber)
        .collection('alerts')
        .get();

    if (alertsSnapshot.docs.isEmpty) {
      print('No alerts found for user $phoneNumber.');
    }
    final alertsList = alertsSnapshot.docs.map((doc) {
      final alertData = doc.data();
      return Alert.fromFirestore(alertData, doc.id); // Include document ID
    }).toList();
    return alertsList;
  } catch (e) {
    print('Error fetching user alerts: $e');
    return [];
  }
}

// Fetch emergency contact alerts sub-collection
Future<List<Alert>> fetchEmergencyContactAlerts(List<String> emergencyContactOf) async {
  List<Alert> emergencyContactAlerts = [];
  for (String contactNumber in emergencyContactOf) {
    try {
      final contactAlertsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(contactNumber)
          .collection('alerts')
          .get();

      if (contactAlertsSnapshot.docs.isEmpty) {
        print('No alerts found for emergency contact $contactNumber.');
      }
      emergencyContactAlerts.addAll(
        contactAlertsSnapshot.docs.map((doc) {
          final alertData = doc.data();
          return Alert.fromFirestore(alertData, doc.id); // Include document ID
        }).toList(),
      );
    } catch (e) {
      print('Error fetching alerts for contact $contactNumber: $e');
    }
  }
  return emergencyContactAlerts;
}

// Stream provider for user data
final userStreamProvider = StreamProvider<User?>((ref) async* {
  const phoneNumber = '01719958727'; // This should be dynamically set if possible

  final userDocRef = FirebaseFirestore.instance.collection('users').doc(phoneNumber);
  final userStream = userDocRef.snapshots();

  await for (final snapshot in userStream) {
    if (snapshot.exists) {
      try {
        final userData = snapshot.data()!;
        final unsafePlaces = await fetchUnsafePlaces();

        // Fetch emergency contacts
        List<EmergencyContact> emergencyContacts = [];
        if (userData.containsKey('emergency_contacts')) {
          final contactsList = userData['emergency_contacts'] as List<dynamic>;
          emergencyContacts = contactsList.map((contact) {
            if (contact is Map<String, dynamic>) {
              return EmergencyContact.fromFirestore(contact);
            } else {
              print('Unexpected type in emergency_contacts: ${contact.runtimeType}');
              return EmergencyContact(
                name: '',
                number: '',
                profilePic: 'assets/placeholders/default_profile_pic.png',
              );
            }
          }).toList();
        }

        // Fetch user's alerts from the sub-collection
        final myAlerts = await fetchUserAlerts(phoneNumber);

        // Fetch emergency contact alerts from their sub-collections
        List<Alert> myEmergencyContactAlerts = [];
        if (userData.containsKey('emergency_contact_of')) {
          final emergencyContactOfList = List<String>.from(userData['emergency_contact_of']);
          myEmergencyContactAlerts = await fetchEmergencyContactAlerts(emergencyContactOfList);
        }

        // Fetch the 'emergency_contact_of' field
        List<String> emergencyContactOf = [];
        if (userData.containsKey('emergency_contact_of')) {
          emergencyContactOf = List<String>.from(userData['emergency_contact_of']);
        }

        yield User(
          name: userData['name'] ?? '',
          pwd: userData['pwd'] ?? '',
          profilePic: userData['profilePicUrl'] ?? 'assets/placeholders/default_profile_pic.png',
          email: userData['email'] ?? '',
          dob: userData['DOB'] ?? '',
          emergencyContacts: emergencyContacts,
          myAlerts: myAlerts,
          myEmergencyContactAlerts: myEmergencyContactAlerts,
          unsafePlaces: unsafePlaces,
          documentRef: userDocRef,
          emergencyContactOf: emergencyContactOf,
        );
      } catch (e) {
        print('Error processing user data: $e');
        yield User.empty();
      }
    } else {
      yield User.empty();
    }
  }
});

// Stream provider for unsafe places
final unsafePlacesStreamProvider = StreamProvider<List<UnsafePlace>>((ref) async* {
  try {
    yield* FirebaseFirestore.instance
        .collection('unsafe_places')
        .doc('unsafe_places')
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data()!;
        final placesList = data['place'] as List<dynamic>? ?? [];
        return placesList.map((place) => UnsafePlace.fromFirestore(place)).toList();
      } else {
        return [];
      }
    });
  } catch (e) {
    print('Error streaming unsafe places: $e');
    yield [];
  }
});

// Provider for emergency contacts
final emergencyContactsProvider = Provider<List<EmergencyContact>>((ref) {
  final userAsyncValue = ref.watch(userStreamProvider);

  return userAsyncValue.when(
    data: (user) => user?.emergencyContacts ?? [],
    loading: () => [],
    error: (error, stack) {
      print('Error fetching emergency contacts: $error');
      return [];
    },
  );
});

// State providers for various states
final selectedContactsProvider = StateProvider<List<int>>((ref) => []);
final searchQueryProvider = StateProvider<String>((ref) => "");
final selectedOptionProvider = StateProvider<int>((ref) => 1);