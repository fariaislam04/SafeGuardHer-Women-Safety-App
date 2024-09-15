import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/alert_model.dart';
import 'models/emergency_contact_model.dart';
import 'models/unsafe_place_model.dart';
import 'models/user_model.dart';
import 'providers.dart'; // Assume providers.dart has your userStreamProvider

class UserDetailsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsyncValue = ref.watch(userStreamProvider);
    final unsafePlacesAsyncValue = ref.watch(unsafePlacesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
      ),
      body: userAsyncValue.when(
        data: (user) {
          if (user == null) return Center(child: Text('No user data available'));

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('User Info'),
                _buildUserInfo(user),

                _buildSectionTitle('Emergency Contacts'),
                _buildEmergencyContacts(user.emergencyContacts),

                _buildSectionTitle('Emergency Contact Of'),
                _buildEmergencyContactOf(user.emergencyContactOf),

                _buildSectionTitle('My Alerts'),
                _buildAlertsList(user.myAlerts),

                _buildSectionTitle('Emergency Contact Alerts'),
                _buildAlertsList(user.myEmergencyContactAlerts),

                unsafePlacesAsyncValue.when(
                  data: (unsafePlaces) => _buildUnsafePlaces(unsafePlaces),
                  loading: () => CircularProgressIndicator(),
                  error: (error, stack) => Text('Error: $error'),
                ),
              ],
            ),
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  // Helper Widget to display User Info
  Widget _buildUserInfo(User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Name: ${user.name}'),
        Text('Email: ${user.email}'),
        Text('Date of Birth: ${user.dob}'),
        Text('Profile Picture: ${user.profilePic}'), // Replace with Image.network if you have a URL
      ],
    );
  }

  // Helper Widget to display Emergency Contacts
  Widget _buildEmergencyContacts(List<EmergencyContact> contacts) {
    if (contacts.isEmpty) {
      return Text('No emergency contacts found');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: contacts.map((contact) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${contact.name}'),
            Text('Number: ${contact.number}'),
            Text('Profile Pic: ${contact.profilePic}'),
            SizedBox(height: 10),
          ],
        );
      }).toList(),
    );
  }

  // Helper Widget to display Emergency Contact Of
  Widget _buildEmergencyContactOf(List<String> emergencyContactOf) {
    if (emergencyContactOf.isEmpty) {
      return Text('Not an emergency contact for anyone');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: emergencyContactOf.map((contact) {
        return Text('Emergency contact for: $contact');
      }).toList(),
    );
  }

  // Helper Widget to display Alerts
  Widget _buildAlertsList(List<Alert> alerts) {
    if (alerts.isEmpty) {
      return Text('No alerts found');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: alerts.map((alert) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Alert ID: ${alert.alertId}'),
            Text('Start Location: ${alert.userLocationStart.toString()}'),
            Text('End Location: ${alert.userLocationEnd.toString()}'),
            Text('Safety Code: ${alert.safetyCode}'),
            SizedBox(height: 10),
          ],
        );
      }).toList(),
    );
  }

  // Helper Widget to display Unsafe Places
  Widget _buildUnsafePlaces(List<UnsafePlace> unsafePlaces) {
    if (unsafePlaces.isEmpty) {
      return Text('No unsafe places found');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: unsafePlaces.map((place) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Place: ${place.type}'),
            Text('Description: ${place.description}'),
            Text('Geolocation: ${place.location.toString()}'),
            SizedBox(height: 10),
          ],
        );
      }).toList(),
    );
  }

  // Helper Widget for Section Titles
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
