import 'package:breaking_project/data/web_services/login_webservice.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/userlog_model.dart';

class AuthRepository {
  final AuthWebService authWebService;

  AuthRepository(this.authWebService);

  Future<UserLog> login(String phone) async {
    final data = await authWebService.login(phone);

    return UserLog.fromJson(data);
  }
}
