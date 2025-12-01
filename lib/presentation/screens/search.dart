import 'dart:async';

import 'package:breaking_project/business_logic/CategoriesTreeCubit/categories_tree_cubit.dart';
import 'package:breaking_project/business_logic/CategoriesTreeCubit/categories_tree_states.dart';
import 'package:breaking_project/business_logic/HomeCubit/home_cubit.dart';
import 'package:breaking_project/business_logic/HomeCubit/home_states.dart';
import 'package:breaking_project/business_logic/SubCategoryCubit/subcategory_cubit.dart';
import 'package:breaking_project/core/constants/app_constants.dart';
import 'package:breaking_project/data/repository/subcategory_repository.dart';
import 'package:breaking_project/data/web_services/subcategories_webservice.dart';
import 'package:breaking_project/presentation/screens/subcategories.dart';
import 'package:flutter/material.dart';
import 'package:breaking_project/presentation/screens/searched_services.dart';
import 'package:breaking_project/presentation/screens/searched_technisians.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import 'package:shimmer/shimmer.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController searchController;
  String type = 'technician';
  late int techcount;
  late int servicecount;
  late String techTab;
  late String serviceTab;
  final List<String> hints = ["صيانة", "تنظيف", "دهان"];
  int currentHintIndex = 0;
  Timer? hintTimer;
  final List<String> popularSearches = [
    "تنظيف منزلي",
    "صالون نسائي",
    "سبا نسائي",
    "فحص مخبري منزلي",
    "مكافحة حشرات"
  ];

  final List<Map<String, dynamic>> featuredServices = [
    {"name": "تنظيف عام", "icon": Icons.cleaning_services},
    {"name": "خدمات الصيانة", "icon": Icons.build},
    {"name": "العناية الصحية المنزلية", "icon": Icons.local_hospital},
    {"name": "صالون منزلي", "icon": Icons.content_cut},
    {"name": "التنظيف العميق", "icon": Icons.cleaning_services_outlined},
  ];

  Widget CategoryCard(String imagePath, String title, void Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 0),
        child: Column(
          children: [
            Image.network(
              imagePath,
              fit: BoxFit.cover,
              height: 50,
            ),
            //Image.asset(imagePath, height: 50),
            const SizedBox(height: 5),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 12,
                  fontFamily: "Cairo",
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    hintTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        currentHintIndex = (currentHintIndex + 1) % hints.length;
      });
    });
    BlocProvider.of<CategoriesTreeCubit>(context).getCategoriesTree();
    searchController = TextEditingController(text: '');
    final cubit = context.read<HomeCubit>();
    techcount = cubit.techssearchresult.length;
    servicecount = cubit.servicessearchresult.length;
    techTab = 'Technician(${techcount.toString()})';
    serviceTab = 'Services(${servicecount.toString()})';
  }

  @override
  void dispose() {
    hintTimer?.cancel();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  backgroundColor: Colors.white,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.only(top: 44),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              // mainAxisAlignment:
              // //  searchController.text == ""
              // //     ? MainAxisAlignment.start
              // //     :
              //      MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: CircleAvatar(
                            radius: 14,
                            backgroundColor: Colors.grey,
                            child: Icon(
                              Icons.arrow_back_ios_new_sharp,
                              size: 16,
                              color: Colors.white,
                            )),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      SizedBox(
                        width: 320.w,
                        height: 45.h,
                        child: TextFormField(
                          cursorWidth: 0.8,
                          controller: searchController,
                          onChanged: (value) {
                            final cubit = context.read<HomeCubit>();
                            cubit.searchServicesHome(
                                searchController.text, 'service');

                            // cubit.searchTechsHome(
                            //     searchController.text, 'technician');
                            // setState(() {
                            //  // techcount = cubit.techssearchresult.length;
                            //   //servicecount = cubit.servicessearchresult.length;
                            //   //techTab = 'Technician ($techcount)';
                            //   //serviceTab = 'Services ($servicecount)';
                            //   print(serviceTab);
                            // });
                          },
                          style: const TextStyle(fontSize: 16),
                          decoration: InputDecoration(
                            hintText: 'ابحث عن "${hints[currentHintIndex]}"',
                            hintStyle: TextStyle(
                                fontFamily: "Cairo",
                                fontSize: 14,
                                color: Colors.grey),
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.8),
                            ),
                            filled: true,
                            fillColor: Colors.white30,
                            focusedBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.8),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 0.8),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(
                  height: 10,
                ),
                Divider(),

                searchController.text == ""
                    ? Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: const [
                                    Icon(Icons.trending_up_outlined, size: 20),
                                    SizedBox(width: 5),
                                    Text(
                                      "عمليات البحث الشائعة",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          fontFamily: "Cairo"),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    'تصليح غسالة',
                                    'تركيب براد',
                                    'تنظيف مكيف',
                                    'تفصيل غرفة نوم',
                                    'دهان غرفة',
                                  ].map((text) {
                                    return ActionChip(
                                      labelStyle:
                                          TextStyle(fontFamily: "Cairo"),
                                      label: Text(text),
                                      onPressed: () {
                                        searchController.text = text;
                                        final cubit = context.read<HomeCubit>();
                                        cubit.searchServicesHome(
                                            searchController.text, 'service');
                                        // تنفيذ البحث هنا
                                      },
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: const [
                                    LineIcon(Icons.star,
                                        color: Colors.amber, size: 20),
                                    SizedBox(width: 5),
                                    Text(
                                      "أفضل الخدمات بالنسبة لك",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          fontFamily: "Cairo"),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              BlocBuilder<CategoriesTreeCubit,
                                  CategoriesTreeStates>(
                                builder: (context, state) {
                                  if (state is CategoriesTreeLoaded) {
                                    return Container(
                                      height: 90,
                                      color: Colors.white,
                                      child: Center(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8),
                                          child: ListView.builder(
                                            itemCount:
                                                state.categoriesTree.length,
                                            itemBuilder: (context, index) {
                                              String type = state
                                                          .categoriesTree[index]
                                                          .displayName ==
                                                      "أدوات سباكة"
                                                  ? "plumbing"
                                                  : state.categoriesTree[index]
                                                              .displayName ==
                                                          "أدوات يدوية"
                                                      ? "handy"
                                                      : state
                                                                  .categoriesTree[
                                                                      index]
                                                                  .displayName ==
                                                              "أدوات منزلية"
                                                          ? "home"
                                                          : state
                                                                      .categoriesTree[
                                                                          index]
                                                                      .displayName ==
                                                                  "أدوات كهربائية"
                                                              ? "electricity"
                                                              : state.categoriesTree[index]
                                                                          .displayName ==
                                                                      "أثاث"
                                                                  ? "furniture"
                                                                  : "";
                                              return CategoryCard(
                                                state.categoriesTree[index]
                                                        .image
                                                        ?.replaceFirst(
                                                            "127.0.0.1",
                                                            AppConstants
                                                                .baseaddress) ??
                                                    "",
                                                state.categoriesTree[index]
                                                        .displayName ??
                                                    "",
                                                () {
                                                  Get.to(
                                                    () => BlocProvider(
                                                      create: (context) => SubcategoryCubit(
                                                          SubcategoryRepository(
                                                              subcategoriesWebservice:
                                                                  SubcategoriesWebservice())),
                                                      child: Subcategories(
                                                        id: state
                                                            .categoriesTree[
                                                                index]
                                                            .id
                                                            .toString(),
                                                        catname: state
                                                            .categoriesTree[
                                                                index]
                                                            .displayName!,
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  return Shimmer.fromColors(
                                    baseColor: Colors.grey.shade300,
                                    highlightColor: Colors.grey.shade100,
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      )
                    : SearchedServ(),

                // Directionality(
                //   textDirection: TextDirection.rtl,
                //   child: GridView.builder(
                //     shrinkWrap:
                //         true, // مهم لتحديد حجم الـ GridView داخل الـ Column
                //     physics:
                //         const NeverScrollableScrollPhysics(), // تعطيل التمرير داخل الـ GridView
                //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                //       crossAxisCount: 2, // عدد الأعمدة
                //       crossAxisSpacing: 2,
                //       mainAxisSpacing: 3,
                //       childAspectRatio: 4, // نسبة الطول إلى العرض
                //     ),
                //     itemCount: popularSearches.length,
                //     itemBuilder: (context, index) {
                //       return ActionChip(
                //         label: Text(popularSearches[index]),
                //         onPressed: () {
                //           // _handleSearch(popularSearches[index]);
                //         },
                //       );
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:breaking_project/business_logic/HomeCubit/home_cubit.dart';
// import 'package:breaking_project/business_logic/HomeCubit/home_states.dart';
// import 'package:flutter/material.dart';
// import 'package:breaking_project/presentation/screens/searched_services.dart';
// import 'package:breaking_project/presentation/screens/searched_technisians.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';

// class SearchScreen extends StatefulWidget {
//   const SearchScreen({super.key});

//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   late TextEditingController searchController;
//   String type = 'technician';
//   late int techcount;
//   late int servicecount;
//   late String techTab;
//   late String serviceTab;

//   @override
//   void initState() {
//     super.initState();
//     searchController = TextEditingController(text: '');
//     final cubit = context.read<HomeCubit>();
//     techcount = cubit.techssearchresult.length;
//     servicecount = cubit.servicessearchresult.length;
//     techTab = 'Technician(${techcount.toString()})';
//     serviceTab = 'Services(${servicecount.toString()})';
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Directionality(
//         textDirection: TextDirection.rtl,
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Icon(Icons.arrow_forward_ios_rounded),
//                 TextFormField(
//                     controller: searchController,
//                     onChanged: (value) {
//                       final cubit = context.read<HomeCubit>();
//                       cubit.searchServicesHome(
//                           searchController.text, 'service');
//                       cubit.searchTechsHome(
//                           searchController.text, 'technician');
//                       setState(() {
//                         techcount = cubit.techssearchresult.length;
//                         servicecount =
//                             cubit.servicessearchresult.length;
//                         techTab = 'Technician ($techcount)';
//                         serviceTab = 'Services ($servicecount)';
//                         print(serviceTab);
//                       });
//                     },
//                     style: const TextStyle(fontSize: 16),
//                     decoration: const InputDecoration(
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(30),
//                           bottomLeft: Radius.circular(30),
//                         ),
//                       ),
//                       filled: true,
//                       fillColor: Colors.white,
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(30),
//                           bottomLeft: Radius.circular(30),
//                         ),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(30),
//                           bottomLeft: Radius.circular(30),
//                         ),
//                       ),
//                     ),
//                   )],
//                 ),
//               ],
//             )
//       ],
//         ),
//       ),
//     );

//     //  DefaultTabController(
//     //   length: 2,
//     //   initialIndex: 0,
//     //   child: Scaffold(
//     //     body: Column(
//     //       children: [
//     // Container(
//     //   height: 280,
//     //   color: const Color.fromARGB(255, 236, 233, 233),
//     //   child: Padding(
//     //     padding: const EdgeInsets.only(left: 8, right: 8, top: 40),
//     //     child: Column(
//     //       children: [
//     //         // Row(
//     //         // children: [
//     //         // IconButton(
//     //         //   onPressed: () {
//     //         //     Get.back();
//     //         //   },
//     //         //   icon: const Icon(Icons.arrow_back_ios_new_outlined),
//     //         // ),
//     //         // const Spacer(),
//     //         const Text(
//     //           "Search",
//     //           style:
//     //               TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
//     //         ),
//     //         //const Spacer(flex: 2),
//     //         //],
//     //         //),
//     //         const SizedBox(height: 15),
//     //         Padding(
//     //           padding: const EdgeInsets.only(left: 20),
//     //           child: GestureDetector(
//     //             onTap: () {},
//     //             child: Row(
//     //               children: const [
//     //                 Text(
//     //                   "Current Location : ",
//     //                   style: TextStyle(fontSize: 17),
//     //                 ),
//     //                 Text(
//     //                   "home",
//     //                   style: TextStyle(
//     //                       fontSize: 17,
//     //                       color: Colors.deepPurple,
//     //                       fontWeight: FontWeight.bold),
//     //                 ),
//     //                 Icon(
//     //                   Icons.keyboard_arrow_down,
//     //                   color: Colors.deepPurple,
//     //                 )
//     //               ],
//     //             ),
//     //           ),
//     //         ),
//     //         const SizedBox(height: 10),
//     //         Row(
//     //           children: [
//     //             SizedBox(
//     //               width: 300,
//     //               height: 45,
//     //               child: TextFormField(
//     //                 controller: searchController,
//     //                 onChanged: (value) {
//     //                   final cubit = context.read<HomeCubit>();
//     //                   cubit.searchServicesHome(
//     //                       searchController.text, 'service');
//     //                   cubit.searchTechsHome(
//     //                       searchController.text, 'technician');
//     //                   setState(() {
//     //                     techcount = cubit.techssearchresult.length;
//     //                     servicecount =
//     //                         cubit.servicessearchresult.length;
//     //                     techTab = 'Technician ($techcount)';
//     //                     serviceTab = 'Services ($servicecount)';
//     //                     print(serviceTab);
//     //                   });
//     //                 },
//     //                 style: const TextStyle(fontSize: 16),
//     //                 decoration: const InputDecoration(
//     //                   border: OutlineInputBorder(
//     //                     borderRadius: BorderRadius.only(
//     //                       topLeft: Radius.circular(30),
//     //                       bottomLeft: Radius.circular(30),
//     //                     ),
//     //                   ),
//     //                   filled: true,
//     //                   fillColor: Colors.white,
//     //                   focusedBorder: OutlineInputBorder(
//     //                     borderRadius: BorderRadius.only(
//     //                       topLeft: Radius.circular(30),
//     //                       bottomLeft: Radius.circular(30),
//     //                     ),
//     //                   ),
//     //                   enabledBorder: OutlineInputBorder(
//     //                     borderRadius: BorderRadius.only(
//     //                       topLeft: Radius.circular(30),
//     //                       bottomLeft: Radius.circular(30),
//     //                     ),
//     //                   ),
//     //                 ),
//     //               ),
//     //             ),
//     //             Container(
//     //               height: 45,
//     //               width: 40,
//     //               decoration: BoxDecoration(
//     //                 color: Colors.white,
//     //                 borderRadius: const BorderRadius.only(
//     //                   topRight: Radius.circular(30),
//     //                   bottomRight: Radius.circular(30),
//     //                 ),
//     //                 border: Border.all(color: Colors.black),
//     //               ),
//     //               child: const Icon(
//     //                 Icons.search,
//     //                 color: Color.fromARGB(255, 179, 174, 174),
//     //               ),
//     //             ),
//     //           ],
//     //         ),
//     //         const SizedBox(height: 20),
//     //         BlocBuilder<HomeCubit, HomeStates>(
//     //           builder: (context, state) {
//     //             final cubit = context.read<HomeCubit>();
//     //             final techcount = cubit.techssearchresult.length;
//     //             final servicecount = cubit.servicessearchresult.length;
//     //             final techTab = 'Technicians ($techcount)';
//     //             final serviceTab = 'Services ($servicecount)';

//     //             return TabBar(
//     //               indicatorColor: Colors.black,
//     //               labelColor: Colors.black,
//     //               unselectedLabelColor: Colors.grey,
//     //               tabs: [
//     //                 Tab(icon: const Icon(Icons.person), text: techTab),
//     //                 Tab(
//     //                     icon: const Icon(Icons.settings),
//     //                     text: serviceTab),
//     //               ],
//     //             );
//     //           },
//     //         ),
//     //       ],
//     //     ),
//     //   ),
//     // ),
//     //const SizedBox(height: 5),
    // Expanded(
    //   child: TabBarView(
    //     children: [
    //       SearchedTechs(), // أو SearchedTechnisians(...)
    //       SearchedServ(), // أو SearchedServices(...)
    //     ],
    //   ),
//     // ),
//     //       ],
//     //     ),
//     //   ),
//     // );
//   }
// }
