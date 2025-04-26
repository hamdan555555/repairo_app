import 'package:bloc/bloc.dart';
import 'package:breaking_project/business_logic/SubCategoryCubit/subcategory_states.dart';
import 'package:breaking_project/data/models/subcategory_model.dart';
import 'package:breaking_project/data/repository/subcategory_repository.dart';

class SubcategoryCubit extends Cubit<SubcategoryStates> {
  SubcategoryCubit(this.subcategoryRepository) : super(SubcategoriesInitial());

  final SubcategoryRepository subcategoryRepository;
  late List<RSubCategoryData> subcategories = [];

  Future<List<RSubCategoryData>> getSubCategories(String id) async {
    subcategoryRepository.getSubCAtegories(id).then((thesubcategories) {
      emit(SubcategoriesLoaded(subcategories: subcategories));
      subcategories = thesubcategories;
    });
    return subcategories;
  }
}
