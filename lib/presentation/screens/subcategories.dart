import 'package:breaking_project/business_logic/SubCategoryCubit/subcategory_cubit.dart';
import 'package:breaking_project/business_logic/SubCategoryCubit/subcategory_states.dart';
import 'package:breaking_project/data/models/subcategory_model.dart';
import 'package:breaking_project/presentation/widgets/subcaterories_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class Subcategories extends StatefulWidget {
  final String id;
  final String catname;
  Subcategories({Key? key, required this.id, required this.catname})
      : super(key: key);
  @override
  State<Subcategories> createState() => SubcategoriesStatee();
}

class SubcategoriesStatee extends State<Subcategories> {
  late List<RSubCategoryData> subcategories;
  final searchTextController = TextEditingController();
  late String categoryname;

  late String id;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<SubcategoryCubit>(context).getSubCategories(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back_ios_new)),
          title: Text(
            widget.catname,
            style: TextStyle(fontFamily: "Cairo", fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Container(color: Colors.white10, child: buildBlocWidget()),
        ),
      ),
    );
  }

  Widget buildBlocWidget() {
    return BlocBuilder<SubcategoryCubit, SubcategoryStates>(
        builder: (context, state) {
      if (state is SubcategoriesLoaded) {
        subcategories = (state).subcategories;
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
      color: Colors.teal,
    ));
  }

  Widget builditemsList() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 4,
          ),
          itemCount: context.read<SubcategoryCubit>().subcategories.length,
          itemBuilder: (ctx, index) {
            return SubcateroriesWidget(
              subcategory:
                  context.read<SubcategoryCubit>().subcategories[index],
            );
          },
        ));
  }
}
