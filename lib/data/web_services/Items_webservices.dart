import 'dart:convert';
import 'package:http/http.dart' as http;

class ItemsWebservices {
  Future<List<dynamic>> getItems() async {
    print("11111111111111111111111111111");
    final response =
        await http.get(Uri.parse('https://fakestoreapi.com/products'));
    print("22222222222222222222222222222");

    print(response.body);
    final data = jsonDecode(response.body);
    print("333333333333333333333333333");

    //final List products = data['products'];
    if (response.statusCode == 200) {
      print("444444444444444444444444444444444");

      return data;
    } else {
      print("55555555555555555555555555555");
      throw ('error happened');
    }
  }
}
