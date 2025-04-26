import 'package:breaking_project/business_logic/SubCategoryCubit/subcategory_cubit.dart';
import 'package:breaking_project/business_logic/SubCategoryCubit/subcategory_states.dart';
import 'package:breaking_project/data/models/subcategory_model.dart';
import 'package:breaking_project/presentation/widgets/subcaterories_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class Subcategories extends StatefulWidget {
  final String id;
  Subcategories({Key? key, required this.id}) : super(key: key);
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios_new)),
        title: Text("Sub Categories"),
      ),
      body: Container(color: Colors.white10, child: buildBlocWidget()),
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
        itemCount: context.read<SubcategoryCubit>().subcategories.length,
        itemBuilder: (ctx, index) {
          return SubcateroriesWidget(
            subcategory: context.read<SubcategoryCubit>().subcategories[index],
          );
        },
      ),
    );
  }
}
