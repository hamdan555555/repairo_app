import 'package:breaking_project/data/models/user_model.dart';
import 'package:breaking_project/data/web_services/verification_webservices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerificationRepository {
  final VerificationWebservices verificationWebservices;
  VerificationRepository(this.verificationWebservices);
  Future<User> verifyNumber(String phone, String code, String fcm) async {
    final data = await verificationWebservices.verifyNumber(phone, code, fcm);
    final token = data['data']['access_token'];
    final name = data['data']['name'];
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('user_name', name);
    return User.fromJson(data);
  }
}
