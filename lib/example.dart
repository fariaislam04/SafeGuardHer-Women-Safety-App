import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import '../providers.dart'; // Update this path
import '../models/alert_model.dart'; // Update this path
import '../models/user_model.dart';
import 'firebase_options.dart'; // Update this path

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Fetch SharedPreferences and retrieve the phone number
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? phoneNumber = prefs.getString('phoneNumber');

  // Print the phone number to the console
  print('Phone Number from SharedPreferences: $phoneNumber');

  runApp(ProviderScope(child: MyApp(phoneNumber: phoneNumber)));
}

class MyApp extends StatelessWidget {
  final String? phoneNumber;

  MyApp({required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alert Dashboard',
      home: AlertsScreen(phoneNumber: phoneNumber),
    );
  }
}

class AlertsScreen extends ConsumerWidget {
  final String? phoneNumber;

  AlertsScreen({required this.phoneNumber});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsyncValue = ref.watch(userStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Alerts'),
      ),
      body: Column(
        children: [
          // Display the phone number at the top
          if (phoneNumber != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Phone Number: $phoneNumber',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),

          // Display the alerts
          Expanded(
            child: userAsyncValue.when(
              data: (user) {
                if (user == null || user.myAlerts.isEmpty) {
                  return Center(
                    child: Text('No alerts found.'),
                  );
                }

                return ListView.builder(
                  itemCount: user.myAlerts.length,
                  itemBuilder: (context, index) {
                    final alert = user.myAlerts[index];

                    return ListTile(
                      title: Text('Alert ID: ${alert.alertId}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Alert Type: ${alert.alertType}'),
                        ],
                      ),
                      isThreeLine: true,
                    );
                  },
                );
              },
              loading: () => Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(
                child: Text('Error: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
