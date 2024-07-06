import 'package:flutter/material.dart';
import 'package:safeguardher_flutter_app/widgets/navigations/app_bar.dart';
import 'package:safeguardher_flutter_app/widgets/navigations/bottom_navbar.dart';
import '../map_screen/map_screen.dart';
import '../record_screen/record_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

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
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children:   const [
            MapScreen(),
            RecordScreen(),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index)
        {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}