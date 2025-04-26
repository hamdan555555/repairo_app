import 'package:bloc/bloc.dart';
import 'package:breaking_project/business_logic/AllCategoriesCubit/allcategories_states.dart';
import 'package:breaking_project/data/models/category_model.dart';
import 'package:breaking_project/data/repository/categories_repository.dart';

class AllcategoriesCubit extends Cubit<AllcategoriesStates> {
  AllcategoriesCubit(this.categoriesRepository) : super(AllcategoriesInitial());

  final CategoriesRepository categoriesRepository;
  late List<RCategoryData> categories = [];

  Future<List<RCategoryData>> getAllCategories() async {
    categoriesRepository.getAllCategories().then((thecategories) {
      emit(AllcategoriesLoaded(categories: categories));
      categories = thecategories;
    });
    return categories;
  }
}
