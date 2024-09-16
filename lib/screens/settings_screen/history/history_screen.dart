import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import this package for DateFormat
import '../../../utils/constants/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'alert_details.dart';


class HistoryPage extends StatefulWidget {
  // Renamed from HistoryScreen to HistoryPage
  const HistoryPage({super.key});

  @override
  HistoryPageState createState() => HistoryPageState();
}

class HistoryPageState extends State<HistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('History'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'My History'),
            Tab(text: 'Contact History'),
          ],
          indicatorColor: AppColors.secondary,
          indicatorWeight: 2.0,
          labelStyle: const TextStyle(
              fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 14),
          unselectedLabelStyle: const TextStyle(fontFamily: 'Poppins'),
          labelColor: AppColors.secondary,
          unselectedLabelColor: AppColors.textSecondary,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          MyHistoryPage(), // Make sure this is the correct class name
          ConnectedContactHistoryPage(),
        ],
      ),
    );
  }
}

class MyHistoryPage extends StatelessWidget {
  const MyHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc('01719958727')
          .collection('alerts')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Text('Loading...');
          default:
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                Timestamp startTimestamp =
                    data['alert_duration']['alert_start'] as Timestamp;
                Timestamp? endTimestamp =
                    data['alert_duration'].containsKey('alert_end')
                        ? data['alert_duration']['alert_end'] as Timestamp
                        : null;

                // Calculate the duration
                Duration duration;
                if (endTimestamp != null) {
                  duration =
                      endTimestamp.toDate().difference(startTimestamp.toDate());
                } else {
                  duration =
                      Duration.zero; // Default duration if endTimestamp is null
                }
                String formattedDuration = _formatDuration(duration);

                // Format the start timestamp
                String formattedDate = DateFormat('d MMM yyyy, h:mm a')
                    .format(startTimestamp.toDate());

                return HistoryItem(
                  title: data['type'].toString().toUpperCase() + ' triggered',
                  date: formattedDate,
                  duration: formattedDuration,
                  titleColor: Colors.red,
                  document: document, // Pass the document here
                );
              }).toList(),
            );
        }
      },
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitHours = twoDigits(duration.inHours.remainder(24));

    if (duration.inDays > 0) {
      return '${twoDigits(duration.inDays)}d ${twoDigitHours}h ${twoDigitMinutes}m';
    } else if (duration.inHours > 0) {
      return '${twoDigitHours}h ${twoDigitMinutes}m';
    } else {
      return '${twoDigitMinutes}m';
    }
  }
}

class ConnectedContactHistoryPage extends StatelessWidget {
  const ConnectedContactHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: const [
        ConnectedContactHistoryItem(
          name: 'Binita Sarker',
          action: 'SOS alert',
          date: '3 June 2024, 1:20 AM',
          duration: 'Lasted 30 min',
          actionColor: Colors.red,
        ),
        ConnectedContactHistoryItem(
          name: 'Faria Islam',
          action: 'Track Me',
          date: '12 Jan 2024, 12:30 PM',
          duration: 'Lasted 1 hour',
          actionColor: Color(0xFF0000CD),
        ),
      ],
    );
  }
}

class HistoryItem extends StatelessWidget {
  final String title;
  final String date;
  final String duration;
  final Color titleColor;
  final DocumentSnapshot document; // Add document parameter

  const HistoryItem({
    super.key,
    required this.title,
    required this.date,
    required this.duration,
    required this.titleColor,
    required this.document, // Add this parameter
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: titleColor,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          '$date\n$duration',
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 12),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.assignment_late_outlined),
              onPressed: () {
                // Handle Report action
              },
            ),
            IconButton(
              icon: const Icon(Icons.launch_rounded),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AlertDetails(document: document),
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

class ConnectedContactHistoryItem extends StatelessWidget {
  final String name;
  final String action;
  final String date;
  final String duration;
  final Color actionColor;

  const ConnectedContactHistoryItem({
    super.key,
    required this.name,
    required this.action,
    required this.date,
    required this.duration,
    required this.actionColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(
          backgroundImage: AssetImage('assets/placeholders/profile.png'),
        ),
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$name triggered ',
                style: const TextStyle(
                    color: Colors.black, fontFamily: 'Poppins', fontSize: 14),
              ),
              TextSpan(
                text: action,
                style: TextStyle(
                  color: actionColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
        subtitle: Text(
          '$date\n$duration',
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 12),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.launch_rounded),
          onPressed: () {
            // Handle Details action
          },
        ),
      ),
    );
  }
}
