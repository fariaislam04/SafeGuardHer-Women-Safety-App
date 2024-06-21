import 'package:flutter/material.dart';
import 'package:safeguardher_flutter_app/widgets/custom_widgets/panic_button_widget.dart';

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
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 88,
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(width: 1.0, color: Color(0xFFEDEDED)),
              ),
            ),
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: onTap,
              backgroundColor: Colors.white,
              items: const [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0),
                    child: Icon(Icons.location_pin),
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
          Positioned(
            top: -41,
            left: MediaQuery.of(context).size.width / 2 - 40.5,
            child: const PanicButtonWidget()
            ),
        ],
      ),
    );
  }
}
