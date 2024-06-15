import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RecordingListCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const RecordingListCard({
    required this.title,
    required this.subtitle,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: SvgPicture.asset(
          'assets/icons/anonymous_recording_icon.svg',
          width: 30,
          height: 30,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(subtitle),
        onTap: onTap,
        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
