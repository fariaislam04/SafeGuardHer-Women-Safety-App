import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';
import '../../models/emergency_contact_model.dart';

class Home extends StatelessWidget {
  final User user;

  const Home({super.key, required this.user});

  Future<EmergencyContact> fetchContactDetails(String phoneNumber) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(phoneNumber)
          .get();
      if (doc.exists) {
        return EmergencyContact.fromFirestore(doc.data()!);
      } else {
        print('Emergency contact not found for phone number: $phoneNumber');
        return EmergencyContact(
            phone: phoneNumber,
            name: phoneNumber,
            profilePic: 'assets/placeholders/default_profile_pic.png'
        );
      }
    } catch (e) {
      print('Error fetching emergency contact details: $e');
      return EmergencyContact(
          phone: phoneNumber,
          name: phoneNumber,
          profilePic: 'assets/placeholders/default_profile_pic.png'
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, ${user.name}"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Email: ${user.email}"),
            Text("DOB: ${user.dob}"),
            Text("Emergency Contacts:"),
            ...user.emergencyContacts.map((phoneNumber) {
              return FutureBuilder<EmergencyContact>(
                future: fetchContactDetails(phoneNumber),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData) {
                    return Text('No data found');
                  } else {
                    final contact = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Name: ${contact.name}"),
                        Text("Phone: ${contact.phone}"),
                        Text("Profile Pic: ${contact.profilePic}"),
                        const SizedBox(height: 8),
                      ],
                    );
                  }
                },
              );
            }).toList(),
            Text("Unsafe Places:"),
            ...user.unsafePlaces.map((place) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Type: ${place.type}"),
                Text("Description: ${place.description}"),
                Text("Location: ${place.location.latitude}, ${place.location.longitude}"),
                const SizedBox(height: 8),
              ],
            )),
            Text("Alerts:"),
            ...user.alerts.map((alert) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Type: ${alert.type}"),
                Text("Event ID: ${alert.eventID.eventStart}"),
                Text("Event ID: ${alert.eventID.eventEnd}"),
                Text("Report Details: ${alert.report.description}"),
                Text("Report Details: ${alert.report.reportType}"),
                const SizedBox(height: 8),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
