import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PanicButtonWidget extends StatelessWidget {
  const PanicButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Align(
          alignment: const AlignmentDirectional(0, 0.95),
          child: SizedBox(
            width: 85,
            height: 85,
            child: FloatingActionButton(
              onPressed: () {
                if (kDebugMode) {
                  print("Panic button pressed");
                }
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFFD20452), Color(0xFF8E0E3E)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/panic_button_icon.svg',
                    width: 55,
                    height: 55,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.only(top: 10.0, bottom: 5), // Adjust padding
          // as needed
          child: Text(
            'Panic Button',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
