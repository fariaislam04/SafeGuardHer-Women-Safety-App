import 'package:safeguardher_flutter_app/models/report_model.dart';
import 'event_model.dart';

class Alert {
  final EventID eventID;
  final Report report;
  final String type;

  Alert({
    required this.eventID,
    required this.report,
    required this.type,
  });

  factory Alert.fromFirestore(Map<String, dynamic> data) {
    return Alert(
      eventID: EventID.fromFirestore(data['event_id'] ?? {}),
      report: Report.fromFirestore(data['report'] ?? {}),
      type: data['type'] ?? '',
    );
  }
}