import 'package:flutter/material.dart';
import 'package:safeguardher_flutter_app/widgets/navigations/app_bar.dart';
import 'package:safeguardher_flutter_app/widgets/navigations/bottom_navbar.dart';
import 'package:safeguardher_flutter_app/widgets/custom_widgets/panic_button_widget.dart';
import '../record_screen/record_screen.dart';
import '../track_me_screen/track_me_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          TrackMeScreen(),
          RecordScreen(),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _currentIndex == 0 || _currentIndex == 1 ? const PanicButtonWidget() : null,
    );
  }
}
