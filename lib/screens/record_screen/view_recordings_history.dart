import 'package:flutter/material.dart';
import '../../services/background/storage_service/storage_service.dart';
import '../../widgets/navigations/app_bar.dart';
import '../../widgets/tiles/recorded_history_tile.dart';

class ViewRecordingsHistory extends StatefulWidget {
  final String uid;
  const ViewRecordingsHistory({super.key, required this.uid});

  @override
  State<ViewRecordingsHistory> createState() => _ViewRecordingHistoryState();
}

class _ViewRecordingHistoryState extends State<ViewRecordingsHistory> {
  final StorageService _storageService = StorageService();
  List<String> dateFolders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDateFolders();
  }

  Future<void> fetchDateFolders() async {
    try {
      List<String> folders = await _storageService.listDateFolders(widget.uid);
      setState(() {
        dateFolders = folders;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching date folders: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

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
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
              child: ListView.builder(
                itemCount: dateFolders.length,
                itemBuilder: (context, index) {
                  final dateFolder = dateFolders[index];
                  return RecordedHistoryTile(
                    date: dateFolder,
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
