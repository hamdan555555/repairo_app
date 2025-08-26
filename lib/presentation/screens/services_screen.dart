import 'package:breaking_project/business_logic/ServiceCubit/service_cubit.dart';
import 'package:breaking_project/business_logic/ServiceCubit/service_states.dart';
import 'package:breaking_project/core/constants/app_constants.dart';
import 'package:breaking_project/data/models/service_model.dart';
import 'package:breaking_project/presentation/screens/schedule_screen.dart';
import 'package:breaking_project/presentation/screens/suggested_services_screen.dart';
import 'package:breaking_project/presentation/widgets/cart_bottomsheet_widget.dart';
import 'package:breaking_project/presentation/widgets/cart_item_widget.dart';
import 'package:breaking_project/presentation/widgets/services_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:video_player/video_player.dart';

class ServicesScreen extends StatefulWidget {
  final String videourl;
  final String id;
  final String subname;
  ServicesScreen(
      {Key? key,
      required this.id,
      required this.videourl,
      required this.subname})
      : super(key: key);
  @override
  State<ServicesScreen> createState() => ServicesScreenStatee();
}

class ServicesScreenStatee extends State<ServicesScreen> {
  final cart = Cart();
  List<String> selectedServices = [];
  late VideoPlayerController videoPlayerController;
  final GlobalKey _section1Key = GlobalKey();
  late List<RServiceData> services;
  final searchTextController = TextEditingController();
  late String subcategoryname;
  late String id;
  bool isInitialized = false;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController =
      ScrollOffsetController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final ScrollOffsetListener scrollOffsetListener =
      ScrollOffsetListener.create();

  late List<RServiceData> servicess;

  void toggleServiceSelection(String service, bool selected) {
    setState(() {
      if (selected) {
        selectedServices.add(service);
      } else {
        selectedServices.remove(service);
      }
    });
  }

