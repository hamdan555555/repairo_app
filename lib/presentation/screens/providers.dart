import 'package:breaking_project/business_logic/AllCategoriesCubit/allcategories_states.dart';
import 'package:breaking_project/business_logic/AllCategoriesCubit/allcaterories_cubit.dart';
import 'package:breaking_project/business_logic/AllTechniciansCubiit/alltechnisian_cubit.dart';
import 'package:breaking_project/business_logic/AllTechniciansCubiit/alltechnisian_states.dart';
import 'package:breaking_project/business_logic/HomeCubit/home_cubit.dart';
import 'package:breaking_project/business_logic/TechDataCubit/tech_data_cubit.dart';
import 'package:breaking_project/core/constants/app_constants.dart';
import 'package:breaking_project/data/models/category_model.dart';
import 'package:breaking_project/data/models/technisians_model.dart';
import 'package:breaking_project/data/repository/technician_data_repository.dart';
import 'package:breaking_project/data/web_services/technician_data_webservices.dart';
import 'package:breaking_project/presentation/screens/tech_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  double? selectedRating;
  RCategoryData? selelectedcat;
  String searchKeyword = ''; // <-- متغير البحث

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AlltechnisianCubit>(context).getAlltechnisians();
    BlocProvider.of<AllcategoriesCubit>(context).getAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Service Providers", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          buildFilterOptions(),
          Expanded(child: buildBlocWidget()),
        ],
      ),
    );
  }

  Widget buildFilterOptions() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BlocBuilder<AllcategoriesCubit, AllcategoriesStates>(
                  builder: (context, state) {
                    if (state is AllcategoriesLoaded) {
                      return DropdownButton<RCategoryData>(
                        hint: Text("All"),
                        value: selelectedcat,
                        items: context
                            .read<AllcategoriesCubit>()
                            .categories
                            .map((category) => DropdownMenuItem<RCategoryData>(
                                  value: category,
                                  child: Text(category.displayName ?? 'All'),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selelectedcat = value!;
                          });

                          context.read<AlltechnisianCubit>().getAlltechnisians(
                                jobCategoryId: selelectedcat!.id,
                                rating: selectedRating,
                              );
                        },
                      );
                    }
                    return DropdownButton<String>(
                      hint: Text("All"),
                      value: 'All',
                      items: [
                        DropdownMenuItem<String>(
                          value: 'All',
                          child: Text('All'),
                        )
                      ],
                      onChanged: (val) {},
                    );
                  },
                ),
                DropdownButton<double>(
                  hint: Text("Rating"),
                  value: selectedRating,
                  items: [null, 5.0, 4.0, 3.0, 2.0, 1.0].map((rate) {
                    return DropdownMenuItem(
                      value: rate,
                      child: Text(rate == null ? "All" : rate.toString()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedRating = value;
                    });
                    BlocProvider.of<AlltechnisianCubit>(context)
                        .getAlltechnisians(
                      jobCategoryId: selelectedcat?.id,
                      rating: selectedRating,
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search by name...",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onChanged: (value) {
                  setState(() {
                    searchKeyword = value.toLowerCase();
                  });
                },
              ),
            ),
          ],
        ));
  }

  Widget buildBlocWidget() {
    return BlocBuilder<AlltechnisianCubit, AlltechnisiansStates>(
      builder: (context, state) {
        if (state is AllAlltechnisiansLoaded) {
          final allTechs = state.technicians;

          // فلترة حسب الاسم
          final filteredTechs = allTechs.where((tech) {
            final name = tech.name?.toLowerCase() ?? '';
            return name.contains(searchKeyword);
          }).toList();

          if (filteredTechs.isEmpty) {
            return Center(child: Text("No technicians found."));
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: filteredTechs.length,
            itemBuilder: (ctx, index) => buildTechCard(filteredTechs[index]),
          );
        } else {
          return Center(
              child: CircularProgressIndicator(color: Colors.deepPurple));
        }
      },
    );
  }

  Widget buildTechCard(RTechData tech) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: () {
          print("hereeeee is ${tech.id}");
          Get.to(() => BlocProvider(
                create: (context) => TechDataCubit(TechnicianDataRepository(
                    technicianDataWebservices: TechnicianDataWebservices())),
                child: TechDataScreen(id: tech.id!),
              ));
        },
        leading: CircleAvatar(
          backgroundImage: tech.image!.isNotEmpty
              ? NetworkImage(
                  tech.image!
                      .replaceFirst('127.0.0.1', AppConstants.baseaddress),
                )
              : const AssetImage('assets/images/jpg/hamdan.jpg'),
        ),
        title: Text(tech.name ?? ""),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text("Category: ${tech.name ?? "Unknown"}"),
            if (tech.rating != null) Text("Rating: ${tech.rating!.toString()}"),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
