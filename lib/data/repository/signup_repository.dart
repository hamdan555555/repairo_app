import 'package:breaking_project/data/models/signupUserModel.dart';
import 'package:breaking_project/data/web_services/login_webservice.dart';
import 'package:breaking_project/data/web_services/signup_webservices.dart';

import '../models/user_model.dart';

class SignupRepository {
  final SignupWebservices signupWebService;

  SignupRepository(this.signupWebService);

  Future<SignupUser> signup(
      String email, String password, String phone, String name) async {
    final data = await signupWebService.signup(email, password, phone, name);
    return SignupUser.fromJson(data);
  }
}