  // void _showCart() {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (context) {
  //       return CartBottomSheet(cart: cart);
  //     },
  //   );
  // }

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
        alignment:
            0.1, // يمكنك تعديل هذا لتحديد موضع العنصر في الشاشة (0.0 = الأعلى)
      );
    }
  }

  void showCartBottomSheet(BuildContext context, Cart cart) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            // الشرط الرئيسي: إذا كانت السلة فارغة، قم بإخفاء الـ sheet
            if (cart.isEmpty) {
              Navigator.of(context).pop();
              return Container(); // ارجع حاوية فارغة
            }

            return Directionality(
              textDirection: TextDirection.rtl,
              child: DraggableScrollableSheet(
                initialChildSize: 0.2,
                minChildSize: 0.1,
                //maxChildSize: 0.8,
                expand: false,
                builder: (context, scrollController) {
                  return Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(25.0)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "المجموع: ${cart.total.toStringAsFixed(2)} ليرة",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Cairo"),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Get.to(SuggestedServicesScreen(
                                //     cart: cart, suggestion_list: servicess));
                                Get.to(SchedulePage(cart: cart));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.teal,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16))),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 16.0, horizontal: 24),
                                  child: Text(
                                    "التالي",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Cairo",
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: cart.items.length,
                            itemBuilder: (context, index) {
                              final item = cart.items[index];
                              return ListTile(
                                title: Text(
                                  item.service.name!,
                                  style: TextStyle(fontFamily: "Cairo"),
                                ),
                                subtitle: Text(
                                  "x${item.quantity}",
                                  style: TextStyle(fontFamily: "Cairo"),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.remove_circle_outline),
                                      onPressed: () {
                                        // قم بإنقاص الكمية هنا
                                        cart.decrement(item.service);
                                        // ثم قم بتحديث الـ state
                                        setState(() {});
                                      },
                                    ),
                                    Text("${item.quantity}"),
                                    IconButton(
                                      icon: Icon(Icons.add_circle_outline),
                                      onPressed: () {
                                        // قم بزيادة الكمية هنا
                                        cart.add(item.service);
                                        // ثم قم بتحديث الـ state
                                        setState(() {});
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ServiceCubit>(context).getServices(widget.id);
    videoPlayerController = VideoPlayerController.asset(
      widget.videourl,
    )..initialize().then((_) {
        setState(() {});
        // videoPlayerController.setLooping(true);
        videoPlayerController.play();
      });

    // videoPlayerController = VideoPlayerController.network(widget.videourl)
    //   ..initialize().then((_) {
    //     setState(() {});
    //     videoPlayerController.play();
    //   });

    videoPlayerController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress = 0.0;
    if (videoPlayerController.value.isInitialized) {
      progress = videoPlayerController.value.position.inMilliseconds /
          videoPlayerController.value.duration.inMilliseconds;
    }
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          body: videoPlayerController.value.isInitialized
              ? BlocBuilder<ServiceCubit, ServiceStates>(
                  builder: (context, state) {
                    if (state is ServiceLoaded) {
                      servicess = context.read<ServiceCubit>().services;
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                AspectRatio(
                                  aspectRatio:
                                      videoPlayerController.value.aspectRatio,
                                  child: VideoPlayer(videoPlayerController),
                                ),
                                Positioned(
                                  bottom: 10,
                                  left: 10,
                                  right: 10,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: LinearProgressIndicator(
                                      value: progress,
                                      minHeight: 4,
                                      backgroundColor: Colors.white30,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.teal),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 140,
                                  left: 320,
                                  right: 10,
                                  child: GestureDetector(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: CircleAvatar(
                                        radius: 14,
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          Icons.arrow_back_ios_new_sharp,
                                          size: 16,
                                          color: Colors.black,
                                        )),
                                  ),
                                ),
                                Positioned(
                                  bottom: 140,
                                  left: 10,
                                  right: 290,
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          _scrollToSection(_section1Key);
                                        },
                                        child: CircleAvatar(
                                          radius: 14,
                                          backgroundColor: Colors.white,
                                          child: LineIcon(
                                            Icons.search,
                                            size: 16,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 4.w,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          // itemScrollController.jumpTo(index: 4);
                                          // Get.to(SchedulePage(cart: cart));
                                        },
                                        child: CircleAvatar(
                                            radius: 14,
                                            backgroundColor: Colors.white,
                                            child: LineIcon(
                                              Icons.favorite_border_rounded,
                                              size: 16,
                                              color: Colors.black,
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "الخطوة 1 من 4 ",
                                    style: TextStyle(
                                        fontFamily: "Cairo",
                                        fontSize: 14,
                                        color: Colors.grey),
                                  ),
                                  Text(
                                    widget.subname,
                                    style: TextStyle(
                                        fontFamily: "Cairo",
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: [
                                      LineIcon(
                                        Icons.star_rounded,
                                        color: Colors.amber,
                                      ),
                                      Text(
                                        "4.8  ( 9,321 حجوزات )",
                                        style: TextStyle(
                                          fontFamily: "Cairo",
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Divider(),
                            builditemsGrid(),
                            Divider(),
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 8, top: 4, bottom: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "عرض حصري لأجلك !",
                                    style: TextStyle(
                                      fontFamily: "Cairo",
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 12.h,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 100),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                          border: Border.all(
                                            color: Colors.grey,
                                            width: 0.3,
                                          )),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                LineIcon(
                                                  Icons.local_offer_outlined,
                                                  size: 14,
                                                ),
                                                SizedBox(
                                                  width: 8.w,
                                                ),
                                                Text(
                                                  "خصم 20.000 ",
                                                  style: TextStyle(
                                                      fontFamily: "Cairo"),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10.h,
                                            ),
                                            Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 4),
                                                  child: Text(
                                                    "الكود :  100REP",
                                                    style: TextStyle(
                                                        fontFamily: "Cairo",
                                                        fontSize: 14,
                                                        color: Colors.grey),
                                                  ),
                                                ),
                                                Spacer(),
                                                GestureDetector(
                                                  onTap: () {},
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 4),
                                                    child: Container(
                                                      width: 50.w,
                                                      height: 25,
                                                      decoration: BoxDecoration(
                                                          color: Colors.teal,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          5))),
                                                      child: Center(
                                                        child: Text(
                                                          "تطبيق",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontFamily:
                                                                  "Cairo",
                                                              fontSize: 13,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    color: Colors.grey.shade300,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "خدمات ${widget.subname}",
                                        style: TextStyle(
                                          fontFamily: "Cairo",
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Container(
                                key: _section1Key,
                                height: 140.h,
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  child: Image.asset(
                                    "assets/images/jpg/servicebanner.jpg",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Divider(),
                            //Container(color: Colors.white10, child: buildBlocWidget()),
                            builditemsListt(),
                            Container(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      showCartBottomSheet(context, cart);
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "المجموع: 1200 ليرة",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Cairo"),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "المجموع: ${cart.total.toStringAsFixed(2)} ليرة",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "Cairo"),
                                            ),
                                            SizedBox(
                                              width: 5.w,
                                            ),
                                            Icon(Icons
                                                .keyboard_arrow_up_rounded),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      // Get.to(SuggestedServicesScreen(
                                      //     cart: cart,
                                      //     suggestion_list: servicess));
                                      Get.to(SchedulePage(cart: cart));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.teal,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(16))),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16.0, horizontal: 24),
                                        child: Text(
                                          "التالي",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Cairo",
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.teal,
                        ),
                      );
                    }
                  },
                )
              : Center(
                  child: CircularProgressIndicator(),
                )),
    );
  }

  Widget buildBlocWidget() {
    return buildLoadedGridWidget();
  }

  Widget buildLoadedGridWidget() {
    return builditemsGrid();
  }

  Widget showloadingindicator() {
    return const Center(
        child: CircularProgressIndicator(
      color: Colors.teal,
    ));
  }

  // Widget builditemsList() {
  //   final services = context.read<ServiceCubit>().services;

  //   return ListView.builder(
  //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

  //     itemCount: services.length,
  //     shrinkWrap: true,

  //     //    physics:  NeverScrollableScrollPhysics(), // حتى ما تتعارض مع ScrollView خارجي
  //     itemBuilder: (ctx, index) {
  //       return Padding(
  //         padding: const EdgeInsets.only(bottom: 12.0),
  //         child: ServicesWidget(
  //           onToggle: (serviceId, selected) {},
  //           indexx: index,
  //           services: services[index],
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget builditemsListt() {
    final services = context.read<ServiceCubit>().services;
    return ScrollablePositionedList.builder(
      itemScrollController: itemScrollController,
      scrollOffsetController: scrollOffsetController,
      itemPositionsListener: itemPositionsListener,
      scrollOffsetListener: scrollOffsetListener,
      padding: EdgeInsets.all(8),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return Container(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // صورة الخدمة
                  Container(
                    width: 70,
                    height: 70,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        service.image!
                            .replaceFirst(services[index].image!.toString(),
                                "http://127.0.0.1:8000/storage/images/defaults/service.png")
                            .replaceFirst(
                                '127.0.0.1', AppConstants.baseaddress),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),

                  // النصوص
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service.displayName!,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Cairo"),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "خدمة جديدة تستطيع تلبية احتياجات المستخدمين اللذين يرغبون بالاستفادة من الخدمات الموجودة على النظام ومن ثم استخدامها",
                          style: TextStyle(
                              fontFamily: "Cairo",
                              fontSize: 13,
                              color: Colors.grey[700]),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              "${service.pricee} ليرة",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Cairo",
                                color: Colors.teal,
                              ),
                            ),
                            Spacer(),
                            !cart.contains(service)
                                ? GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        cart.add(service);
                                      });
                                      showCartBottomSheet(context, cart);

                                      // if (cart.items.isNotEmpty) {
                                      //   _showCart();
                                      // }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 4),
                                      child: Container(
                                        // width: 50.w,
                                        // height: 35,
                                        decoration: BoxDecoration(
                                            color: Colors.teal,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  "أضف",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: "Cairo",
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                LineIcon(
                                                  Icons.add,
                                                  color: Colors.white,
                                                  size: 16,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  cart.decrement(service);
                                                });
                                                showCartBottomSheet(
                                                    context, cart);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 0.5,
                                                        color: Colors.grey),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30)),
                                                child: Icon(
                                                  Icons.remove,
                                                  color: Colors.teal,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4),
                                              child: Text(
                                                "${cart.getQuantity(service)}",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontFamily: "Cairo",
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  cart.add(service);
                                                });
                                                showCartBottomSheet(
                                                    context, cart);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 0.5,
                                                        color: Colors.grey),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30)),
                                                child: Icon(
                                                  Icons.add,
                                                  color: Colors.teal,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                          ],
                        ),
                      ],
                    ),
                  ),

                  // ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //     shape: StadiumBorder(),
                  //     padding: EdgeInsets.symmetric(
                  //         horizontal: 16, vertical: 8),
                  //   ),
                  //   onPressed: () {
                  //     setState(() {
                  //       cart.add(service);
                  //     });
                  //     if (cart.items.isNotEmpty) {
                  //       _showCart();
                  //     }
                  //   },
                  //   child: Text("أضف"),
                  // ),
                ],
              ),
              Divider(),
            ],
          ),
        );

        //  Container(
        //   margin: EdgeInsets.all(0),
        //   child: ListTile(
        //     leading: Column(
        //       children: [
        //         Container(
        //           width: 100,
        //           height: 100,
        //           child: ClipRRect(
        //             borderRadius: BorderRadius.all(Radius.circular(10)),
        //             child: Image.network(
        //               service.image!
        // .replaceFirst(services[index].image!.toString(),
        //     "http://127.0.0.1:8000/storage/images/defaults/service.png")
        // .replaceFirst(
        //     '127.0.0.1', AppConstants.baseaddress),
        //               fit: BoxFit.cover,
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //     title: Text(service.displayName!),
        // subtitle: Text(
        //     "خدمة جديدة تستطيع تلبية احتياجات المستخدمين اللذين يرغبون بالاستفادة من الخدمات الموجودة على النظام ومن ثم استخدامها"),
        //     trailing: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         Text("${service.minPrice} درهم"),
        //         SizedBox(height: 8),
        //         ElevatedButton(
        //           onPressed: () {
        // setState(() {
        //   cart.add(service);
        // });
        // if (cart.items.isNotEmpty) {
        //   _showCart();
        // }
        //           },
        //           child: Text("أضف"),
        //         ),
        //       ],
        //     ),
        //   ),
        // );
      },
    );
  }

  Widget builditemsGrid() {
    final services = context.read<ServiceCubit>().services;
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(top: 8, right: 8, left: 8),
      itemCount: services.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 2,
        childAspectRatio: 0.75, // يمكن تعديل هذه القيمة حسب الحاجة
      ),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            print("///////////////////////////////////");
            // itemscrollController.scrollTo(
            //     index: index, duration: Duration(seconds: 1));
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  child: Image.network(
                    services[index]
                        .image!
                        .replaceFirst(services[index].image!.toString(),
                            "http://127.0.0.1:8000/storage/images/defaults/service.png")
                        .replaceFirst('127.0.0.1', AppConstants.baseaddress),
                    fit: BoxFit.cover,
                    height: 60, // يمكنك جعل الارتفاع ثابتاً هنا أيضاً
                  ),
                ),
              ),
              SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  services[index].displayName!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textWidthBasis: TextWidthBasis.parent,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, fontFamily: "Cairo"),
                ),
              ),
            ],
          ),
        );
      },
    );

    // GridView.builder(
    //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //     crossAxisCount: 4,
    //     childAspectRatio: 0.8,
    //     crossAxisSpacing: 10,
    //     mainAxisSpacing: 30,
    //   ),
    //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    //   itemCount: services.length,
    //   shrinkWrap: true,
    //   itemBuilder: (ctx, index) {
    //     return ServicesWidget(
    //       indexx: index,
    //       services: services[index],
    //       onToggle: toggleServiceSelection,
    //     );
    //   },
    // );
  }
}
