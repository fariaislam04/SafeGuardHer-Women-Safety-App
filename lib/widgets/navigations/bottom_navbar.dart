import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(width: 1.0, color: Color(0xFFEDEDED)),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          items: const [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: Icon(Icons.location_pin, size: 35),
              ),
              label: 'Track Me',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: Icon(Icons.multitrack_audio),
              ),
              label: 'Record',
            ),
          ],
          selectedItemColor: const Color(0xFFD20451),
          unselectedItemColor: Colors.grey,
          iconSize: 35,
        ),
      ),
    );
  }
}
