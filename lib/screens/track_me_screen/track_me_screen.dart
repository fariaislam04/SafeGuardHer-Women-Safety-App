import 'package:flutter/material.dart';
import '../../widgets/add_contact_widget.dart';
import '../../widgets/app_bar.dart';

class TrackMeScreen extends StatelessWidget {
  const TrackMeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AddContactWidget(),
          Expanded(
            child: Container(
              color: Colors.grey[200],
              child: const Center(
                child: Text(
                  'Beems er map part',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
