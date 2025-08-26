import 'package:breaking_project/core/services/local_notiffication_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print("title ${message.notification?.title}");
  print("body ${message.notification?.body}");
  print("payload ${message.data}");
  await LocalNotifications.showNotification(message);
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
//the directed page should recieva a message paramete
    Get.toNamed("mainscreen");
  }

  Future initPushNotiffications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
    //responsible for performing an action when app is opened from a terminated state
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  Future<void> initNotiffications() async {
    await _firebaseMessaging.requestPermission();
    final fcmToken = await _firebaseMessaging.getToken();
    print("token $fcmToken");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fcm', fcmToken!);

    initPushNotiffications();
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    // لما يكون التطبيق مفتوح (foreground)
    FirebaseMessaging.onMessage.listen((message) {
      print("Foreground message: ${message.notification?.title}");
      LocalNotifications.showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("User tapped notification: ${message.data}");
    });
  }
}
