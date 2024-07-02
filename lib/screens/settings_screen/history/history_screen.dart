import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeGuardHer History',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: HistoryScreen(),
    );
  }
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'My History'),
            Tab(text: 'Connected Contact History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          HistoryPage(),
          ConnectedContactHistoryPage(),
        ],
      ),
    );
  }
}

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        HistoryItem(
          title: 'Emergency SOS triggered',
          date: '3 June 2024, 1:20 AM',
          duration: 'Lasted 30 min',
          titleColor: Colors.red,
        ),
        HistoryItem(
          title: 'Track Me triggered',
          date: '12 Jan 2024, 12:30 PM',
          duration: 'Lasted 1 hour',
          titleColor: Color(0xFF0000CD),
        ),
        HistoryItem(
          title: 'Track Me triggered',
          date: '10 Jan 2024, 1:40 PM',
          duration: 'Lasted 2 hours',
          titleColor: Color(0xFF0000CD),
        ),
      ],
    );
  }
}

class ConnectedContactHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        ConnectedContactHistoryItem(
          name: 'Bintea Sarker',
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

  HistoryItem({
    required this.title,
    required this.date,
    required this.duration,
    required this.titleColor,
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
          ),
        ),
        subtitle: Text(
          '$date\n$duration',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.report),
              onPressed: () {
                // Handle Report action
              },
            ),
            IconButton(
              icon: const Icon(Icons.info),
              onPressed: () {
                // Handle Details action
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

  ConnectedContactHistoryItem({
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
        leading: CircleAvatar(
          backgroundImage: AssetImage('assets/placeholders/profile.png'),
        ),
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: '$name triggered ',
                style: TextStyle(color: Colors.black, fontFamily: 'Poppins'),
              ),
              TextSpan(
                text: action,
                style: TextStyle(
                  color: actionColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
        subtitle: Text(
          '$date\n$duration',
          style: TextStyle(fontFamily: 'Poppins'),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.info),
          onPressed: () {
            // Handle Details action
          },
        ),
      ),
    );
  }
}
