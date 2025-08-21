import 'package:breaking_project/business_logic/HomeCubit/home_cubit.dart';
import 'package:breaking_project/business_logic/ProvidedServicesCubit/provided_services_cubit.dart';
import 'package:breaking_project/business_logic/ServiceCubit/service_cubit.dart';
import 'package:breaking_project/business_logic/ServiceCubit/service_states.dart';
import 'package:breaking_project/core/constants/app_colors.dart';
import 'package:breaking_project/data/models/service_model.dart';
import 'package:breaking_project/data/repository/home_repository.dart';
import 'package:breaking_project/data/repository/provided_services_repository.dart';
import 'package:breaking_project/data/web_services/home_webservices.dart';
import 'package:breaking_project/data/web_services/provided_services_webservices.dart';
import 'package:breaking_project/presentation/screens/servicesProviders.dart';
import 'package:breaking_project/presentation/widgets/custom_elevated_button.dart';
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
  //static List<String> selectedServices = [];
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          // bottomNavigationBar: Padding(
          //   padding: const EdgeInsets.only(right: 16, left: 16, bottom: 16),
          //   child: Row(
          //     children: [
          //       Expanded(
          //           child: CustomElevatedButton(
          //               active: selectedServices.isNotEmpty,
          //               onpressed: selectedServices.isNotEmpty
          //                   ? () {
          //                       // print(selectedServices);
          //                       // Get.to(() => MultiBlocProvider(
          //                       //       providers: [
          //                       //         BlocProvider(
          //                       //           create: (context) => HomeCubit(
          //                       //             HomeRepository(
          //                       //                 homeWebservices: HomeWebservices()),
          //                       //           ),
          //                       //           // child: FilteredTechniciansScreen(
          //                       //           //   selectedservices: selectedServices,
          //                       //           // ),
          //                       //         ),
          //                       //         BlocProvider(
          //                       //           create: (context) => ProvidedServicesCubit(
          //                       //               ProvidedServicesRepository(
          //                       //                   ProvidedServicesWebservices())),
          //                       //         ),
          //                       //       ],
          //                       //       child: FilteredTechniciansScreen(
          //                       //         selectedservices: selectedServices,
          //                       //       ),
          //                       //     ));
          //                     }
          //                   : () {},
          //               text: 'order')),
          //       SizedBox(
          //         width: 10,
          //       ),
          //       Expanded(
          //           child: CustomElevatedButton(
          //               active: selectedServices.isNotEmpty,
          //               onpressed: selectedServices.isNotEmpty
          //                   ? () {
          //                       print(selectedServices);
          //                       Get.to(() => MultiBlocProvider(
          //                             providers: [
          //                               BlocProvider(
          //                                 create: (context) => HomeCubit(
          //                                   HomeRepository(
          //                                       homeWebservices: HomeWebservices()),
          //                                 ),
          //                                 // child: FilteredTechniciansScreen(
          //                                 //   selectedservices: selectedServices,
          //                                 // ),
          //                               ),
          //                               BlocProvider(
          //                                 create: (context) => ProvidedServicesCubit(
          //                                     ProvidedServicesRepository(
          //                                         ProvidedServicesWebservices())),
          //                               ),
          //                             ],
          //                             child: FilteredTechniciansScreen(
          //                               selectedservices: selectedServices,
          //                             ),
          //                           ));
          //                     }
          //                   : () {},
          //               text: 'Next')
          //           // : SizedBox(
          //           //     width: 335,
          //           //     height: 45,
          //           //     child: ElevatedButton(
          //           //       style: ElevatedButton.styleFrom(
          //           //         backgroundColor: Colors.grey,
          //           //         shape: RoundedRectangleBorder(
          //           //           borderRadius: BorderRadius.circular(12),
          //           //         ),
          //           //       ),
          //           //       onPressed: () {},
          //           //       child: Text(
          //           //         'Next',
          //           //         style: const TextStyle(color: Colors.white),
          //           //       ),
          //           //     ),
          //           //   ),
          //           ),
          //     ],
          //   ),
          // ),
          // appBar: AppBar(
          //   leading: IconButton(
          //       onPressed: () {
          //         Get.back();
          //       },
          //       icon: Icon(
          //         Icons.arrow_back_ios_new,
          //       )),
          //   title: Text(
          //     "Services",
          //     style: TextStyle(fontFamily: "Cairo"),
          //   ),
          // ),
          body: videoPlayerController.value.isInitialized
              ? Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        AspectRatio(
                          aspectRatio: videoPlayerController.value.aspectRatio,
                          child: VideoPlayer(videoPlayerController),
                        ),
                        // شريط التقدم
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
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.teal),
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
                    builditemsList(),
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(),
                )
          //Container(color: Colors.white10, child: buildBlocWidget()),
          ),
    );
  }

  Widget buildBlocWidget() {
    return BlocBuilder<ServiceCubit, ServiceStates>(builder: (context, state) {
      if (state is ServiceLoaded) {
        services = (state).services;
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

  // Widget builditemsList() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
  //     child: GridView.builder(
  //       scrollDirection: Axis.vertical,
  //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //         crossAxisCount: 1,
  //         childAspectRatio: 0.8,
  //         crossAxisSpacing: 16,
  //         mainAxisSpacing: 16,
  //       ),
  //       shrinkWrap: true,
  //       physics: const NeverScrollableScrollPhysics(),
  //       itemCount: context.read<ServiceCubit>().services.length,
  //       itemBuilder: (ctx, index) {
  //         return ServicesWidget(
  //           services: context.read<ServiceCubit>().services[index],
  //         );
  //       },
  //     ),
  //   );
  // }

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
  //           indexx: index,
  //           services: services[index],
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget builditemsList() {
    final services = context.read<ServiceCubit>().services;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.8,
        crossAxisSpacing: 10,
        mainAxisSpacing: 30,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: services.length,
      shrinkWrap: true,
      itemBuilder: (ctx, index) {
        return ServicesWidget(
          indexx: index,
          services: services[index],
          onToggle: toggleServiceSelection,
        );
      },
    );
  }
}
