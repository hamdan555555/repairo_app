import 'package:breaking_project/data/models/request_details_model.dart';
import 'package:breaking_project/data/web_services/request_details_webservices.dart';

class RequsetDetailsRepository {
  final RequestDetailsWebservices requestDetailsWebservices;

  RequsetDetailsRepository(this.requestDetailsWebservices);

  Future<RRequestDetailsData> getRequestDetails(String id) async {
    final data = await requestDetailsWebservices.getRequestDetails(id);
    return RRequestDetailsData.fromJson(data);
  }
}
