import 'package:breaking_project/data/models/categories_tree_model.dart';
import 'package:breaking_project/data/web_services/categories_tree_webservices.dart';

class CategoriesTreeRepository {
  final CategoriesTreeWebservices categoriesTreeWebservices;

  CategoriesTreeRepository({required this.categoriesTreeWebservices});

  Future<List<RCategoryTreeData>> getCategoriesTree() async {
    final items = await categoriesTreeWebservices.getCategoriesTree();
    return items.map((item) => RCategoryTreeData.fromJson(item)).toList();
  }
}
