import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart'; // SharedPreferences
import '../../../models/emergency_contact_model.dart';
import '../../../models/user_model.dart';
import '../../../providers.dart';
import '../../settings_screen/settings_screen.dart';
import 'package:safeguardher_flutter_app/widgets/custom_widgets/contacts_fetcher_widget.dart';
import 'package:safeguardher_flutter_app/widgets/templates/settings_template.dart';

class ContactsScreen extends ConsumerWidget {
  const ContactsScreen({super.key});

  Future<String?> _getPhoneNumber() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('phoneNumber');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<String?>(
      future: _getPhoneNumber(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Center(child: Text('Error fetching phone number'));
        }

        final phoneNumber = snapshot.data;
        if (phoneNumber == null) {
          return const Center(child: Text('Phone number not found'));
        }

        // Watch user data from the provider
        final userAsyncValue = ref.watch(userStreamProvider);

        return SettingsTemplate(
          child: userAsyncValue.when(
            data: (user) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                    const SettingsScreen()),
                              );
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

                    // Scrollable Contact List inside Expanded
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.22,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: user!.emergencyContacts.length + 1,
                        itemBuilder: (context, index) {
                          return index == user.emergencyContacts.length
                              ? addContactTile(context, user)
                              : contactTile(
                            context,
                            ref,
                            user,
                            user.emergencyContacts[index],
                            'assets/placeholders/profile.png',
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 5),

                    // Helpline Title
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      child: Center(
                        child: Text(
                          'Helplines',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),

                    // CALL 999 Button
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 0.2),
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6.0),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 1.0,
                              spreadRadius: 0.5,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'National Emergency Hotline Number',
                              style: TextStyle(
                                fontSize: 13.0,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                minimumSize: const Size(double.infinity, 35),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              onPressed: () async {
                                await FlutterPhoneDirectCaller.callNumber('9999');
                              },
                              child: const Text(
                                'CALL 9999',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Government Helpline for Violence Against Women
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 0.2),
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(6.0),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 1.0,
                              spreadRadius: 0.5,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Government Helpline Number for Violence Against Women',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13.0,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                minimumSize: const Size(double.infinity, 35),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              onPressed: () async {
                                await FlutterPhoneDirectCaller.callNumber('1099');
                              },
                              child: const Text(
                                'CALL 1099',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, stack) => Center(child: Text('Error: $e')),
          ),
        );
      },
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

  Future<void> _removeContact(BuildContext context, WidgetRef ref, User user,
      EmergencyContact contact) async {
    try {
      await user.documentRef.update({
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

  Widget addContactTile(BuildContext context, User user) {
    final bool isMaxContacts = user.emergencyContacts.length >= 10;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: isMaxContacts
            ? null
            : () async {
          final Contact? selectedContact = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ContactsFetcher(),
            ),
          );

          // Logic to add selected contact to Firestore here
          if (selectedContact != null) {
            final emergencyContact = EmergencyContact(
              name: selectedContact.displayName ?? 'Unknown',
              number: selectedContact.phones?.isNotEmpty == true
                  ? selectedContact.phones!.first.value ?? 'Unknown'
                  : 'Unknown',
              profilePic: "assets/placeholders/default_profile_pic.png"
            );

            await user.documentRef.update({
              'emergency_contacts':
              FieldValue.arrayUnion([emergencyContact.toFirestore()]),
            });
          }
        },
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.grey[300],
              radius: 30.0,
              child: const Icon(Icons.add, color: Colors.black),
            ),
            const SizedBox(width: 10.0),
            const Text(
              'Add New Contact',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}
