import 'dart:async';
import 'package:awesome_ripple_animation/awesome_ripple_animation.dart';
import 'package:flutter/material.dart';
import 'package:safeguardher_flutter_app/screens/panic_button_screen/safety_code_screen/safety_code_screen.dart';
import 'package:safeguardher_flutter_app/screens/panic_button_screen/stop_panic_alert_screen/stop_panic_alert_screen.dart';
import 'package:vibration/vibration.dart';
import '../../../utils/helpers/timer_util.dart';


class FiveSecondPanicScreen extends StatefulWidget {
  const FiveSecondPanicScreen({super.key});

  @override
  FiveSecondPanicScreenState createState() => FiveSecondPanicScreenState();
}

class FiveSecondPanicScreenState extends State<FiveSecondPanicScreen> {
  late Timer _timer;
  int _countdown = 5;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer = TimerUtil.startCountdown(
      initialCount: _countdown,
      onTick: (currentCount)
      {
        setState(()
        {
          _countdown = currentCount;
          _vibrate();
        });
      },
      onComplete: ()
      {
        _timer.cancel();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SafetyCodeScreen(),
          ),
        );
      },
    );
  }

  Future<void> _vibrate() async
  {
    await Vibration.vibrate(duration: 500);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 140),
            RippleAnimation(
              key: UniqueKey(),
              repeat: true,
              duration: const Duration(milliseconds: 900),
              ripplesCount: 5,
              color: const Color(0xFFFF9B70),
              minRadius: 100,
              size: const Size(170, 170),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: const Color(0xFFFB6829),
                child: Text(
                  '$_countdown',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 80,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 100),
            const Text(
              'KEEP CALM!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Color(0xFFD20451),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  text: 'Within ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: '5 seconds,',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextSpan(
                      text: ' your ',
                    ),
                    TextSpan(
                      text: 'close contacts',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextSpan(
                      text: ' will be alerted of your whereabouts.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 60),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Press the button below to stop SOS alert.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the Home page if user presses "STOP SOS"
                  _timer.cancel();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                      builder: (context) => const StopPanicAlertScreen(),
                  )
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFFD20452),
                  minimumSize: const Size(200, 70),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: const Text(
                  'STOP SENDING SOS ALERT',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
