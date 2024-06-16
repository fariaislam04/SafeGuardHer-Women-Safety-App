import 'package:flutter/material.dart';
import 'package:safeguardher_flutter_app/widgets/navigations/app_bar.dart';
import '../../widgets/navigations/bottom_navbar.dart';
import '../../widgets/custom_widgets/panic_button_widget.dart';
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
      floatingActionButton: _currentIndex == 0 || _currentIndex == 1 ? const PanicButtonWidget() : null,
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