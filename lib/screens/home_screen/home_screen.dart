import 'package:flutter/material.dart';
import 'package:safeguardher_flutter_app/models/user_model.dart';
import 'package:safeguardher_flutter_app/utils/helpers/helper_functions.dart';
import 'package:safeguardher_flutter_app/widgets/navigations/app_bar.dart';
import 'package:shake_detector/shake_detector.dart';
import 'package:safeguardher_flutter_app/widgets/navigations/bottom_navbar.dart';
import '../map_screen/map_screen.dart';
import '../panic_button_screen/ten_second_panic_screen/ten_second_panic_screen.dart';
import '../record_screen/record_screen.dart';

AppHelperFunctions appHelperFunctions = AppHelperFunctions();


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required User user});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  int _shakeCount = 0;

  @override
  void initState()
  {
    super.initState();
    ShakeDetector.autoStart(onShake: _handleShake);
  }
  void _handleShake()
  {
    setState(()
    {
      _shakeCount++;
    });
    if (_shakeCount >= 3)
    {
      _triggerPanicAlert();
    }
  }

  void _triggerPanicAlert()
  {
    appHelperFunctions.goToScreenAndComeBack(context, const TenSecondPanicScreen());
    setState(() {
      _shakeCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children:   const [
            MapScreen(),
            RecordScreen(),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index)
        {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
