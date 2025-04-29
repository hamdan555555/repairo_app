//أولا بنية المشروع هي كالتالي
// lib/
// │
// ├── core/                         # يحتوي على الأشياء المشتركة عبر كامل المشروع
// │   ├── constants/                # ثوابت عامة (Strings, Colors, Fonts, etc.)
// │   │   ├── app_colors.dart
// │   │   ├── app_strings.dart
// │   │   ├── app_fonts.dart
// │   │   └── app_values.dart       # padding, radius, durations...
// │   │
// │   ├── utils/                    # أدوات مساعدة (Validation, Formatters, etc.)
// │   │   ├── validators.dart
// │   │   ├── error_handler.dart
// │   │   └── helpers.dart
// │   │
// │   ├── services/                 # Services شغالة على مستوى التطبيق
// │   │   ├── network_checker.dart
// │   │   ├── notification_service.dart
// │   │   └── local_storage_service.dart
// │   │
// │   └── config/                   # إعدادات التطبيق العامة
// │       └── app_config.dart
// │
// ├── data/                         # طبقة البيانات
// │   ├── models/
// │   ├── webservices/
// │   └── repository/
// │
// ├── business_logic/               # Cubits + States
// │
// ├── presentation/                 # الشاشات والـ UI
// │   ├── screens/
// │   ├── widgets/
// │   └── dialogs/
// │
// └── main.dart


// 1. ثوابت المشروع:
// app_strings.dart: كل النصوص الثابتة (مثلاً: "تسجيل الدخول", "اسم المستخدم").

// app_colors.dart: ألوان موحّدة.

// app_fonts.dart: إعدادات الخطوط.

// app_values.dart: قيم ثابتة مثل الـ padding, borderRadius...

// 2. Validation و Error Handling:
// validators.dart: يحتوي على دوال مثل isValidEmail, isStrongPassword, الخ...

// error_handler.dart: دالة handleError(Exception e) مثلاً، بتعمل mapping للـ exceptions إلى رسائل مفهومة.

// 3. خدمات عامة:
// أي شيء بدك تستخدمه على مستوى المشروع كامل بتحطه بمجلد services/ مثل:

// NetworkChecker: ليتأكد من الاتصال.

// NotificationService: لإرسال الإشعارات.

// LocalStorageService: SharedPreferences أو Hive.



/////////////////////////////sharedPrefrence/////////////////////
//ملاحظة بالنسبة لل sharedprefrence
// لما تفتح التطبيق (بـ main.dart) لازم تنادي:
// dart
// Copy
// Edit
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await LocalStorageService.init();
//   runApp(MyApp());
// لما المستخدم ينتقل لشاشة جديدة (مثلاً لما يدخل على ProfilePage)،
// بتخزنها بهالشكل:
// dart
// Copy
// Edit
// await LocalStorageService.saveLastVisitedScreen('/profile');
// ولما يفتح التطبيق (SplashScreen أو init عند بداية البرنامج)،
// تستدعي:
// dart
// Copy
// Edit
// String? lastScreen = LocalStorageService.getLastVisitedScreen();
// if (lastScreen != null) {
//   Navigator.pushNamed(context, lastScreen);
// } else {
//   Navigator.pushNamed(context, '/home');
// }
// ➔ هيك إذا كان مخزن آخر شاشة، بتفوتو عليها، وإذا لأ بتوديه على الشاشة الرئيسية.




