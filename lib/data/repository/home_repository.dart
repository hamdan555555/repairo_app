import 'package:breaking_project/data/models/banner_image_model.dart';
import 'package:breaking_project/data/models/search_model.dart';
import 'package:breaking_project/data/web_services/home_webservices.dart';

class HomeRepository {
  final HomeWebservices homeWebservices;

  HomeRepository({required this.homeWebservices});

  Future<List<RBannerImageData>> getBannerImages() async {
    final items = await homeWebservices.getBannerImages();
    return items.map((item) => RBannerImageData.fromJson(item)).toList();
  }

  Future<List<RSearchData>> searchHome(String word, String type) async {
    final items = await homeWebservices.searchHome(word, type);
    return items.map((item) => RSearchData.fromJson(item)).toList();
  }
}
