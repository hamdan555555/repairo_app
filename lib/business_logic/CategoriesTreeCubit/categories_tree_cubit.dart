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
    categoriesTreeRepository.getCategoriesTree().then((thecategoriestree) {
      emit(CategoriesTreeLoaded(categoriesTree: thecategoriestree));
      categoriestree = thecategoriestree;
    });
    return categoriestree;
  }
}
