import 'package:bloc/bloc.dart';
import 'package:breaking_project/business_logic/CategoriesTreeCubit/categories_tree_states.dart';
import 'package:breaking_project/data/models/categories_tree_model.dart';
import 'package:breaking_project/data/repository/categories_tree_repository.dart';

class CategoriesTreeCubit extends Cubit<CategoriesTreeStates> {
  CategoriesTreeCubit(this.categoriesTreeRepository)
      : super(CategoriesTreeInitial());

  final CategoriesTreeRepository categoriesTreeRepository;
  late List<RCategoryTreeData> categoriestree = [];

  Future<List<RCategoryTreeData>> getCategoriesTree() async {
    try {
      final thecategoriestree =
          await categoriesTreeRepository.getCategoriesTree();
      categoriestree = thecategoriestree;
      emit(CategoriesTreeLoaded(categoriesTree: categoriestree));
      print("/////////////////545454545454///");
      print(categoriestree);
    } catch (e) {
      print(e.toString());
    }
    return categoriestree;
  }
}
