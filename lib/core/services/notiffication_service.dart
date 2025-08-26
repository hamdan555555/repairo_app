import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    // طلب صلاحيات (مهم خصوصاً بالـ iOS)
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    // الحصول على الـ Token لحتى رفيقك يبث عليه
    String? token = await _messaging.getToken();
    print("FCM Token: $token");

    // الاستماع للرسائل وقت التطبيق مفتوح
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("رسالة جديدة: ${message.notification?.title}");
      // هون بتعرض اشعار محلي
    });

    // وقت يضغط على الاشعار ويفتح التطبيق
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("تم الضغط على الاشعار: ${message.notification?.title}");
      // ممكن تفتح صفحة معينة
    });

    // وقت يكون التطبيق مغلق وفتح بسبب اشعار
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      print("اشعار فتح التطبيق: ${initialMessage.notification?.title}");
    }
  }
}
