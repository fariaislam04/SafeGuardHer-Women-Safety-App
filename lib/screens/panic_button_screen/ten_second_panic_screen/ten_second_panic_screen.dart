import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../../../utils/helpers/timer_util.dart';
import 'package:awesome_ripple_animation/awesome_ripple_animation.dart';
import '../safety_code_screen/safety_code_screen.dart';
import '../stop_panic_alert_screen/stop_panic_alert_screen.dart';

AppHelperFunctions appHelperFunctions = AppHelperFunctions();

class TenSecondPanicScreen extends StatefulWidget {
  const TenSecondPanicScreen({super.key});

  @override
  TenSecondPanicScreenState createState() => TenSecondPanicScreenState();
}

class TenSecondPanicScreenState extends State<TenSecondPanicScreen> {
  late Timer _countdownTimer;
  int _countdown = 10;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _countdownTimer.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _countdownTimer = TimerUtil.startCountdown(
      initialCount: _countdown,
      onTick: (currentCount) {
        setState(() {
          _countdown = currentCount;
          _vibrate();
        });
      },
      onComplete: () {
        _countdownTimer.cancel();
        appHelperFunctions.goToScreenAndComeBack(context, const SafetyCodeScreen());
      },
    );
  }

  Future<void> _vibrate() async {
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
              ripplesCount: 8,
              color: const Color(0xFFF96A66),
              minRadius: 110,
              size: const Size(170, 170),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: const Color(0xFFEC4A46),
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
                      text: '10 seconds',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextSpan(
                      text: ', the ',
                    ),
                    TextSpan(
                      text: 'emergency hotlines',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextSpan(
                      text: ' and your ',
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
                  _countdownTimer.cancel();
                  appHelperFunctions.goToScreenAndComeBack(context, const StopPanicAlertScreen());
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
