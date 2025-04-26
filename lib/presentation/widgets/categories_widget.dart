import 'package:breaking_project/business_logic/SubCategoryCubit/subcategory_cubit.dart';
import 'package:breaking_project/data/models/category_model.dart';
import 'package:breaking_project/data/repository/subcategory_repository.dart';
import 'package:breaking_project/data/web_services/subcategories_webservice.dart';
import 'package:breaking_project/presentation/screens/subcategories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class CategoriesWidget extends StatelessWidget {
  final RCategoryData category;
  const CategoriesWidget({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => BlocProvider(
            create: (context) => SubcategoryCubit(SubcategoryRepository(
                subcategoriesWebservice: SubcategoriesWebservice())),
            child: Subcategories(id: category.id.toString()),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 223, 217, 217), // لون خلفية خفيف
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 7,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SvgPicture.asset(
                  'assets/images/svg/home.svg',
                  width: 70,
                  height: 70,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  category.displayName!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
