// screens/home_screen/home_screen.dart
import 'package:flutter/material.dart';
import 'package:safeguardher_flutter_app/models/user_model.dart';

class Home extends StatelessWidget {
  final User user;

  const Home({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome, ${user.name}"),
      ),
      body: SingleChildScrollView(  // Use ScrollView to accommodate large data
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Basic Info
            Text(
              "User Info",
            ),
            const SizedBox(height: 10),
            Text("Name: ${user.name}"),
            Text("Email: ${user.email}"),
            Text("DOB: ${user.dob}"),
            Text("Password: ${user.pwd}"),
            const SizedBox(height: 20),

            // Emergency Contacts Section
            Text(
              "Emergency Contacts",
            ),
            const SizedBox(height: 10),
            user.emergencyContacts.isEmpty
                ? const Text("No emergency contacts available.")
                : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: user.emergencyContacts.length,
              itemBuilder: (context, index) {
                final contact = user.emergencyContacts[index];
                return ListTile(
                  leading: Image.asset(contact.profilePic, height: 40),  // Display contact profile pic
                  title: Text(contact.name),
                  subtitle: Text(contact.number),
                );
              },
            ),
            const SizedBox(height: 20),

            // Unsafe Places Section
            Text(
              "Unsafe Places",

            ),
            const SizedBox(height: 10),
            user.unsafePlaces.isEmpty
                ? const Text("No unsafe places reported.")
                : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: user.unsafePlaces.length,
              itemBuilder: (context, index) {
                final place = user.unsafePlaces[index];
                return ListTile(
                  title: Text("Type: ${place.type}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Description: ${place.description}"),
                      Text(
                          "Location: Lat ${place.location.latitude}, Long ${place.location.longitude}"),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Alerts Section
            Text(
              "Alerts",

            ),
            const SizedBox(height: 10),
            user.alerts.isEmpty
                ? const Text("No alerts available.")
                : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: user.alerts.length,
              itemBuilder: (context, index) {
                final alert = user.alerts[index];
                return ListTile(
                  title: Text("Type: ${alert.type}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "Event Start: ${alert.eventID?.eventStart ?? 'N/A'}"),
                      Text("Event End: ${alert.eventID?.eventEnd ?? 'N/A'}"),
                      Text(
                          "Report Description: ${alert.report?.description ?? 'No Description'}"),
                      Text(
                          "Report Type: ${alert.report?.reportType ?? 'Unknown'}"),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
