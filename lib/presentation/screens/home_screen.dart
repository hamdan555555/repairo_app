import 'dart:async';
import 'package:breaking_project/business_logic/AllBanksCubit/all_banks_cubit.dart';
import 'package:breaking_project/business_logic/AllCategoriesCubit/allcategories_states.dart';
import 'package:breaking_project/business_logic/AllCategoriesCubit/allcaterories_cubit.dart';
import 'package:breaking_project/business_logic/HomeCubit/home_cubit.dart';
import 'package:breaking_project/business_logic/HomeCubit/home_states.dart';
import 'package:breaking_project/business_logic/UserRequestsCubit/user_requests_cubit.dart';
import 'package:breaking_project/core/constants/app_constants.dart';
import 'package:breaking_project/data/models/banner_image_model.dart';
import 'package:breaking_project/data/models/user_requests_model.dart';
import 'package:breaking_project/data/repository/bank_repository.dart';
import 'package:breaking_project/data/repository/user_requests_repository.dart';
import 'package:breaking_project/data/web_services/banks_webservices.dart';
import 'package:breaking_project/data/web_services/user_requests_webservices.dart';
import 'package:breaking_project/presentation/screens/banks.dart';
import 'package:breaking_project/presentation/screens/user_requests.dart';
import 'package:breaking_project/presentation/screens/wallet.dart';
import 'package:breaking_project/presentation/widgets/Items_widget.dart';
import 'package:breaking_project/presentation/widgets/service_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final PageController _controller = PageController();
  int currentPage = 0;
  late List<RBannerImageData> bannerimages;

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

  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomeCubit>(context).getBannerImages('any');
    BlocProvider.of<AllcategoriesCubit>(context).getAllCategories();

    Timer.periodic(
      Duration(seconds: 3),
      (timer) {
        if (_controller.hasClients) {
          if (currentPage < images.length - 1) {
            currentPage++;
          } else {
            currentPage = 0;
          }

          _controller.animateToPage(currentPage,
              duration: Duration(microseconds: 500), curve: Curves.easeInOut);
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

  @override
  Widget build(BuildContext context) {
    print("builllllld in home starteddddddd");

    return Scaffold(
      key: scaffoldKey,
      drawer: Container(
          width: 170,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(top: 16, left: 16),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 70, bottom: 20),
                  child: GestureDetector(
                    onTap: () {
                      scaffoldKey.currentState!.closeDrawer();
                    },
                    child: CircleAvatar(
                      child: Icon(
                        Icons.list,
                        color: Colors.white,
                      ),
                      radius: 14,
                      backgroundColor: Colors.black,
                    ),
                  ),
                ),
                // Expanded(
                //   child: ListView.builder(
                //     itemCount: 10,
                //     itemBuilder: (context, index) {
                //       return Text(" item[$index]");
                //     },
                //   ),
                // )
                GestureDetector(
                  onTap: () {
                    scaffoldKey.currentState?.closeDrawer();

                    Future.delayed(Duration(seconds: 1), () {
                      Get.toNamed('providers');
                    });
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.person_3_outlined,
                        size: 22,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "All Providers",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Divider(),
                SizedBox(
                  height: 4,
                ),
                GestureDetector(
                  onTap: () {
                    scaffoldKey.currentState?.closeDrawer();

                    Future.delayed(Duration(seconds: 1), () {
                      // Get.toNamed('providers');
                      Get.to(() => BlocProvider(
                            create: (context) => UserRequestsCubit(
                                UserRequestsRepository(
                                    userRequestsWebservices:
                                        UserRequestsWebservices())),
                            child: UserRequests(),
                          ));
                    });
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.outbox_rounded,
                        size: 22,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "My Requests",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Divider(),
                SizedBox(
                  height: 4,
                ),
                GestureDetector(
                  onTap: () {
                    scaffoldKey.currentState?.closeDrawer();

                    Future.delayed(Duration(seconds: 1), () {
                      // Get.toNamed('providers');
                      // Get.to(() => BlocProvider(
                      //       create: (context) => UserRequestsCubit(
                      //           UserRequestsRepository(
                      //               userRequestsWebservices:
                      //                   UserRequestsWebservices())),
                      //       child: UserRequests(),
                      //     ));
                    });
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.settings,
                        size: 22,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Settings",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Divider(),
                SizedBox(
                  height: 4,
                ),
                GestureDetector(
                  onTap: () {
                    scaffoldKey.currentState?.closeDrawer();

                    Future.delayed(Duration(seconds: 1), () {
                      Get.to(WalletPage());
                      // Get.toNamed('providers');
                      // Get.to(() => BlocProvider(
                      //       create: (context) => UserRequestsCubit(
                      //           UserRequestsRepository(
                      //               userRequestsWebservices:
                      //                   UserRequestsWebservices())),
                      //       child: UserRequests(),
                      //     ));
                    });
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.wallet,
                        size: 22,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "My Wallet",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Divider(),
                SizedBox(
                  height: 4,
                ),
                GestureDetector(
                  onTap: () {
                    scaffoldKey.currentState?.closeDrawer();

                    Future.delayed(Duration(seconds: 1), () {
                      Get.to(() => BlocProvider(
                            create: (context) => AllbanksCubit(BanksRepository(
                                bankWebservices: BankWebservices())),
                            child: BanksScreen(),
                          ));
                    });
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.monetization_on,
                        size: 22,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Available Banks",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(children: [
              Column(
                children: [
                  Stack(
                    children: [
                      BlocBuilder<HomeCubit, HomeStates>(
                        builder: (context, state) {
                          if (state is BannerImagesSuccess) {
                            print("this is your image path");
                            bannerimages = (state).bannerimages;
                            var thisimage = bannerimages[0].image!.replaceFirst(
                                '127.0.0.1', AppConstants.baseaddress);
                            print(thisimage.toString());
                            return SizedBox(
                              height: 220,
                              child: PageView.builder(
                                controller: _controller,
                                itemCount: context
                                    .read<HomeCubit>()
                                    .bannerimages
                                    .length,
                                //images.length,
                                onPageChanged: (index) {
                                  currentPageNotifier.value = index;
                                },
                                itemBuilder: (context, index) {
                                  return ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(0),
                                      bottomRight: Radius.circular(0),
                                    ),
                                    child: Image.network(
                                      // 'http://172.20.10.5:8000/storage/images/defaults/banner.png'
                                      bannerimages[index].image!.replaceFirst(
                                          '127.0.0.1',
                                          AppConstants.baseaddress),
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      height: 200,
                                    ),

                                    //  Image.asset(
                                    //   images[index],
                                    //   fit: BoxFit.cover,
                                    //   width: double.infinity,
                                    // ),
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
                      Positioned(
                        bottom: 36,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: ValueListenableBuilder<int>(
                            valueListenable: currentPageNotifier,
                            builder: (context, value, child) {
                              return SmoothPageIndicator(
                                controller: _controller,
                                count: images.length,
                                effect: const WormEffect(
                                  activeDotColor: Colors.white,
                                  dotColor: Colors.white54,
                                  dotHeight: 8,
                                  dotWidth: 8,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Positioned(
                          top: 50,
                          left: 300,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              Get.to(() => BlocProvider(
                                    create: (context) => UserRequestsCubit(
                                        UserRequestsRepository(
                                            userRequestsWebservices:
                                                UserRequestsWebservices())),
                                    child: UserRequests(),
                                  ));
                            },
                            child: CircleAvatar(
                              child: SvgPicture.asset(
                                  'assets/images/svg/Notification.svg'),
                              radius: 18,
                              backgroundColor: Colors.white,
                            ),
                          )),
                      Positioned(
                          top: 50,
                          left: 0,
                          right: 300,
                          child: GestureDetector(
                            onTap: () {
                              scaffoldKey.currentState!.openDrawer();
                            },
                            child: CircleAvatar(
                              child: Icon(Icons.list),
                              radius: 18,
                              backgroundColor: Colors.white,
                            ),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Text(
                          "Categories",
                          style: TextStyle(
                            fontSize: 22,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 180),
                          child: GestureDetector(
                              onTap: () {
                                Get.toNamed('allcategories');
                              },
                              child: Text("View All")),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  buildBlocWidget(),
                  Container(
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 226, 222, 222)),
                    height: 360,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 20, left: 8, right: 8, bottom: 20),
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              Text(
                                "Pobular Now",
                                style: TextStyle(
                                  fontSize: 22,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 150),
                                child: GestureDetector(child: Text("View All")),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Expanded(
                          child: ListView.separated(
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                width: 12,
                              );
                            },
                            itemBuilder: (context, index) {
                              return ServiceWidget();
                            },
                            itemCount: 2,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                          ),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 195,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 270,
                        height: 50,
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'type to start searching',
                            hintStyle: const TextStyle(fontSize: 14),
                            filled: true,
                            fillColor: const Color.fromARGB(255, 242, 244, 245),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 16.0, horizontal: 20.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6.0),
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 242, 244, 245),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(color: Colors.black)),
                        child: Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
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

      // Widget buildBlocWidget() {
      //   return BlocBuilder<AllcategoriesCubit, AllcategoriesStates>(
      //       builder: (context, state) {
      //     if (state is AllcategoriesLoaded) {
      //       return buildLoadedListWidget();
      //     } else {
      //       return buildCategoriesShimmer(); // <-- بدّل هون
      //     }
      //   });
      // }
    });
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
      color: const Color.fromRGBO(95, 96, 185, 1),
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
