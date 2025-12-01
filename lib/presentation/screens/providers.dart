import 'package:breaking_project/business_logic/AllCategoriesCubit/allcategories_states.dart';
import 'package:breaking_project/business_logic/AllCategoriesCubit/allcaterories_cubit.dart';
import 'package:breaking_project/business_logic/AllTechniciansCubiit/alltechnisian_cubit.dart';
import 'package:breaking_project/business_logic/AllTechniciansCubiit/alltechnisian_states.dart';
import 'package:breaking_project/business_logic/TechDataCubit/tech_data_cubit.dart';
import 'package:breaking_project/core/constants/app_constants.dart';
import 'package:breaking_project/data/models/category_model.dart';
import 'package:breaking_project/data/models/technisians_model.dart';
import 'package:breaking_project/data/repository/technician_data_repository.dart';
import 'package:breaking_project/data/web_services/technician_data_webservices.dart';
import 'package:breaking_project/presentation/screens/tech_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  double? selectedRating;
  RCategoryData? selelectedcat;
  String searchKeyword = '';

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AlltechnisianCubit>(context).getAlltechnisians();
    BlocProvider.of<AllcategoriesCubit>(context).getAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.teal,
          elevation: 0,
          title: const Text(
            "جميع المهنيين",
            style: TextStyle(
              fontFamily: "Cairo",
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
        body: Column(
          children: [
            buildFilterOptions(),
            Expanded(child: buildBlocWidget()),
          ],
        ),
      ),
    );
  }

  Widget buildFilterOptions() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: BlocBuilder<AllcategoriesCubit, AllcategoriesStates>(
                  builder: (context, state) {
                    if (state is AllcategoriesLoaded) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.teal, width: 1),
                        ),
                        child: DropdownButton<RCategoryData>(
                          dropdownColor: Colors.white,
                          isExpanded: true,
                          underline: const SizedBox(),
                          hint: const Text("كل الفئات",
                              style: TextStyle(fontFamily: "Cairo")),
                          value: selelectedcat,
                          items: context
                              .read<AllcategoriesCubit>()
                              .categories
                              .map(
                                  (category) => DropdownMenuItem<RCategoryData>(
                                        value: category,
                                        child: Text(
                                            category.displayName ?? 'غير محدد',
                                            style: const TextStyle(
                                                fontFamily: "Cairo")),
                                      ))
                              .toList(),
                          onChanged: (value) {
                            setState(() => selelectedcat = value!);
                            context
                                .read<AlltechnisianCubit>()
                                .getAlltechnisians(
                                  jobCategoryId: selelectedcat!.id,
                                  rating: selectedRating,
                                );
                          },
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: InputDecoration(
              hintText: "ابحث بالاسم...",
              hintStyle: const TextStyle(fontFamily: "Cairo"),
              prefixIcon: const Icon(Icons.search, color: Colors.teal),
              filled: true,
              fillColor: Colors.grey.shade100,
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.teal, width: 2),
              ),
            ),
            onChanged: (value) {
              setState(() => searchKeyword = value.toLowerCase());
            },
          ),
        ],
      ),
    );
  }

  Widget buildBlocWidget() {
    return BlocBuilder<AlltechnisianCubit, AlltechnisiansStates>(
      builder: (context, state) {
        if (state is AllAlltechnisiansLoaded) {
          final allTechs = state.technicians;
          final filteredTechs = allTechs.where((tech) {
            final name = tech.name?.toLowerCase() ?? '';
            return name.contains(searchKeyword);
          }).toList();

          if (filteredTechs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      height: 50,
                      width: 50,
                      child: Image.asset(
                        "assets/images/png/notfound.png",
                        fit: BoxFit.cover,
                      )),
                  SizedBox(
                    height: 4.h,
                  ),
                  Text("لا يوجد مهنيين مطابقين",
                      style: TextStyle(fontFamily: "Cairo")),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: filteredTechs.length,
            itemBuilder: (ctx, index) => buildTechCard(filteredTechs[index]),
          );
        } else {
          return const Center(
              child: CircularProgressIndicator(color: Colors.teal));
        }
      },
    );
  }

  Widget buildTechCard(RTechData tech) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: () {
          if (tech.id != null) {
            Get.to(() => BlocProvider(
                  create: (context) => TechDataCubit(
                    TechnicianDataRepository(
                      technicianDataWebservices: TechnicianDataWebservices(),
                    ),
                  ),
                  child: TechDataScreen(id: tech.id!),
                ));
          } else {
            // إذا الـ id = null ما نعمل انتقال
            Get.snackbar("خطأ", "المهني غير صالح لعرض التفاصيل",
                backgroundColor: Colors.redAccent, colorText: Colors.white);
          }
        },
        leading: CircleAvatar(
          radius: 28,
          backgroundImage: (tech.image != null && tech.image!.isNotEmpty)
              ? NetworkImage(tech.image!
                  .replaceFirst("127.0.0.1", AppConstants.baseaddress))
              : const AssetImage("assets/images/png/default_avatar.png"),
        ),
        title: Text(
          tech.name?.isNotEmpty == true ? tech.name! : "بدون اسم",
          style: const TextStyle(
            fontFamily: "Cairo",
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              tech.category?.displayName?.isNotEmpty == true
                  ? tech.category!.displayName!
                  : "فئة غير محددة",
              style: const TextStyle(fontFamily: "Cairo", fontSize: 13),
            ),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                Text(
                  tech.rating?.toString() ?? "0.0",
                  style: const TextStyle(fontFamily: "Cairo", fontSize: 13),
                ),
              ],
            ),
          ],
        ),
        trailing:
            const Icon(Icons.arrow_forward_ios_outlined, color: Colors.teal),
      ),
    );
  }
}
