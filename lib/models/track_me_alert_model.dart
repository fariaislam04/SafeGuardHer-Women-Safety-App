//track_me_alert_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safeguardher_flutter_app/models/emergency_contact_model.dart';

class TrackMeAlert {
  final String alertId;
  final String alertType;
  final bool isActive;
  final String trackMeLimit;
  final Timestamp alertStart;
  final Timestamp alertEnd;
  final List<EmergencyContact> alertedContacts;
  final GeoPoint userLocationStart;
  final GeoPoint userLocationEnd;

  TrackMeAlert({
    required this.alertId,
    required this.alertType,
    required this.isActive,
    required this.trackMeLimit,
    required this.alertStart,
    required this.alertEnd,
    required this.userLocationStart,
    required this.userLocationEnd,
    required this.alertedContacts,
  });

  // Factory constructor to create an empty alert
  factory TrackMeAlert.empty() {
    return TrackMeAlert(
      alertId: '',
      alertType: '',
      isActive: false,
      trackMeLimit: "1",
      alertStart: Timestamp.now(),
      alertEnd: Timestamp.now(),
      alertedContacts: [],
      userLocationStart: const GeoPoint(0, 0),
      userLocationEnd: const GeoPoint(0, 0),
    );
  }

  factory TrackMeAlert.fromFirestore(Map<String, dynamic> data, String id) {
    return TrackMeAlert(
      alertId: id,
      alertType: data['type'] ?? '',
      isActive: data['isActive'] ?? false,
      trackMeLimit: data['track_me_limit'] ?? "1",
      alertedContacts: (data['alerted_contacts'] as List<dynamic>?)?.map((contactData) {
        return EmergencyContact.fromFirestore(contactData);
      }).toList() ?? [],
      alertStart: data['alert_duration']['alert_start'] ?? Timestamp.now(),
      alertEnd: data['alert_duration']['alert_end'] ?? Timestamp.now(),
      userLocationStart: data['user_locations']['user_location_start'] as GeoPoint,
      userLocationEnd: data['user_locations']['user_location_end'] as GeoPoint,
    );
  }

}
