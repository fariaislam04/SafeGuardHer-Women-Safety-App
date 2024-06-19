import 'package:flutter/material.dart';
import 'package:safeguardher_flutter_app/widgets/navigations/app_bar.dart';
import '../../widgets/tiles/recorded_history_tile.dart';

class ViewRecordingsHistory extends StatefulWidget {
  const ViewRecordingsHistory({super.key});

  @override
  State<ViewRecordingsHistory> createState() => _ViewRecordingHistoryState();
}

class _ViewRecordingHistoryState extends State<ViewRecordingsHistory> {
  final List<Map<String, dynamic>> recordings = [
    {'date': '16/05/24', 'duration': '25 minutes'},
    {'date': '15/05/24', 'duration': '30 seconds'},
    {'date': '14/05/24', 'duration': '27 minutes'},
    {'date': '13/05/24', 'duration': '32 minutes'},
    {'date': '12/05/24', 'duration': '29 seconds'},
    {'date': '11/05/24', 'duration': '33 seconds'},
    {'date': '10/05/24', 'duration': '26 minutes'},
    {'date': '09/05/24', 'duration': '35 minutes'},
    {'date': '08/05/24', 'duration': '28 minutes'},
    {'date': '07/05/24', 'duration': '31 seconds'},
    {'date': '06/05/24', 'duration': '34 minutes'},
    {'date': '05/05/24', 'duration': '30 seconds'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0, top: 3.0, right: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Color(0xFF263238),
                    size: 15,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text(
                  'Recording History',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3.0),
            const Text(
              'View the captured images and audio of the recorded events.',
              style: TextStyle(
                fontSize: 11,
                fontFamily: 'Poppins',
                color: Colors.grey,
              ),
            ),
            const Divider(color: Color(0xFFEDEDED)),
            const SizedBox(height: 13),
            Expanded(
              child: ListView.builder(
                itemCount: recordings.length,
                itemBuilder: (context, index) {
                  final recording = recordings[index];
                  return RecordedHistoryTile(
                    date: recording['date'],
                    duration: recording['duration'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
