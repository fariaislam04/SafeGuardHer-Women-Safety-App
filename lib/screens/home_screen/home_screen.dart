import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:safeguardher_flutter_app/utils/helpers/helper_functions.dart';
import 'package:shake_detector/shake_detector.dart';
import 'package:safeguardher_flutter_app/widgets/navigations/app_bar.dart';
import 'package:safeguardher_flutter_app/widgets/navigations/bottom_navbar.dart';
import '../../models/track_me_alert_model.dart';
import '../../utils/logging/logger.dart';
import '../map_screen/map_screen.dart';
import '../panic_button_screen/ten_second_panic_screen/ten_second_panic_screen.dart';
import '../record_screen/record_screen.dart';
import '../tracking_screen/track_me_active_screen.dart';
import '../../providers.dart';

AppHelperFunctions appHelperFunctions = AppHelperFunctions();

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;
  int _shakeCount = 0;
  bool _isLoading = true;
  int _retryCount = 0;
  final int _maxRetries = 5;

  @override
  void initState() {
    super.initState();
    ShakeDetector.autoStart(onShake: _handleShake);
    _checkActiveTrackMeAlert(); // Initial check
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Check for active alerts whenever the widget is rebuilt
    _checkActiveTrackMeAlert();
  }

  void _handleShake() {
    setState(() {
      _shakeCount++;
    });
    if (_shakeCount >= 3) {
      _triggerPanicAlert();
    }
  }

  void _triggerPanicAlert() {
    appHelperFunctions.goToScreenAndComeBack(context, const TenSecondPanicScreen());
    setState(() {
      _shakeCount = 0;
    });
  }

  Future<void> _checkActiveTrackMeAlert() async {
    for (int i = 0; i < 5; i++) {
      final trackMeAlertAsyncValue = ref.watch(myTrackMeAlertsActiveProvider);

      trackMeAlertAsyncValue.when(
        data: (trackMeAlert) {
          if (trackMeAlert.alertId.isNotEmpty) {
            logger.d("Fetched active TrackMe alert with ID: ${trackMeAlert.alertId}");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => TrackMeActiveScreen(alert: trackMeAlert),
              ),
            );
            return; // Exit the loop if alert is found
          }
        },
        loading: () {
          setState(() {
            _isLoading = true;
          });
        },
        error: (error, stack) async {
          logger.e("Error fetching TrackMe alerts: ${error.toString()}");
          if (_retryCount < _maxRetries) {
            _retryCount++;
            final backoffDuration = Duration(seconds: _calculateExponentialBackoff(_retryCount));
            logger.d("Retrying in ${backoffDuration.inSeconds} seconds...");
            await Future.delayed(backoffDuration);
            _checkActiveTrackMeAlert(); // Retry the function
          } else {
            logger.e("Max retries reached. Stopping retry attempts.");
            setState(() {
              _isLoading = false; // End loading state
            });
          }
        },
      );

      // Wait for 1 second before the next check
      await Future.delayed(const Duration(seconds: 1));
    }

    // If no active alert found after 5 seconds, proceed to render HomeScreen
    logger.d("No active TrackMe alert found within 5 seconds.");
    setState(() {
      _isLoading = false; // End loading state
    });
  }

  // Function to calculate the exponential backoff delay
  int _calculateExponentialBackoff(int retryCount) {
    const int baseDelay = 2;
    const int maxDelay = 32;
    return (baseDelay * (1 << (retryCount - 1))).clamp(0, maxDelay);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(child: appHelperFunctions.appLoader(context)), // Show loading indicator
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: const [
            MapScreen(),
            RecordScreen(),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
