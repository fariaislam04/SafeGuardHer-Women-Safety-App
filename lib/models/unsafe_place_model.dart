
import 'package:cloud_firestore/cloud_firestore.dart';

class UnsafePlace {
  final String type;
  final String description;
  final GeoPoint location;


  UnsafePlace({
    required this.type,
    required this.description,
    required this.location,

  });

  factory UnsafePlace.fromFirestore(Map<String, dynamic> data) {
    return UnsafePlace(
      type: data['type'] ?? '',
      description: data['description'] ?? '',
      location: data['geopoint'],

    );
  }
}