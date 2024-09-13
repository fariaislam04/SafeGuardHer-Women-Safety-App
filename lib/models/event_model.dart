import 'package:cloud_firestore/cloud_firestore.dart';

class EventID {
  final Timestamp eventStart;
  final Timestamp eventEnd;

  EventID({
    required this.eventStart,
    required this.eventEnd,
  });

  factory EventID.fromFirestore(Map<String, dynamic> data) {
    return EventID(
      eventStart: data['event_start'] != null
          ? data['event_start'] as Timestamp
          : Timestamp.now(), // Default to current time if null
      eventEnd: data['event_end'] != null
          ? data['event_end'] as Timestamp
          : Timestamp.now(), // Default to current time if null
    );
  }
}
