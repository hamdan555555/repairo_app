import 'package:breaking_project/data/models/user_requests_model.dart';
import 'package:breaking_project/data/web_services/user_requests_webservices.dart';

class UserRequestsRepository {
  final UserRequestsWebservices userRequestsWebservices;

  UserRequestsRepository({required this.userRequestsWebservices});

  Future<List<RUserRequestData>> getAllRequests({
    String? status,
  }) async {
    final items = await userRequestsWebservices.getAllRequests(status: status);
    return items.map((item) => RUserRequestData.fromJson(item)).toList();
  }
}
