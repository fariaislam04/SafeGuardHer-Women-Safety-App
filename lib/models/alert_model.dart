//alert_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Alert {
  final String alertId;
  final String alertType;
  final String safetyCode;
  final Timestamp alertStart;
  final Timestamp alertEnd;
  final Report report;
  final GeoPoint userLocationStart;
  final GeoPoint userLocationEnd;

  Alert({
    required this.alertId,
    required this.alertType,
    required this.safetyCode,
    required this.alertStart,
    required this.alertEnd,
    required this.report,
    required this.userLocationStart,
    required this.userLocationEnd,
  });

  factory Alert.fromFirestore(Map<String, dynamic> data, String id) {
    return Alert(
      alertId: id,
      alertType: data['type'] ?? '',
      safetyCode: data['safety_code'] ?? '',
      alertStart: data['alert_duration']['alert_start'] ?? Timestamp.now(),
      alertEnd: data['alert_duration']['alert_end'] ?? Timestamp.now(),
      report: Report.fromFirestore(data['report'] ?? {}),
      userLocationStart: data['user_locations']['user_location_start'] as GeoPoint,
      userLocationEnd: data['user_locations']['user_location_end'] as GeoPoint,
    );
  }
}

class Report {
  final String reportDescription;
  final String reportType;
  final GeoPoint? reportGeopoint;

  Report({
    required this.reportDescription,
    required this.reportType,
    this.reportGeopoint,
  });

  factory Report.fromFirestore(Map<String, dynamic> data)
  {
    return Report(
      reportDescription: data['report_description'] ?? '',
      reportType: data['report_type'] ?? '',
      reportGeopoint: data['report_geopoint'] as GeoPoint?,
    );
  }
}
