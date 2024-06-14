import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:safeguardher_flutter_app/screens/panic_button_screen/10_second_panic_screen/10_second_panic_screen.dart';
import 'package:safeguardher_flutter_app/screens/panic_button_screen/5_second_panic_screen/5_second_panic_screen.dart';

class PanicButtonWidget extends StatefulWidget {
  const PanicButtonWidget({super.key});

  @override
  State<PanicButtonWidget> createState() => _PanicButtonWidgetState();
}

class _PanicButtonWidgetState extends State<PanicButtonWidget> {
  int _pressCount = 0;
  bool _isTimerActive = false;

  /*============================================================================
   *  PANIC BUTTON HANDLER: If user presses the panic button once, the program
   *  waits for 3 seconds to see if the user presses anymore. If not, then 10
   *  second timer starts.
   *  If the user presses the panic button 3 times, the function triggers 5
   *  second timer.
   ============================================================================*/

  void _handlePanicButtonPress()
  {
    setState(() {
      _pressCount++;
    });

    if (!_isTimerActive)
    {
      _isTimerActive = true;
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          _isTimerActive = false;
          if (_pressCount == 1)
          {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TenSecondPanicScreen()),
            );
          }
          else if (_pressCount == 3)
          {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FiveSecondPanicScreen()),
            );
          }
          _pressCount = 0;
        });
      });
    }
    if (kDebugMode)
    {
      print("Panic button pressed $_pressCount time(s)");
    }
  }

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
              onPressed: _handlePanicButtonPress,
              backgroundColor: Colors.transparent,
              elevation: 0,
              shape: const CircleBorder(),
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
          padding: EdgeInsets.only(top: 10.0, bottom: 5),
          child: Text(
            'Panic Button',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}