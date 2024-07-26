import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:safeguardher_flutter_app/screens/record_screen/recording_details.dart';
import 'package:safeguardher_flutter_app/utils/helpers/helper_functions.dart';
import '../../services/background/storage_service/storage_service.dart';
import '../../utils/formatters/formatters.dart';
import '../../widgets/navigations/app_bar.dart';

AppHelperFunctions appHelperFunctions = AppHelperFunctions();
late final String userID;

class ViewRecordingsHistory extends StatefulWidget {
  const ViewRecordingsHistory({super.key, required userID});

  @override
  State<ViewRecordingsHistory> createState() => _ViewRecordingHistoryState();
}

class _ViewRecordingHistoryState extends State<ViewRecordingsHistory>
{
  final StorageService _storageService = StorageService();
  List<String> dateFolders = [];
  bool isLoading = true;

  @override
  void initState()
  {
    super.initState();
    fetchDateFolders();
  }

  Future<void> fetchDateFolders() async
  {
    try {
      List<String> folders = await _storageService.listDateFolders(userID);
      setState(() {
        dateFolders = folders;
        isLoading = false;
      });
    } catch (e)
    {
      if (kDebugMode)
      {
        print('Error fetching date folders: $e');
      }
      setState(()
      {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context)
  {
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
                ? const Center(child: CircularProgressIndicator()) // --
            // Don't change it. Causes render flex overflow
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

class RecordedHistoryTile extends StatelessWidget
{
  final String date;
  const RecordedHistoryTile({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context)
  {
    String formattedDate = Formatters.formatDateString(date);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: const Icon(Icons.video_library_rounded),
        title: Text(
          'Recorded on $formattedDate',
          style: const TextStyle(
            fontSize: 13,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        onTap: ()
        {
          appHelperFunctions.goToScreenAndComeBack(context, RecordingDetails
            (uid: userID,
              date: date));
        },
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Color(0xFF263238),
          size: 13,
        ),
      ),
    );
  }
}
