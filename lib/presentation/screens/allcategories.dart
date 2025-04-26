import 'package:breaking_project/business_logic/AllCategoriesCubit/allcategories_states.dart';
import 'package:breaking_project/business_logic/AllCategoriesCubit/allcaterories_cubit.dart';
import 'package:breaking_project/data/models/category_model.dart';
import 'package:breaking_project/presentation/widgets/categories_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class Allcategories extends StatefulWidget {
  const Allcategories({super.key});
  @override
  State<Allcategories> createState() => AllcategoriesStatee();
}

class AllcategoriesStatee extends State<Allcategories> {
  late List<RCategoryData> allcategories;
  final searchTextController = TextEditingController();

  @override
  void initState() {
    BlocProvider.of<AllcategoriesCubit>(context).getAllCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios_new)),
        title: Text("all categories"),
      ),
      body: Container(color: Colors.white10, child: buildBlocWidget()),
    );
  }

  Widget buildBlocWidget() {
    return BlocBuilder<AllcategoriesCubit, AllcategoriesStates>(
        builder: (context, state) {
      if (state is AllcategoriesLoaded) {
        allcategories = (state).categories;
        return buildLoadedListWidget();
      } else {
        return showloadingindicator();
      }
    });
  }

  Widget buildLoadedListWidget() {
    return builditemsList();
  }

  Widget showloadingindicator() {
    return const Center(
        child: CircularProgressIndicator(
      color: const Color.fromRGBO(95, 96, 185, 1),
    ));
  }

  Widget builditemsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: context.read<AllcategoriesCubit>().categories.length,
        itemBuilder: (ctx, index) {
          return CategoriesWidget(
            category: context.read<AllcategoriesCubit>().categories[index],
          );
        },
      ),
    );
  }
}
