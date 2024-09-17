import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/emergency_contact_model.dart';
import '../../../providers.dart';

class ContactsFetcher extends ConsumerStatefulWidget {
  const ContactsFetcher({super.key});

  @override
  ConsumerState<ContactsFetcher> createState() => _ContactsFetcherState();
}

class _ContactsFetcherState extends ConsumerState<ContactsFetcher> {
  List<Contact> _contacts = [];
  List<Contact> _filteredContacts = []; // To store filtered contacts
  TextEditingController _searchController = TextEditingController(); // For the search bar

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndLoadContacts();
    _searchController.addListener(_filterContacts); // Add a listener to filter contacts on input
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _checkPermissionsAndLoadContacts() async {
    if (await Permission.contacts.request().isGranted) {
      try {
        final contacts = await ContactsService.getContacts();
        setState(() {
          _contacts = contacts.toList();
          _filteredContacts = _contacts; // Initialize with all contacts
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

  void _filterContacts() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredContacts = _contacts.where((contact) {
        String contactName = contact.displayName?.toLowerCase() ?? '';
        String contactNumber = contact.phones?.isNotEmpty == true
            ? contact.phones!.first.value ?? ''
            : '';
        return contactName.contains(query) || contactNumber.contains(query);
      }).toList();
    });
  }

  Future<void> _addContactToFirestore(Contact contact) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? phoneNumber = prefs.getString('phoneNumber');

    if (phoneNumber == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phone number not found in preferences.')),
      );
      return;
    }

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
          profilePic: 'assets/placeholders/default_profile_pic.png',
        );

        try {
          await user.documentRef.update({
            'emergency_contacts': FieldValue.arrayUnion([emergencyContact.toFirestore()]),
          });

          final contactDocRef = FirebaseFirestore.instance
              .collection('users')
              .doc(contact.phones!.first.value);
          final contactDoc = await contactDocRef.get();

          if (contactDoc.exists) {
            await contactDocRef.update({
              'emergency_contact_of': FieldValue.arrayUnion([phoneNumber]),
            });
          }

          Navigator.pop(context, contact);
        } catch (e) {
          Navigator.pop(context, contact);
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Contacts',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          Expanded(
            child: _filteredContacts.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: _filteredContacts.length,
              itemBuilder: (context, index) {
                final contact = _filteredContacts[index];
                return ListTile(
                  leading: (contact.avatar != null && contact.avatar!.isNotEmpty)
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
          ),
        ],
      ),
    );
  }
}
