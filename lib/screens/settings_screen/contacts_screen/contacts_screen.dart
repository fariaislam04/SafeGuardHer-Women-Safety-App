import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore
import 'package:safeguardher_flutter_app/widgets/templates/settings_template.dart';
import '../../../models/emergency_contact_model.dart';
import '../../../models/user_model.dart';
import '../../../providers.dart';
import 'package:safeguardher_flutter_app/widgets/custom_widgets/contacts_fetcher_widget.dart';

class ContactsScreen extends ConsumerWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get user data from the provider
    final userAsyncValue = ref.watch(userStreamProvider);

    return SettingsTemplate(
      child: userAsyncValue.when(
        data: (user) {
          return Column(
            children: [
              // Title
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back_ios),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'My Close Contacts',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),

              // Contacts List
              Expanded(
                child: ListView.builder(
                  itemCount: user!.emergencyContacts.length +
                      1, // +1 for the Add Contact tile
                  itemBuilder: (context, index) {
                    if (index == user.emergencyContacts.length) {
                      return addContactTile(context, user);
                    } else {
                      final EmergencyContact contact =
                          user.emergencyContacts[index];
                      return contactTile(
                        context,
                        contact.name,
                        contact.number,
                        'assets/placeholders/profile.png', // Use your own image logic here
                      );
                    }
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, stack) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget contactTile(
      BuildContext context, String name, String phone, String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(imagePath),
            radius: 30.0,
          ),
          const SizedBox(width: 10.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                phone,
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Handle more options
            },
          ),
        ],
      ),
    );
  }

  Widget addContactTile(BuildContext context, User user) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: () async {
          // Navigate to the ContactsFetcher screen and wait for the selected contact
          final Contact? selectedContact = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ContactsFetcher(),
            ),
          );

          // If a contact was selected, add it to Firestore
        },
        child: const Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.red,
              radius: 30.0,
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Contact',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Max. 5 contacts',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
