import 'package:flutter/material.dart';
import '../../widgets/app_bar.dart';

class RecordScreen extends StatelessWidget {
  const RecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Container(
        color: Colors.blue,
      ),
    );
  }
}
