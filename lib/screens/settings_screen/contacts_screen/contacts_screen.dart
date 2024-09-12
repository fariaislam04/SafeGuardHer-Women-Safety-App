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
                        ref, // Pass ref to the tile
                        user,
                        contact,
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

  Widget contactTile(BuildContext context, WidgetRef ref, User user,
      EmergencyContact contact, String imagePath) {
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
                contact.name,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                contact.number,
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
              // Show dropdown menu
              showMenu(
                context: context,
                position: const RelativeRect.fromLTRB(100, 350, 0, 0),
                items: [
                  const PopupMenuItem(
                    value: 'remove',
                    child: Text('Remove Contact'),
                  ),
                ],
              ).then((value) {
                if (value == 'remove') {
                  _removeContact(context, ref, user, contact);
                }
              });
            },
          ),
        ],
      ),
    );
  }

  // Method to remove contact from Firestore
  Future<void> _removeContact(BuildContext context, WidgetRef ref, User user,
      EmergencyContact contact) async {
    try {
      // Remove the contact from the user's emergency contacts in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc('01719958727') // Adjust as necessary
          .update({
        'emergency_contacts': FieldValue.arrayRemove([contact.toFirestore()]),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contact removed successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove contact: $e')),
      );
    }
  }

  // Disable the add contact tile if there are already 5 contacts
  Widget addContactTile(BuildContext context, User user) {
    final bool isMaxContacts = user.emergencyContacts.length >= 5;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: isMaxContacts
            ? null // Disable the onTap when contacts are 5 or more
            : () async {
                // Navigate to the ContactsFetcher screen and wait for the selected contact
                final Contact? selectedContact = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ContactsFetcher(),
                  ),
                );

                // If a contact was selected, add it to Firestore (implement logic here)
              },
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor:
                  isMaxContacts ? Colors.grey.shade300 : Colors.red,
              radius: 30.0,
              child: Icon(
                Icons.add,
                color: isMaxContacts ? Colors.black45 : Colors.white,
              ),
            ),
            const SizedBox(width: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isMaxContacts ? 'Max Contacts Reached' : 'Add Contact',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: isMaxContacts ? Colors.grey : Colors.black,
                  ),
                ),
                const Text(
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
