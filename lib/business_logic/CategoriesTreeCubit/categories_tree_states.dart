import 'package:breaking_project/data/models/categories_tree_model.dart';

abstract class CategoriesTreeStates {}

class CategoriesTreeInitial extends CategoriesTreeStates {}

class CategoriesTreeFailed extends CategoriesTreeStates {
  final String message;
  CategoriesTreeFailed(this.message);
}

class CategoriesTreeLoading extends CategoriesTreeStates {}

class CategoriesTreeLoaded extends CategoriesTreeStates {
  final List<RCategoryTreeData> categoriesTree;
  CategoriesTreeLoaded({required this.categoriesTree});
}
