import 'package:flutter/material.dart';
import 'package:background_sms/background_sms.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safeguardher_flutter_app/screens/panic_button_screen/safety_code_screen/safety_code_screen.dart';

class SMSSender {
  Future<void> _sendMessage(String phoneNumber, String message,
      {int? simSlot}) async {
    var result = await BackgroundSms.sendMessage(
      phoneNumber: phoneNumber,
      message: message,
      simSlot: simSlot,
    );

    if (result == SmsStatus.sent) {
      print("SMS sent to $phoneNumber");
    } else {
      print("Failed to send SMS to $phoneNumber");
    }
  }

  Future<void> sendAndNavigate(
      BuildContext context, String message, List<String> recipients) async {
    if (await Permission.sms.request().isGranted) {
      for (String recipient in recipients) {
        await _sendMessage(recipient, message);
      }

      // Navigate to SafetyCodeScreen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SafetyCodeScreen()),
      );
    } else {
      // Handle permission denial
      print("SMS permission denied");
    }
  }
}
