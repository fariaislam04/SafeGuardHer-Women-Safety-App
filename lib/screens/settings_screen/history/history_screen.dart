import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  HistoryScreenState createState() => HistoryScreenState();
}

class HistoryScreenState extends State<HistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState()
  {
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
          labelStyle: const TextStyle(fontFamily: 'Poppins', fontWeight:
          FontWeight.w600, fontSize: 14),
          unselectedLabelStyle: const TextStyle(fontFamily: 'Poppins'),
          labelColor: AppColors.secondary,
          unselectedLabelColor: AppColors.textSecondary,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          HistoryPage(),
          ConnectedContactHistoryPage(),
        ],
      ),
    );
  }
}

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: const [
        HistoryItem(
          title: 'SOS triggered',
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

  const HistoryItem({super.key,
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
            fontSize: 14,
          ),
        ),
        subtitle: Text(
          '$date\n$duration',
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 12,),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.assignment_late_outlined),
              onPressed: ()
              {
                // Handle Report action
              },
            ),
            IconButton(
              icon: const Icon(Icons.launch_rounded),
              onPressed: ()
              {
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
                style: const TextStyle(color: Colors.black, fontFamily: 'Popp'
                    'ins', fontSize: 14),
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
          onPressed: ()
          {
            // Handle Details action
          },
        ),
      ),
    );
  }
}
