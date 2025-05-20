import 'dart:convert';
import 'package:breaking_project/core/constants/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeWebservices {
  Future<List<Map<String, dynamic>>> getBannerImages() async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('auth_token');
    final url = Uri.parse('${AppConstants.baseUrl}/user/home-page/banner');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('Banner info: ${response.body}');
      final dataa = jsonDecode(response.body);
      final List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(dataa['data']);
      print(data.toString());
      return data;
    } else {
      print('Failed to get banner info: ${response.statusCode}');
      throw Exception('banner failed');
    }
  }

  Future<List<Map<String, dynamic>>> searchHome(
      String word, String type) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('auth_token');

    final url = Uri.parse(
        '${AppConstants.baseUrl}/user/home-page/search?word_search=$word&type_search=$type');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('search info: ${response.body}');
      final dataa = jsonDecode(response.body);
      final List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(dataa['data']);
      print(data.toString());
      return data;
    } else {
      print('Failed to get search info: ${response.statusCode}');
      throw Exception('search failed');
    }
  }

  // static String technicianUrl(List<String> serviceIds) {
  //   final buffer = StringBuffer('${AppConstants.baseUrl}/user/technician?');
  //   for (int i = 0; i < serviceIds.length; i++) {
  //     buffer.write('services[$i]=${serviceIds[i]}');
  //     if (i != serviceIds.length - 1) {
  //       buffer.write('&');
  //     }
  //   }
  //   return buffer.toString();
  // }

  static String technicianUrl(List<String> serviceIds) {
    final buffer = StringBuffer('${AppConstants.baseUrl}/user/technician?');

    for (int i = 0; i < serviceIds.length; i++) {
      buffer.write('services[$i]=${serviceIds[i]}');
      if (i != serviceIds.length - 1) buffer.write('&');
    }

    return buffer.toString();
  }

  Future<List<Map<String, dynamic>>> getServicesProviders(
      List<String> services) async {
    final prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('auth_token');

    final url = Uri.parse(technicianUrl(services));
    print(url);

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('services providers info: ${response.body}');
      final dataa = jsonDecode(response.body);
      final List<Map<String, dynamic>> data =
          List<Map<String, dynamic>>.from(dataa['data']);
      print(data.toString());
      return data;
    } else {
      print('Failed to get search info: ${response.statusCode}');
      throw Exception('services providers failed');
    }
  }
}
