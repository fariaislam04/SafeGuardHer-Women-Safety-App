import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<void> requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      showAlert(context as BuildContext, "camera");
      await Permission.camera.request();
    }
  }

  static Future<void> requestAudioPermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      showAlert(context as BuildContext, "audio");
      await Permission.microphone.request();
    }
  }

  static Widget showAlert(BuildContext context, String permissionType) {
    return AlertDialog(
      title: const Text('Permission Required'),
      content: const Text("Permission must be given to access this feature."),
      actions: <Widget>[
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            switch(permissionType) {
              case "camera": requestCameraPermission();
              case "audio": requestAudioPermission();
            }
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}