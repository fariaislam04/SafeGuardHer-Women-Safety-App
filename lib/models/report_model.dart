import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  final String description;
  final String reportType;
  final GeoPoint geolocation; // Assuming you need geolocation as well

  Report({
    required this.description,
    required this.reportType,
    required this.geolocation, // Add this if needed
  });

  factory Report.fromFirestore(Map<String, dynamic> data) {
    return Report(
      description: data['description'] ?? '',
      reportType: data['report_type'] ?? '',
      geolocation: data['geolocation'] != null ? data['geolocation'] as GeoPoint : const GeoPoint(0, 0), // Handle GeoPoint
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'description': description,
      'report_type': reportType,
      'geolocation': geolocation, // Include GeoPoint if needed
    };
  }
}
