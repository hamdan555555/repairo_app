//أولا بنية المشروع هي كالتالي
// lib/
// │
// ├── core/                         # يحتوي على الأشياء المشتركة عبر كامل المشروع
// │   ├── constants/                # ثوابت عامة (Strings, Colors, Fonts, etc.)
// │   │   ├── app_colors.dart
// │   │   ├── app_strings.dart
// │   │   ├── app_fonts.dart
// │   │   └── app_values.dart       # padding, radius, durations...
// │   │
// │   ├── utils/                    # أدوات مساعدة (Validation, Formatters, etc.)
// │   │   ├── validators.dart
// │   │   ├── error_handler.dart
// │   │   └── helpers.dart
// │   │
// │   ├── services/                 # Services شغالة على مستوى التطبيق
// │   │   ├── network_checker.dart
// │   │   ├── notification_service.dart
// │   │   └── local_storage_service.dart
// │   │
// │   └── config/                   # إعدادات التطبيق العامة
// │       └── app_config.dart
// │
// ├── data/                         # طبقة البيانات
// │   ├── models/
// │   ├── webservices/
// │   └── repository/
// │
// ├── business_logic/               # Cubits + States
// │
// ├── presentation/                 # الشاشات والـ UI
// │   ├── screens/
// │   ├── widgets/
// │   └── dialogs/
// │
// └── main.dart


// 1. ثوابت المشروع:
// app_strings.dart: كل النصوص الثابتة (مثلاً: "تسجيل الدخول", "اسم المستخدم").

// app_colors.dart: ألوان موحّدة.

// app_fonts.dart: إعدادات الخطوط.

// app_values.dart: قيم ثابتة مثل الـ padding, borderRadius...

// 2. Validation و Error Handling:
// validators.dart: يحتوي على دوال مثل isValidEmail, isStrongPassword, الخ...

// error_handler.dart: دالة handleError(Exception e) مثلاً، بتعمل mapping للـ exceptions إلى رسائل مفهومة.

// 3. خدمات عامة:
// أي شيء بدك تستخدمه على مستوى المشروع كامل بتحطه بمجلد services/ مثل:

// NetworkChecker: ليتأكد من الاتصال.

// NotificationService: لإرسال الإشعارات.

// LocalStorageService: SharedPreferences أو Hive.




