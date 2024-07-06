import 'package:flutter/material.dart';
import '../../utils/formatters/formatters.dart';
import '../../screens/record_screen/recording_details.dart';
import '../../utils/helpers/helper_functions.dart';

AppHelperFunctions appHelperFunctions = AppHelperFunctions();

class RecordedHistoryTile extends StatelessWidget {
  final String date;
  const RecordedHistoryTile({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
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
         appHelperFunctions.goToScreen(context, RecordingDetails(uid: ''
             '2',date: date));
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