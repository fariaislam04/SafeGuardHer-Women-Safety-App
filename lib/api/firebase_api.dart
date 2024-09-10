import 'package:firebase_messaging/firebase_messaging.dart';
import '../main.dart';

class FirebaseApi {
  // --create an instance of the FCM
  final _firebaseMessaging = FirebaseMessaging.instance;

  // --function to initialize notifications
  Future<void> initNotification() async {
    //request permission from user
    await _firebaseMessaging.requestPermission();

    // fetch FDM token
    final fcmToken = await _firebaseMessaging.getToken();
    print('Token: $fcmToken');

    initPushNotification();

  }

  // --function to handle received messages
  void handleMessage(RemoteMessage? message)
  {
    if(message == null) return;
    print('im here');
    navigatorKey.currentState?.pushNamed(
      '/track_others_screen',
      arguments: message,
    );


  }

  // --function to initialize foreground and background settings
  Future<void> initPushNotification() async
  {
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

  }
}