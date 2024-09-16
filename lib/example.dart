import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/alert_model.dart'; // Assuming your Alert model is in this file
import 'providers.dart'; // Assuming providers.dart contains emergencyContactAlertsStreamProvider and other providers

class AlertsListScreen extends ConsumerWidget {
  const AlertsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listening to emergencyContactAlertsStreamProvider
    final emergencyAlertsAsyncValue = ref.watch(emergencyContactAlertsStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Alerts'),
      ),
      body: emergencyAlertsAsyncValue.when(
        data: (alertsWithContacts) {
          if (alertsWithContacts.isEmpty) {
            return const Center(child: Text('No alerts found.'));
          }

          // Display the list of alerts with contact details
          return ListView.builder(
            itemCount: alertsWithContacts.length,
            itemBuilder: (context, index) {
              final alertWithContact = alertsWithContacts[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(alertWithContact.contactProfilePic),
                  radius: 24,
                  backgroundColor: Colors.grey[300],
                  child: alertWithContact.contactProfilePic.isEmpty
                      ? Icon(Icons.person, color: Colors.grey[600])
                      : null,
                ),
                title: Text('Alert ID: ${alertWithContact.alert.alertId}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Contact Name: ${alertWithContact.contactName}'),
                    Text('Alert Start: ${alertWithContact.alert.alertStart.toDate()}'),
                    if (alertWithContact.alert.alertEnd != null)
                      Text('Alert End: ${alertWithContact.alert.alertEnd!.toDate()}'),
                    Text('Safety Code: ${alertWithContact.alert.safetyCode}'),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
