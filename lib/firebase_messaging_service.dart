import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// Background message handler
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 10,
      channelKey: 'high_priority_channel',
      title: message.notification?.title ?? 'Alert',
      body: message.notification?.body ?? 'You have an active alert.',
      notificationLayout: NotificationLayout.Default,
    ),
  );
}

// Setup Firebase Messaging
void setupFirebaseMessaging() {
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'high_priority_channel',
        title: message.notification?.title ?? 'Alert',
        body: message.notification?.body ?? 'You have an active alert.',
        notificationLayout: NotificationLayout.Default,
      ),
    );
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    // Handle notification tapped logic here
  });
}
