import 'dart:async';
import 'package:awesome_ripple_animation/awesome_ripple_animation.dart';
import 'package:flutter/material.dart';
import '../../../constants/util/timer_util.dart';

class FiveSecondPanicScreen extends StatefulWidget {
  const FiveSecondPanicScreen({super.key});

  @override
  FiveSecondPanicScreenState createState() => FiveSecondPanicScreenState();
}

class FiveSecondPanicScreenState extends State<FiveSecondPanicScreen> {
  late Timer _timer;
  int _countdown = 5;

  @override
  void initState()
  {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose()
  {
    _timer.cancel();
    super.dispose();
  }

  void _startCountdown()
  {
    _timer = TimerUtil.startCountdown(
      initialCount: _countdown,
      onTick: (currentCount)
      {
        setState(()
        {
          _countdown = currentCount;
        });
      },
      onComplete: ()
      {
        _timer.cancel();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            const Text(
              'Within 5 seconds, your close contacts will be alerted of your whereabouts.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            RippleAnimation(
              key: UniqueKey(),
              repeat: true,
              duration: const Duration(milliseconds: 900),
              ripplesCount: _countdown,
              color: const Color(0xFFFB6D30),
              minRadius: 180,
              size: const Size(130, 130),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: const Color(0xFFFD4C00),
                child: Text(
                  '$_countdown',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Press the button below to stop SOS alert.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Navigate to the Home page if user presses "STOP SOS"
                _timer.cancel();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: const Color(0xFFD20452),
                minimumSize: const Size(200, 70),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('STOP SENDING SOS ALERT'),
            ),
          ],
        ),
      ),
    );
  }
}