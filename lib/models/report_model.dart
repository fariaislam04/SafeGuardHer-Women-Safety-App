
import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  final String reportType;
  final String reportDescription;
  final GeoPoint reportGeolocation;

  Report({
    required this.reportType,
    required this.reportDescription,
    required this.reportGeolocation,
  });

  factory Report.fromFirestore(Map<String, dynamic> data) {
    return Report(
      reportType: data['report_type'] as String,
      reportDescription: data['report_description'] as String,
      reportGeolocation: data['report_geolocation'] as GeoPoint,
    );
  }
}
