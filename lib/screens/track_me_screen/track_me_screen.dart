import 'package:flutter/material.dart';
import '../../widgets/custom_widgets/add_contact_widget.dart';

class TrackMeScreen extends StatelessWidget {
  const TrackMeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AddContactWidget(),
          Expanded(
            child: Image.asset('assets/illustrations/map.png'),
          ),
        ],
      ),
    );
  }
}
