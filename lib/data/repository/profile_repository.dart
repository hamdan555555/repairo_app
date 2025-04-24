import 'package:breaking_project/data/models/userprofile.dart';
import 'package:breaking_project/data/web_services/profile_webservices.dart';

class ProfileRepository {
  final ProfileWebservices profileWebservices;

  ProfileRepository(this.profileWebservices);

  Future<UserProfile> getUserData(String token) async {
    final data = await profileWebservices.getUserInfo(token);
    return UserProfile.fromJson(data);
  }
}
