import 'dart:async';
import 'package:breaking_project/business_logic/AllCategoriesCubit/allcategories_states.dart';
import 'package:breaking_project/business_logic/AllCategoriesCubit/allcaterories_cubit.dart';
import 'package:breaking_project/business_logic/CategoriesTreeCubit/categories_tree_cubit.dart';
import 'package:breaking_project/business_logic/CategoriesTreeCubit/categories_tree_states.dart';
import 'package:breaking_project/business_logic/HomeCubit/home_cubit.dart';
import 'package:breaking_project/business_logic/HomeCubit/home_states.dart';
import 'package:breaking_project/business_logic/ServiceCubit/service_cubit.dart';
import 'package:breaking_project/business_logic/SubCategoryCubit/subcategory_cubit.dart';
import 'package:breaking_project/business_logic/UserLocationsCubit/user_locations_cubit.dart';
import 'package:breaking_project/core/constants/app_constants.dart';
import 'package:breaking_project/data/models/banner_image_model.dart';
import 'package:breaking_project/data/repository/all_locations_repository.dart';
import 'package:breaking_project/data/repository/categories_tree_repository.dart';
import 'package:breaking_project/data/repository/home_repository.dart';
import 'package:breaking_project/data/repository/services_repository.dart';
import 'package:breaking_project/data/repository/subcategory_repository.dart';
import 'package:breaking_project/data/web_services/all_locations_webservice.dart';
import 'package:breaking_project/data/web_services/categories_tree_webservices.dart';
import 'package:breaking_project/data/web_services/home_webservices.dart';
import 'package:breaking_project/data/web_services/services_webservices.dart';
import 'package:breaking_project/data/web_services/subcategories_webservice.dart';
import 'package:breaking_project/presentation/screens/search.dart';
import 'package:breaking_project/presentation/screens/services_screen.dart';
import 'package:breaking_project/presentation/screens/subcategories.dart';
import 'package:breaking_project/presentation/screens/user_locations.dart';
import 'package:breaking_project/presentation/widgets/Items_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String current_location = 'دمشق-كفرسوسة';
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final PageController _controller = PageController();
  int currentPage = 0;
  late List<RBannerImageData> bannerimages;
  String? username;
  String? userlocation;
  final List<String> hints = ["صيانة", "تنظيف", "دهان"];
  int currentHintIndex = 0;
  Timer? hintTimer;

  //late List<RCategoryData> allitems;
  //late List<Services> searcheditems;
  bool isSearching = false;
  final searchTextController = TextEditingController();

  final List<String> images = [
    'assets/images/jpg/fourth.jpg',
    'assets/images/jpg/fifth.jpg',
    'assets/images/jpg/sixth.jpg',
  ];
  final ValueNotifier<int> currentPageNotifier = ValueNotifier<int>(0);

  void _updateLocation(String newLocation) {
    setState(() {
      current_location = newLocation;
    });
  }

  void _getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    var uname = prefs.getString('user_name');
    if (uname != null) {
      setState(() {
        username = uname;
      });
    }
    print('user name: $username');
  }

  void _getUserLocation() async {
    final prefs = await SharedPreferences.getInstance();
    var ulocation = prefs.getString('user_current_location');
    if (ulocation != null) {
      setState(() {
        userlocation = ulocation;
      });
    }
    print('user name: $username');
  }

  @override
  void initState() {
    hintTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        currentHintIndex = (currentHintIndex + 1) % hints.length;
      });
    });
    super.initState();
    BlocProvider.of<HomeCubit>(context).getBannerImages('any');

    //BlocProvider.of<AllcategoriesCubit>(context).getAllCategories();
    BlocProvider.of<CategoriesTreeCubit>(context).getCategoriesTree();
    _getUserName();
    _getUserLocation();

    Timer.periodic(
      Duration(seconds: 3),
      (timer) {
        if (_controller.hasClients) {
          if (currentPage < images.length - 1) {
            currentPage++;
            _controller.animateToPage(
              currentPage,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          } else {
            currentPage = 0;
            _controller.jumpToPage(currentPage);
          }
        }
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    searchTextController.dispose();
    currentPageNotifier.dispose();
    super.dispose();
  }

  void _showLocationBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        // هنا سنستخدم StatefulBuilder لتحديث حالة الـ sheet
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            // يمكننا تعريف متغير الحالة هنا
            String selectedAddress = 'Home'; // مثلاً، العنوان المحدد حالياً

            return Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // العنوان والزر
                    Text(
                      'اختر عنوانك',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Cairo"),
                    ),
                    Divider(),
                    //SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.add,
                                color: Colors.teal,
                              )),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'أضف عنوان جديد',
                              style: TextStyle(
                                  fontFamily: "Cairo",
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(),

                    // قائمة العناوين
                    RadioListTile<String>(
                      activeColor: Colors.teal,
                      title: Text(
                        'المنزل',
                        style: TextStyle(
                          fontFamily: "Cairo",
                        ),
                      ),
                      subtitle: Text('دمشق-كفرسوسة',
                          style: TextStyle(
                            fontFamily: "Cairo",
                          )),
                      value: 'Home',
                      groupValue: selectedAddress,
                      onChanged: (value) {
                        setState(() {
                          selectedAddress = value!;
                        });
                        // هنا يمكن تحديث الموقع في الواجهة الرئيسية
                      },
                    ),
                    RadioListTile<String>(
                      activeColor: Colors.teal,
                      title: Text('العمل',
                          style: TextStyle(
                            fontFamily: "Cairo",
                          )),
                      subtitle: Text('999, My office, Abudhabi',
                          style: TextStyle(
                            fontFamily: "Cairo",
                          )),
                      value: 'Work',
                      groupValue: selectedAddress,
                      onChanged: (value) {
                        setState(() {
                          selectedAddress = value!;
                        });
                        // هنا يمكن تحديث الموقع في الواجهة الرئيسية
                      },
                    ),
                    RadioListTile<String>(
                      activeColor: Colors.teal,
                      title: Text('المنزل',
                          style: TextStyle(
                            fontFamily: "Cairo",
                          )),
                      subtitle: Text('733, Jawhara, Dubai',
                          style: TextStyle(
                            fontFamily: "Cairo",
                          )),
                      value: 'Jawhara Home',
                      groupValue: selectedAddress,
                      onChanged: (value) {
                        setState(() {
                          selectedAddress = value!;
                        });
                        // هنا يمكن تحديث الموقع في الواجهة الرئيسية
                      },
                    ),

                    // نص التعديل
                    SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        // الانتقال إلى صفحة الإعدادات
                      },
                      child: Text(
                        'لتعديل عناوينك، يمكنك الذهاب إلى حسابي > العناوين',
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: "Cairo",
                            color: Colors.teal),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget CategoryCard(String imagePath, String title, void Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 0),
        child: Column(
          children: [
            Image.network(
              imagePath.replaceFirst('127.0.0.1', AppConstants.baseaddress),
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

  Widget PAdCard(String imagePath) {
    return Container(
      width: 100,
      height: 120,
      margin: const EdgeInsets.only(right: 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          "$imagePath",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
  // Widget porAdCard(String imagePath) {
  //   return Container(
  //     width: 100,
  //     margin: const EdgeInsets.only(right: 0),
  //     child: Column(
  //       children: [
  //         Image.asset(imagePath, height: 50),
  //         const SizedBox(height: 5),
  //         Text(
  //           title,
  //           textAlign: TextAlign.center,
  //           style: const TextStyle(
  //               fontSize: 12, fontFamily: "Cairo", fontWeight: FontWeight.bold),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xF6F6F6),
        key: scaffoldKey,
        // drawer: Container(
        //     width: 170,
        //     color: Colors.white,
        //     child: Padding(
        //       padding: const EdgeInsets.only(top: 16, left: 16),
        //       child: Column(
        //         children: [
        //           Padding(
        //             padding: const EdgeInsets.only(left: 70, bottom: 20),
        //             child: GestureDetector(
        //               onTap: () {
        //                 scaffoldKey.currentState!.closeDrawer();
        //               },
        //               child: CircleAvatar(
        //                 child: Icon(
        //                   Icons.list,
        //                   color: Colors.white,
        //                 ),
        //                 radius: 14,
        //                 backgroundColor: Colors.black,
        //               ),
        //             ),
        //           ),
        //           // Expanded(
        //           //   child: ListView.builder(
        //           //     itemCount: 10,
        //           //     itemBuilder: (context, index) {
        //           //       return Text(" item[$index]");
        //           //     },
        //           //   ),
        //           // )
        //           GestureDetector(
        //             onTap: () {
        //               scaffoldKey.currentState?.closeDrawer();

        //               Future.delayed(Duration(seconds: 1), () {
        //                 Get.toNamed('providers');
        //               });
        //             },
        //             child: Row(
        //               children: [
        //                 Icon(
        //                   Icons.person_3_outlined,
        //                   size: 22,
        //                 ),
        //                 SizedBox(
        //                   width: 5,
        //                 ),
        //                 Text(
        //                   "All Providers",
        //                   style: TextStyle(color: Colors.black, fontSize: 20),
        //                 ),
        //               ],
        //             ),
        //           ),
        //           Divider(),
        //           SizedBox(
        //             height: 4,
        //           ),
        //           GestureDetector(
        //             onTap: () {
        //               scaffoldKey.currentState?.closeDrawer();

        //               Future.delayed(Duration(seconds: 1), () {
        //                 // Get.toNamed('providers');
        // Get.to(() => BlocProvider(
        //       create: (context) => UserRequestsCubit(
        //           UserRequestsRepository(
        //               userRequestsWebservices:
        //                   UserRequestsWebservices())),
        //       child: UserRequests(),
        //     ));
        //               });
        //             },
        //             child: Row(
        //               children: [
        //                 Icon(
        //                   Icons.outbox_rounded,
        //                   size: 22,
        //                 ),
        //                 SizedBox(
        //                   width: 5,
        //                 ),
        //                 Text(
        //                   "My Requests",
        //                   style: TextStyle(color: Colors.black, fontSize: 20),
        //                 ),
        //               ],
        //             ),
        //           ),
        //           Divider(),
        //           SizedBox(
        //             height: 4,
        //           ),
        //           GestureDetector(
        //             onTap: () {
        //               scaffoldKey.currentState?.closeDrawer();

        //               Future.delayed(Duration(seconds: 1), () {
        //                 // Get.toNamed('providers');
        //                 // Get.to(() => BlocProvider(
        //                 //       create: (context) => UserRequestsCubit(
        //                 //           UserRequestsRepository(
        //                 //               userRequestsWebservices:
        //                 //                   UserRequestsWebservices())),
        //                 //       child: UserRequests(),
        //                 //     ));
        //               });
        //             },
        //             child: Row(
        //               children: [
        //                 Icon(
        //                   Icons.settings,
        //                   size: 22,
        //                 ),
        //                 SizedBox(
        //                   width: 5,
        //                 ),
        //                 Text(
        //                   "Settings",
        //                   style: TextStyle(color: Colors.black, fontSize: 20),
        //                 ),
        //               ],
        //             ),
        //           ),
        //           Divider(),
        //           SizedBox(
        //             height: 4,
        //           ),
        //           GestureDetector(
        //             onTap: () {
        //               scaffoldKey.currentState?.closeDrawer();

        //               Future.delayed(Duration(seconds: 1), () {
        //                 //  Get.to(WalletPage());
        //                 // Get.toNamed('providers');
        //                 Get.to(
        //                   () => BlocProvider(
        //                     create: (_) => ProfileCubit(
        //                         ProfileRepository(ProfileWebservices())),
        //                     child: WalletPage(),
        //                   ),
        //                 );
        //               });
        //             },
        //             child: Row(
        //               children: [
        //                 Icon(
        //                   Icons.wallet,
        //                   size: 22,
        //                 ),
        //                 SizedBox(
        //                   width: 5,
        //                 ),
        //                 Text(
        //                   "My Wallet",
        //                   style: TextStyle(color: Colors.black, fontSize: 20),
        //                 ),
        //               ],
        //             ),
        //           ),
        //           Divider(),
        //           SizedBox(
        //             height: 4,
        //           ),
        //           GestureDetector(
        //             onTap: () {
        //               scaffoldKey.currentState?.closeDrawer();

        //               Future.delayed(Duration(seconds: 1), () {
        //                 Get.to(() => BlocProvider(
        //                       create: (context) => AllbanksCubit(BanksRepository(
        //                           bankWebservices: BankWebservices())),
        //                       child: BanksScreen(),
        //                     ));
        //               });
        //             },
        //             child: Row(
        //               children: [
        //                 Icon(
        //                   Icons.monetization_on,
        //                   size: 22,
        //                 ),
        //                 SizedBox(
        //                   width: 5,
        //                 ),
        //                 Text(
        //                   "Available Banks",
        //                   style: TextStyle(color: Colors.black, fontSize: 20),
        //                 ),
        //               ],
        //             ),
        //           ),
        //         ],
        //       ),
        //     )),
        body: SingleChildScrollView(
            child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: double
                        .infinity, // لجعل العرض يملأ المساحة الأفقية بالكامل
                    height: 250, // تحديد ارتفاع ثابت
                    child: Image.asset(
                      "assets/images/jpg/tealbg.jpg",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 50, left: 16, right: 16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                                height: 30,
                                width: 30,
                                child: Image.asset(
                                    "assets/images/png/waving2.png")),
                            Text(
                              "مرحباً ,",
                              style: TextStyle(
                                  fontFamily: "Cairo",
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              username.isNull ? "user" : "$username",
                              style: TextStyle(
                                  fontFamily: "Cairo",
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            _showLocationBottomSheet(context);
                          },
                          child: GestureDetector(
                            onTap: () {
                              //                  Get.to(
                              //   () => BlocProvider(
                              //     create: (_) => UserLocationsCubit(AllLocationsRepository(
                              //         allLocationsWebservice: AllLocationsWebservice())),
                              //     child: UserLocationsScreen(id: userdata.id!),
                              //   ),
                              // );
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_pin,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    userlocation.isNull
                                        ? "دمشق"
                                        : "$userlocation",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Cairo"),
                                  ),
                                ),
                                Icon(
                                  Icons.expand_more,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        SizedBox(
                          //width: 320.w,
                          height: 40.h,
                          child: GestureDetector(
                            onTap: () {
                              Get.to(
                                () => MultiBlocProvider(
                                  providers: [
                                    BlocProvider(
                                      create: (context) => CategoriesTreeCubit(
                                          CategoriesTreeRepository(
                                              categoriesTreeWebservices:
                                                  CategoriesTreeWebservices())),
                                    ),
                                    BlocProvider(
                                      create: (context) => HomeCubit(
                                          HomeRepository(
                                              homeWebservices:
                                                  HomeWebservices())),
                                    ),
                                  ],
                                  child: const SearchScreen(),
                                ),
                              );
                            },
                            child: TextFormField(
                              enabled: false,
                              cursorWidth: 0.8,
                              style: const TextStyle(fontSize: 16),
                              decoration: InputDecoration(
                                hintText:
                                    'ابحث عن "${hints[currentHintIndex]}"',
                                hintStyle: TextStyle(
                                    fontFamily: "Cairo",
                                    fontSize: 14,
                                    color: Colors.grey),
                                border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 0.8),
                                ),
                                disabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 0.8),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 0.8),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 0.8),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "بدأ الصيف و بدأت معه العروض",
                                  style: TextStyle(
                                      fontFamily: "Cairo",
                                      color: Colors.red,
                                      //fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                                Text(
                                  "تنظيف المكيفات ب 50.000",
                                  style: TextStyle(
                                      fontFamily: "Cairo",
                                      color: Colors.black,
                                      // fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                Text(
                                  "والمزيد من العروض بانتظارك >",
                                  style: TextStyle(
                                      fontFamily: "Cairo",
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(top: 32),
                              child: SizedBox(
                                  height: 35,
                                  width: 35,
                                  child: Image.asset(
                                      "assets/images/png/discount.png")),
                            ),
                            SizedBox(
                                height: 70,
                                width: 70,
                                child:
                                    Image.asset("assets/images/png/ac2.png")),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.white,
                  ),
                  Column(
                    children: [
                      BlocBuilder<HomeCubit, HomeStates>(
                        builder: (context, state) {
                          if (state is BannerImagesSuccess) {
                            bannerimages = (state).bannerimages;

                            print(bannerimages.toString());
                            return Container(
                              height: 150,
                              width: 340,
                              child: PageView.builder(
                                controller: _controller,
                                itemCount: context
                                    .read<HomeCubit>()
                                    .bannerimages
                                    .length,
                                onPageChanged: (index) {
                                  currentPageNotifier.value = index;
                                },
                                itemBuilder: (context, index) {
                                  return // ... داخل itemBuilder
                                      Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          8.0), // يمكنك تعديل القيمة حسب الحاجة
                                      child: Image.network(
                                        bannerimages[index]
                                            .image!
                                            .replaceFirst('127.0.0.1',
                                                AppConstants.baseaddress)
                                            .replaceFirst(
                                                "banner", "banner$index"),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          } else {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                width: double.infinity,
                                height: 220,
                                color: Colors.white,
                              ),
                            );
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Center(
                          child: ValueListenableBuilder<int>(
                            valueListenable: currentPageNotifier,
                            builder: (context, value, child) {
                              return SmoothPageIndicator(
                                controller: _controller,
                                count: images.length,
                                effect: const WormEffect(
                                  activeDotColor: Colors.teal,
                                  dotColor: Colors.grey,
                                  dotHeight: 6,
                                  dotWidth: 6,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              BlocBuilder<CategoriesTreeCubit, CategoriesTreeStates>(
                builder: (context, state) {
                  if (state is CategoriesTreeLoaded) {
                    return Container(
                      height: 90,
                      color: Colors.white,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: ListView.builder(
                            itemCount: state.categoriesTree.length,
                            itemBuilder: (context, index) {
                              String type = state
                                          .categoriesTree[index].displayName ==
                                      "أدوات سباكة"
                                  ? "plumbing"
                                  : state.categoriesTree[index].displayName ==
                                          "أدوات يدوية"
                                      ? "handy"
                                      : state.categoriesTree[index]
                                                  .displayName ==
                                              "أدوات منزلية"
                                          ? "home"
                                          : state.categoriesTree[index]
                                                      .displayName ==
                                                  "أدوات كهربائية"
                                              ? "electricity"
                                              : state.categoriesTree[index]
                                                          .displayName ==
                                                      "أثاث"
                                                  ? "furniture"
                                                  : "";
                              return CategoryCard(
                                "http://127.0.0.1:8000/storage/images/defaults/$type.png",
                                state.categoriesTree[index].displayName!,
                                () {
                                  Get.to(
                                    () => BlocProvider(
                                      create: (context) => SubcategoryCubit(
                                          SubcategoryRepository(
                                              subcategoriesWebservice:
                                                  SubcategoriesWebservice())),
                                      child: Subcategories(
                                        id: state.categoriesTree[index].id
                                            .toString(),
                                        catname: state
                                            .categoriesTree[index].displayName
                                            .toString(),
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
              SizedBox(
                height: 16.h,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: 240,
                    color: Colors.white,
                  ),
                  Column(
                    children: [
                      BlocBuilder<HomeCubit, HomeStates>(
                        builder: (context, state) {
                          if (state is BannerImagesSuccess) {
                            //print("this is your image path");
                            bannerimages = (state).bannerimages;
                            // var thisimage = bannerimages[0].image!.replaceFirst(
                            //     '127.0.0.1', AppConstants.baseaddress);
                            print(bannerimages.toString());
                            return Container(
                              height: 250.h,
                              width: 340.w,
                              child: SizedBox(
                                  height: 200, // بتحدد ارتفاع الليست نفسها
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, bottom: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8),
                                          child: Text(
                                            "مختارات لأجلك !",
                                            style: TextStyle(
                                                fontFamily: "Cairo",
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        SizedBox(
                                          height: 150, // هنا تم تحديد الارتفاع
                                          child: ListView(
                                            scrollDirection: Axis.horizontal,
                                            children: [
                                              PAdCard(
                                                  "assets/images/jpg/pad2.jpg"),
                                              SizedBox(
                                                width: 16.w,
                                              ),
                                              PAdCard(
                                                  "assets/images/jpg/pad1.jpg"),
                                              SizedBox(
                                                width: 16.w,
                                              ),
                                              PAdCard(
                                                  "assets/images/jpg/pa3.jpg"),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            );
                          } else {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                width: 340.w,
                                height: 150.h,
                                color: Colors.white,
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  )
                ],
              ),
              builCategoriesTreeWidget(),
            ],
          ),
        )));
  }

  Widget buildBlocWidget() {
    return BlocBuilder<AllcategoriesCubit, AllcategoriesStates>(
        builder: (context, state) {
      if (state is AllcategoriesLoaded) {
        print("34434343434");
        //allitems = (state).categories;
        //print(allitems);
        return buildLoadedListWidget();
      } else {
        print("999999999");
        return buildCategoriesShimmer();
      }
    });
  }

  Widget builCategoriesTreeWidget() {
    return BlocBuilder<CategoriesTreeCubit, CategoriesTreeStates>(
      builder: (context, state) {
        if (state is CategoriesTreeLoaded) {
          return ListView.builder(
            shrinkWrap: true,
            physics:
                const NeverScrollableScrollPhysics(), // لأنه أصلاً عندك SingleChildScrollView
            //padding: const EdgeInsets.all(16),
            itemCount: state.categoriesTree.length,
            itemBuilder: (context, index) {
              final category = state.categoriesTree[index];

              // نعرض فقط الكاتيجوري اللي عنده Subcategories
              if (category.subcategories == null ||
                  category.subcategories!.isEmpty) {
                return const SizedBox.shrink();
              }

              return Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // عنوان الكاتيجوري
                      Padding(
                        padding: const EdgeInsets.only(right: 16, top: 8),
                        child: Text(category.displayName ?? "",
                            style: TextStyle(
                                fontFamily: "Cairo",
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      ),

                      SizedBox(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: category.subcategories?.length ?? 0,
                          itemBuilder: (context, subIndex) {
                            final sub = category.subcategories![subIndex];
                            return GestureDetector(
                              onTap: () {
                                Get.to(() => BlocProvider(
                                      create: (context) => ServiceCubit(
                                          ServiceRepository(
                                              serviceWebservices:
                                                  ServiceWebservices())),
                                      child: ServicesScreen(
                                        id: sub.id!,
                                        subname: sub.displayName!,
                                        videourl: "assets/videos/plumbing.mp4",
                                      ),
                                    ));
                              },
                              child: Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    Container(
                                      width: 150,
                                      height: 130,
                                      margin: const EdgeInsets.only(right: 12),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        child: Image.asset(
                                          "assets/images/jpg/worker0.jpg",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 20.w,
                                      bottom: 8.h,
                                      child: Text(sub.displayName ?? "",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: "Cairo",
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold)),
                                    )
                                  ]),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 16),
                      Center(
                        child: Dash(
                          direction: Axis.horizontal,
                          length: 320.w,
                          dashLength: 2,
                          dashColor: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return buildCategoriesShimmer();
        }
      },
    );
  }

  Widget buildCategoriesShimmer() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.9,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
      ),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      },
    );
  }

  Widget buildLoadedListWidget() {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            builditemsList(),
          ],
        ),
      ),
    );
  }

  Widget showloadingindicator() {
    return const Center(
        child: CircularProgressIndicator(
      color: Colors.teal,
    ));
  }

  Widget builditemsList() {
    print("the lengthhhhh isssss");
    print(context.read<AllcategoriesCubit>().categories.length);
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.9,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1,
        ),
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: context.read<AllcategoriesCubit>().categories.length > 6
            ? 6
            : context.read<AllcategoriesCubit>().categories.length,
        itemBuilder: (ctx, index) {
          return ItemWidget(
              item: context.read<AllcategoriesCubit>().categories[index]);
        });
  }
}
