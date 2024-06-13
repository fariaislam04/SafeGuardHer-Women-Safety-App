import 'package:flutter/material.dart';
import '../../widgets/bottom_navbar.dart';
import '../../widgets/panic_button_widget.dart';
import '../record_screen/record_screen.dart';
import '../track_me_screen/track_me_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildBody(),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _currentIndex == 0 || _currentIndex == 1 ? PanicButtonWidget() : null,
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return const TrackMeScreen();
      case 1:
        return const RecordScreen();
      default:
        return Container();
    }
  }
}
