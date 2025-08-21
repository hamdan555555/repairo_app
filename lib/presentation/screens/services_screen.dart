import 'package:breaking_project/business_logic/ServiceCubit/service_cubit.dart';
import 'package:breaking_project/business_logic/ServiceCubit/service_states.dart';
import 'package:breaking_project/core/constants/app_constants.dart';
import 'package:breaking_project/data/models/service_model.dart';
import 'package:breaking_project/presentation/widgets/cart_bottomsheet_widget.dart';
import 'package:breaking_project/presentation/widgets/cart_item_widget.dart';
import 'package:breaking_project/presentation/widgets/services_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icon.dart';
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

  void toggleServiceSelection(String service, bool selected) {
    setState(() {
      if (selected) {
        selectedServices.add(service);
      } else {
        selectedServices.remove(service);
      }
    });
  }

  late List<RServiceData> services;
  final searchTextController = TextEditingController();
  late String subcategoryname;

  late String id;
  bool isInitialized = false;

  void _showCart() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return CartBottomSheet(cart: cart);
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
        videoPlayerController.setLooping(true);
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
    return BlocBuilder<ServiceCubit, ServiceStates>(
      builder: (context, state) {
        if (state is ServiceLoaded) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
                body: videoPlayerController.value.isInitialized
                    ? SingleChildScrollView(
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
                                        onTap: () {},
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
                                        onTap: () {},
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
                          ],
                        ),
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      )),
          );
        } else {
          return showloadingindicator();
        }
      },
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

    return ListView.builder(
      padding: EdgeInsets.all(0),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return Card(
          margin: EdgeInsets.all(8),
          child: ListTile(
            leading: Image.network(
                service.image!
                    .replaceFirst(services[index].image!.toString(),
                        "http://127.0.0.1:8000/storage/images/defaults/service.png")
                    .replaceFirst('127.0.0.1', AppConstants.baseaddress),
                width: 60),
            title: Text(service.displayName!),
            subtitle: Text(
                "خدمة جديدة تستطيع تلبية احتياجات المستخدمين اللذين يرغبون بالاستفادة من الخدمات الموجودة على النظام ومن ثم استخدامها"),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${service.minPrice} درهم"),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      cart.add(service);
                    });
                    if (cart.items.isNotEmpty) {
                      _showCart();
                    }
                  },
                  child: Text("أضف"),
                ),
              ],
            ),
          ),
        );
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
        return Column(
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
