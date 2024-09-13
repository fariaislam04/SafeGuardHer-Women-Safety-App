import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:safeguardher_flutter_app/screens/home_screen/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers.dart';

/*
    This page shows up when the user presses "STOP SOS ALERT" from panic
    screens. This page shows the user that panic alert has successfully
    stopped, and returns to the home page after a delay of 2 seconds.
 */

class StopPanicAlertScreen extends ConsumerWidget
{
  const StopPanicAlertScreen({super.key});

  Future<void> navigateToHome(BuildContext context, WidgetRef ref) async
  {
    final user = await ref.read(userStreamProvider.future);
    if(user != null)
      {
        await Future.delayed(const Duration(seconds: 2));
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen(user: user)),
        );
      }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      navigateToHome(context, ref);
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 30.0),
                Container(
                  width: 300.0,
                  height: 300.0,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/icons/warning.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                const SizedBox(height: 40.0),
                const Text(
                  'Emergency SOS Alert Stopped!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF263238),
                    fontSize: 28,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  'You will return to the home screen within a few seconds.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF263238),
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
