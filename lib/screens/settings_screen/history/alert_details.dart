import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AlertDetails extends StatelessWidget {
  final DocumentSnapshot document;

  const AlertDetails({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    Timestamp startTimestamp =
        data['alert_duration']['alert_start'] as Timestamp;
    Timestamp? endTimestamp = data['alert_duration'].containsKey('alert_end')
        ? data['alert_duration']['alert_end'] as Timestamp
        : null;
    String formattedDate =
        DateFormat('d MMM yyyy, h:mm a').format(startTimestamp.toDate());
    Duration duration = endTimestamp != null
        ? endTimestamp.toDate().difference(startTimestamp.toDate())
        : Duration.zero;
    String formattedDuration = _formatDuration(duration);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alert Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Alert Type: ${data['type'].toString().toUpperCase()}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Date: $formattedDate'),
            const SizedBox(height: 8),
            Text('Duration: ${_formatDuration(duration)}'),
            const SizedBox(height: 16),
            const Text('Alerted Contacts:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            ...data['alerted_contacts'].map<Widget>((contact) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  '${contact['alerted_contact_name']} (${contact['alerted_contact_number']})',
                ),
              );
            }).toList(),
            const SizedBox(height: 16),
            Text(
              'User Location Start:\nLat: ${data['user_locations']['user_location_start'].latitude}, '
              'Lng: ${data['user_locations']['user_location_start'].longitude}',
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitHours = twoDigits(duration.inHours.remainder(24));

    if (duration.inDays > 0) {
      return '${twoDigits(duration.inDays)}d ${twoDigitHours}h ${twoDigitMinutes}m';
    } else if (duration.inHours > 0) {
      return '${twoDigitHours}h ${twoDigitMinutes}m';
    } else {
      return '${twoDigitMinutes}m';
    }
  }
}