/////////////////////////////sharedPrefrence/////////////////////
//ملاحظة بالنسبة لل sharedprefrence
// لما تفتح التطبيق (بـ main.dart) لازم تنادي:
// dart
// Copy
// Edit
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await LocalStorageService.init();
//   runApp(MyApp());
// لما المستخدم ينتقل لشاشة جديدة (مثلاً لما يدخل على ProfilePage)،
// بتخزنها بهالشكل:
// dart
// Copy
// Edit
// await LocalStorageService.saveLastVisitedScreen('/profile');
// ولما يفتح التطبيق (SplashScreen أو init عند بداية البرنامج)،
// تستدعي:
// dart
// Copy
// Edit
// String? lastScreen = LocalStorageService.getLastVisitedScreen();
// if (lastScreen != null) {
//   Navigator.pushNamed(context, lastScreen);
// } else {
//   Navigator.pushNamed(context, '/home');
// }
// ➔ هيك إذا كان مخزن آخر شاشة، بتفوتو عليها، وإذا لأ بتوديه على الشاشة الرئيسية.





























        //  SingleChildScrollView(
        //   child: Column(
        //     children: [
        //       Stack(children: [
        //         Column(
        //           children: [
        //             Stack(
        //               children: [
        //                 BlocBuilder<HomeCubit, HomeStates>(
        //                   builder: (context, state) {
        //                     if (state is BannerImagesSuccess) {
        //                       print("this is your image path");
        //                       bannerimages = (state).bannerimages;
        //                       var thisimage = bannerimages[0].image!.  (
        //                           '127.0.0.1', AppConstants.baseaddress);
        //                       print(thisimage.toString());
        //                       return SizedBox(
        //                         height: 220,
        //                         child: PageView.builder(
        //                           controller: _controller,
        //                           itemCount: context
        //                               .read<HomeCubit>()
        //                               .bannerimages
        //                               .length,
        //                           //images.length,
        //                           onPageChanged: (index) {
        //                             currentPageNotifier.value = index;
        //                           },
        //                           itemBuilder: (context, index) {
        //                             return ClipRRect(
        //                               borderRadius: const BorderRadius.only(
        //                                 bottomLeft: Radius.circular(0),
        //                                 bottomRight: Radius.circular(0),
        //                               ),
        //                               child: Image.network(
        //                                 // 'http://172.20.10.5:8000/storage/images/defaults/banner.png'
        //                                 bannerimages[index].image!.  (
        //                                     '127.0.0.1',
        //                                     AppConstants.baseaddress),
        //                                 fit: BoxFit.cover,
        //                                 width: double.infinity,
        //                                 height: 200,
        //                               ),

        //                               //  Image.asset(
        //                               //   images[index],
        //                               //   fit: BoxFit.cover,
        //                               //   width: double.infinity,
        //                               // ),
        //                             );
        //                           },
        //                         ),
        //                       );
        //                     } else {
        //                       return Shimmer.fromColors(
        //                         baseColor: Colors.grey.shade300,
        //                         highlightColor: Colors.grey.shade100,
        //                         child: Container(
        //                           width: double.infinity,
        //                           height: 220,
        //                           color: Colors.white,
        //                         ),
        //                       );
        //                     }
        //                   },
        //                 ),
        //                 Positioned(
        //                   bottom: 36,
        //                   left: 0,
        //                   right: 0,
        //                   child: Center(
        //                     child: ValueListenableBuilder<int>(
        //                       valueListenable: currentPageNotifier,
        //                       builder: (context, value, child) {
        //                         return SmoothPageIndicator(
        //                           controller: _controller,
        //                           count: images.length,
        //                           effect: const WormEffect(
        //                             activeDotColor: Colors.white,
        //                             dotColor: Colors.white54,
        //                             dotHeight: 8,
        //                             dotWidth: 8,
        //                           ),
        //                         );
        //                       },
        //                     ),
        //                   ),
        //                 ),
        //                 Positioned(
        //                     top: 50,
        //                     left: 300,
        //                     right: 0,
        //                     child: GestureDetector(
                              // onTap: () {
                              //   Get.to(() => MultiBlocProvider(
                              //         providers: [
                              //           BlocProvider(
                              //             create: (context) => AllWalletRequestsCubit(
                              //                 AllWalletRequestsRepository(
                              //                     allWalletRequestsWebservice:
                              //                         AllWalletRequestsWebservice())),
                              //           ),
                              //           BlocProvider(
                              //             create: (context) => AllbanksCubit(
                              //                 BanksRepository(
                              //                     bankWebservices:
                              //                         BankWebservices())),
                              //           ),
                              //         ],
                              //         child: AllWalletRequestsScreen(),
                              //       ));
        //                         // Get.to(ShipmentRequestsScreen());
        //                       },
        //                       child: CircleAvatar(
        //                         child: SvgPicture.asset(
        //                             'assets/images/svg/Notification.svg'),
        //                         radius: 18,
        //                         backgroundColor: Colors.white,
        //                       ),
        //                     )),
        //                 Positioned(
        //                     top: 50,
        //                     left: 0,
        //                     right: 300,
        //                     child: GestureDetector(
        //                       onTap: () {
        //                         scaffoldKey.currentState!.openDrawer();
        //                       },
        //                       child: CircleAvatar(
        //                         child: Icon(Icons.list),
        //                         radius: 18,
        //                         backgroundColor: Colors.white,
        //                       ),
        //                     )),
        //               ],
        //             ),
        //             SizedBox(
        //               height: 40,
        //             ),
        //             Padding(
        //               padding: const EdgeInsets.symmetric(horizontal: 16),
        //               child: Row(
        //                 children: [
        //                   Text(
        //                     "Categories",
        //                     style: TextStyle(
        //                       fontSize: 22,
        //                     ),
        //                   ),
        //                   Padding(
        //                     padding: const EdgeInsets.only(left: 180),
        //                     child: GestureDetector(
        //                         onTap: () {
        //                           Get.toNamed('allcategories');
        //                         },
        //                         child: Text("View All")),
        //                   )
        //                 ],
        //               ),
        //             ),
        //             SizedBox(
        //               height: 20,
        //             ),
        //             buildBlocWidget(),
        //             Container(
        //               decoration: BoxDecoration(
        //                   color: Color.fromARGB(255, 226, 222, 222)),
        //               height: 360,
        //               child: Padding(
        //                 padding: const EdgeInsets.only(
        //                     top: 20, left: 8, right: 8, bottom: 20),
        //                 child: Column(children: [
        //                   Padding(
        //                     padding: const EdgeInsets.symmetric(horizontal: 16),
        //                     child: Row(
        //                       children: [
        //                         Text(
        //                           "Pobular Now",
        //                           style: TextStyle(
        //                             fontSize: 22,
        //                           ),
        //                         ),
        //                         Padding(
        //                           padding: const EdgeInsets.only(left: 150),
        //                           child: GestureDetector(child: Text("View All")),
        //                         )
        //                       ],
        //                     ),
        //                   ),
        //                   SizedBox(
        //                     height: 5,
        //                   ),
        //                   Expanded(
        //                     child: ListView.separated(
        //                       separatorBuilder: (context, index) {
        //                         return SizedBox(
        //                           width: 12,
        //                         );
        //                       },
        //                       itemBuilder: (context, index) {
        //                         return ServiceWidget();
        //                       },
        //                       itemCount: 2,
        //                       scrollDirection: Axis.horizontal,
        //                       shrinkWrap: true,
        //                     ),
        //                   ),
        //                 ]),
        //               ),
        //             ),
        //           ],
        //         ),
        //         Positioned(
        //           top: 195,
        //           child: Padding(
        //             padding: const EdgeInsets.symmetric(horizontal: 16),
        //             child: Row(
        //               children: [
        //                 SizedBox(
        //                   width: 270,
        //                   height: 50,
        //                   child: TextFormField(
        //                     decoration: InputDecoration(
        //                       hintText: 'type to start searching',
        //                       hintStyle: const TextStyle(fontSize: 14),
        //                       filled: true,
        //                       fillColor: const Color.fromARGB(255, 242, 244, 245),
        //                       contentPadding: const EdgeInsets.symmetric(
        //                           vertical: 16.0, horizontal: 20.0),
        //                       border: OutlineInputBorder(
        //                         borderRadius: BorderRadius.circular(6.0),
        //                         borderSide: const BorderSide(color: Colors.black),
        //                       ),
        //                       focusedBorder: OutlineInputBorder(
        //                         borderRadius: BorderRadius.circular(6.0),
        //                         borderSide: const BorderSide(color: Colors.black),
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //                 SizedBox(
        //                   width: 5,
        //                 ),
        //                 Container(
        //                   width: 50,
        //                   height: 50,
        //                   decoration: BoxDecoration(
        //                       color: Color.fromARGB(255, 242, 244, 245),
        //                       borderRadius: BorderRadius.all(Radius.circular(10)),
        //                       border: Border.all(color: Colors.black)),
        //                   child: Icon(
        //                     Icons.search,
        //                     color: Colors.black,
        //                   ),
        //                 )
        //               ],
        //             ),
        //           ),
        //         ),
        //       ]),
        //     ],
        //   ),
        // ),













        
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