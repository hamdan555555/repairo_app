class AppConstants {
  static const baseaddress = '192.168.124.20';
  static const baseUrl = 'http://$baseaddress:8000/api';
  static const Duration connectionTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const String defaultLanguage = "ar";

  static const int itemsPerPage = 20;

  // مفاتيح الـ APIs

  static const String googleMapsApiKey = "YOUR_GOOGLE_MAPS_API_KEY";
  static const String firebaseServerKey = "YOUR_FIREBASE_SERVER_KEY";

  // روابط صور افتراضية
  static const String defaultUserImage = "https://example.com/default_user.png";
}
