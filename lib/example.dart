import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'models/alert_with_contact_model.dart';
import 'providers.dart';
import 'models/user_model.dart';
import 'models/alert_model.dart';
import 'models/emergency_contact_model.dart';
import 'models/unsafe_place_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alert Dashboard',
      home: DashboardScreen(),
    );
  }
}
// Dashboard Screen
class DashboardScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watching user stream for real-time updates
    final userAsyncValue = ref.watch(userStreamProvider);
    final emergencyContactAlertsAsyncValue = ref.watch(emergencyContactAlertsStreamProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Alert Dashboard')),
      body: userAsyncValue.when(
        data: (user) {
          if (user == null) return Center(child: Text('No user data available'));

          return Column(
            children: [
              Expanded(
                child: emergencyContactAlertsAsyncValue.when(
                  data: (alerts) {
                    if (alerts.isEmpty) {
                      return Center(child: Text('No active alerts'));
                    }
                    return ListView.builder(
                      itemCount: alerts.length,
                      itemBuilder: (context, index) {
                        final alertWithContact = alerts[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(alertWithContact.contactProfilePic),
                          ),
                          title: Text(alertWithContact.contactName),
                          subtitle: Text('Alert: ${alertWithContact.alert.safetyCode}'),
                          trailing: Icon(Icons.warning, color: Colors.red),
                        );
                      },
                    );
                  },
                  loading: () => Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(child: Text('Error fetching alerts: $error')),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigate to another screen or perform an action
                },
                child: Text('Perform Action'),
              ),
            ],
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error fetching user data: $error')),
      ),
    );
  }
}