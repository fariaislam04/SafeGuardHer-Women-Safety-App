import 'package:safeguardher_flutter_app/models/report_model.dart';

class Alert {
  final Report report;
  final String type;

  Alert({
    required this.report,
    required this.type,
  });

  factory Alert.fromFirestore(Map<String, dynamic> data) {
    return Alert(
      report: Report.fromFirestore(data['report'] ?? {}),
      type: data['type'] ?? '',
    );
  }
}