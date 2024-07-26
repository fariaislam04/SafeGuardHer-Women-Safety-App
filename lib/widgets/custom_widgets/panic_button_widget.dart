import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../utils/constants/colors.dart';
import 'package:safeguardher_flutter_app/screens/panic_button_screen/ten_second_panic_screen/ten_second_panic_screen.dart';
import 'package:safeguardher_flutter_app/widgets/custom_widgets/custom_snackbar.dart';

class PanicButtonWidget extends StatefulWidget {
  const PanicButtonWidget({super.key});

  @override
  State<PanicButtonWidget> createState() => _PanicButtonWidgetState();
}

class _PanicButtonWidgetState extends State<PanicButtonWidget> {
  bool _buttonPressed = false;
  //OverlayEntry? _overlayEntry;

  void _handlePanicButtonPress()
  {
      setState(()
      {
        appHelperFunctions.goToScreenAndComeBack(context, const TenSecondPanicScreen());
       // _removeSnackbar();
      });

      /*
    if (kDebugMode)
    {
      print("Panic button pressed");
    }

    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) => Positioned(
        top: MediaQuery.of(context).size.height * 0.23,
        child: const Material(
          color: Colors.transparent,
          child: AnimatedOpacity(
            duration: Duration(seconds: 1),
            opacity: 1.0,
            child: CustomSnackbar(color: Colors.red, message: "Panic alert "
                "has been pressed.",),
            ),
          ),
        ),
    );
    Overlay.of(context).insert(_overlayEntry!);
       */
  }

  /*
  void _removeSnackbar()
  {
    _overlayEntry?.remove();
    _overlayEntry = null;
  } */

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_)
      {
        setState(()
        {
          _buttonPressed = true;
        });
      },
      onTapUp: (_)
      {
        setState(()
        {
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
                gradient: _buttonPressed ? AppColors.panicButtonPressed :
                AppColors.panicButtonUnpressed,
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
            style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
