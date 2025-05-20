import 'package:breaking_project/data/models/technisians_model.dart';
import 'package:breaking_project/data/web_services/technicians_webservices.dart';

class TechniciansRepository {
  final TechniciansWebservices techniciansWebservices;

  TechniciansRepository({required this.techniciansWebservices});

  Future<List<RTechData>> getAlltechnicians({
    String? search,
    double? rating,
    String? jobCategoryId,
  }) async {
    final items = await techniciansWebservices.getAlltechnicians(
        search: search, rating: rating, jobCategoryId: jobCategoryId);
    return items.map((item) => RTechData.fromJson(item)).toList();
  }
}
