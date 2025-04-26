import 'package:breaking_project/data/models/subcategory_model.dart';
import 'package:breaking_project/data/web_services/subcategories_webservice.dart';

class SubcategoryRepository {
  final SubcategoriesWebservice subcategoriesWebservice;

  SubcategoryRepository({required this.subcategoriesWebservice});

  Future<List<RSubCategoryData>> getSubCAtegories(String id) async {
    final items = await subcategoriesWebservice.getSubCategories(id);
    return items.map((item) => RSubCategoryData.fromJson(item)).toList();
  }
}
