import 'package:breaking_project/data/web_services/login_webservice.dart';

import '../models/user_model.dart';

class AuthRepository {
  final AuthWebService authWebService;

  AuthRepository(this.authWebService);

  Future<User> login(String email, String password) async {
    final data = await authWebService.login(email, password);
    return User.fromJson(data);
  }
}
