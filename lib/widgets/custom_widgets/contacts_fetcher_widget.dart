import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../models/emergency_contact_model.dart';
import '../../../providers.dart';

class ContactsFetcher extends ConsumerStatefulWidget {
  const ContactsFetcher({super.key});

  @override
  ConsumerState<ContactsFetcher> createState() => _ContactsFetcherState();
}

class _ContactsFetcherState extends ConsumerState<ContactsFetcher> {
  List<Contact> _contacts = [];

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndLoadContacts();
  }

  Future<void> _checkPermissionsAndLoadContacts() async {
    if (await Permission.contacts.request().isGranted) {
      try {
        final contacts = await ContactsService.getContacts();
        setState(() {
          _contacts = contacts.toList();
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load contacts: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Contacts permission is denied.')),
      );
    }
  }

  Future<void> _addContactToFirestore(Contact contact) async {
    // Get the user's DocumentReference
    final userAsyncValue = ref.watch(userStreamProvider);

    userAsyncValue.when(
      data: (user) async {
        if (user == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User data is not available.')),
          );
          return;
        }

        final emergencyContact = EmergencyContact(
          name: contact.displayName ?? 'No Name',
          number: contact.phones!.isNotEmpty
              ? contact.phones!.first.value ?? 'No Number'
              : 'No Number',
          profilePic: 'assets/placeholders/profile.png',
        );

        try {
          // Use the DocumentReference from user
          await user.documentRef.update({
            'emergency_contacts':
                FieldValue.arrayUnion([emergencyContact.toFirestore()]),
          });

          Navigator.pop(context, contact); // Pop context after adding contact
        } catch (e) {
          Navigator.pop(
              context, contact); // Pop context even if there is an error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error adding contact: $e')),
          );
        }
      },
      loading: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Loading user data...')),
        );
      },
      error: (e, stack) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching user data: $e')),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Contact'),
      ),
      body: _contacts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _contacts.length,
              itemBuilder: (context, index) {
                final contact = _contacts[index];
                return ListTile(
                  leading:
                      (contact.avatar != null && contact.avatar!.isNotEmpty)
                          ? CircleAvatar(
                              backgroundImage: MemoryImage(contact.avatar!))
                          : const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(contact.displayName ?? 'No Name'),
                  subtitle: Text(contact.phones!.isNotEmpty
                      ? contact.phones!.first.value ?? 'No Number'
                      : 'No Number'),
                  onTap: () {
                    _addContactToFirestore(contact);
                  },
                );
              },
            ),
    );
  }
}
