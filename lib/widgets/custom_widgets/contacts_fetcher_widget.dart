import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactsFetcher extends StatefulWidget {
  const ContactsFetcher({super.key});

  @override
  _ContactsFetcherState createState() => _ContactsFetcherState();
}

class _ContactsFetcherState extends State<ContactsFetcher> {
  Iterable<Contact> _contacts = [];

  @override
  void initState() {
    super.initState();
    _getContacts();
  }

  Future<void> _getContacts() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted) {
      permission = await Permission.contacts.request();
      if (permission != PermissionStatus.granted) {}
    }

    final contacts = await ContactsService.getContacts();
    setState(() {
      _contacts = contacts;
    });
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
                Contact contact = _contacts.elementAt(index);
                return ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text(contact.displayName ?? 'No name'),
                  subtitle: Text(contact.phones!.isNotEmpty
                      ? contact.phones?.first.value ?? ''
                      : 'No phone number'),
                  onTap: () {
                    Navigator.pop(context, contact);
                  },
                );
              },
            ),
    );
  }
}
