import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:safeguardher_flutter_app/widgets/templates/settings_template.dart';
import 'package:safeguardher_flutter_app/widgets/custom_widgets/contacts_fetcher_widget.dart';

class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsTemplate(
      child: Column(
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
            child: ListView(
              children: [
                contactTile(
                  context,
                  'Faria Islam',
                  '01711897447',
                  'assets/placeholders/profile.png',
                ),
                contactTile(
                  context,
                  'Binita Sarker',
                  '017114722849',
                  'assets/placeholders/profile.png',
                ),
                addContactTile(context),
              ],
            ),
          ),
        ],
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

  Widget addContactTile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: () async {
          final Contact? selectedContact = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ContactsFetcher(),
            ),
          );
          if (selectedContact != null) {
            if (kDebugMode) {
              print('Selected contact: ${selectedContact.displayName}');
            }
            // Add the selected contact to your list or state management solution
          }
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
