import 'package:flutter/material.dart';
import '../../screens/home_screen/home_screen.dart';
import '../../utils/constants/colors.dart';
import 'package:safeguardher_flutter_app/screens/panic_button_screen/ten_second_panic_screen/ten_second_panic_screen.dart';

class PanicButtonWidget extends StatefulWidget {
  const PanicButtonWidget({super.key});

  @override
  State<PanicButtonWidget> createState() => _PanicButtonWidgetState();
}

class _PanicButtonWidgetState extends State<PanicButtonWidget> {
  bool _buttonPressed = false;

  void _handlePanicButtonPress() {
    // Perform navigation to TenSecondPanicScreen
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => TenSecondPanicScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _buttonPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _buttonPressed = false;
        });
        _handlePanicButtonPress();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 85,
              height: 85,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: _buttonPressed
                    ? AppColors.panicButtonPressed
                    : AppColors.panicButtonUnpressed,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 4,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.notifications_on_rounded,
                  size: 55,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Panic',
            style: TextStyle(
                fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
