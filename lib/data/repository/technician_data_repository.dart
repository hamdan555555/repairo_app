import 'package:breaking_project/data/models/tech_data_model.dart';
import 'package:breaking_project/data/web_services/technician_data_webservices.dart';

class TechnicianDataRepository {
  final TechnicianDataWebservices technicianDataWebservices;

  TechnicianDataRepository({required this.technicianDataWebservices});

  Future<RTecPData> getTechPData(String id) async {
    final item = await technicianDataWebservices.getTechPData(id);
    return RTecPData.fromJson(item);
  }
}
