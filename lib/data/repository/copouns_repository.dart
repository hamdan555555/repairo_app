import 'package:breaking_project/data/models/coponus_model.dart';
import 'package:breaking_project/data/web_services/user_copuns_webservice.dart';

class CopounsRepository {
  final UserCopunsWebservice copunsWebservice;

  CopounsRepository({required this.copunsWebservice});

  Future<List<RCoponusData>> getAllCopuns() async {
    final response = await copunsWebservice.getCopuns();

    // حوّل الاستجابة إلى موديل Copouns
    final copouns = Copouns.fromJson(response);

    // رجّع الليست فقط
    return copouns.data ?? [];
  }
}
