import 'dart:convert';
import 'package:breaking_project/core/constants/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TechniciansWebservices {
  // Future<List<dynamic>> getTechniciansFromAPI({
  //   String? search,
  //   double? rating,
  //   String? jobCategoryId,
  // }) async {
  //   try {
  //     // بناء الـ URI مع query parameters بشكل ديناميكي
  //     final uri = Uri.parse('${AppConstants.baseUrl}/user/technician').replace(
  //       queryParameters: {
  //         if (search != null && search.isNotEmpty) 'search': search,
  //         if (rating != null) 'rating': rating.toString(),
  //         if (jobCategoryId != null && jobCategoryId.isNotEmpty)
  //           'job_category_id': jobCategoryId,
  //       },
  //     );
  //     final response = await http.get(uri);
  //     if (response.statusCode == 200) {
  //       final jsonData = json.decode(response.body);
  //       return jsonData['technicians']; // عدل حسب الـ response الحقيقي
  //     } else {
  //       throw Exception('Failed to load technicians: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('WebService error: $e');
  //     throw Exception('Error fetching technicians');
  //   }
  // }

  Future<List<Map<String, dynamic>>> getAlltechnicians({
    String? search,
    double? rating,
    String? jobCategoryId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    print("insideee webser $jobCategoryId");
    var token = prefs.getString('auth_token');
    final url = Uri.parse('${AppConstants.baseUrl}/user/technician').replace(
      queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
        if (rating != null) 'rating': rating.toString(),
        if (jobCategoryId != null && jobCategoryId.isNotEmpty)
          'job_category_id': jobCategoryId,
      },
    );
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    print("hhhhhhhhhhhhhhhhhh");

    if (response.statusCode == 200) {
      print('User info: ${response.body}');
      final dataa = jsonDecode(response.body);
      final List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(dataa['data']);
      return data;
    } else {
      print('Failed to get user info: ${response.statusCode}');
      throw Exception('tech get failed');
    }
  }
}
