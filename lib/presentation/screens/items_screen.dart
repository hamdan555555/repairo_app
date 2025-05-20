// import 'package:breaking_project/business_logic/ServicesCubit/services_cubit.dart';
// import 'package:breaking_project/core/constants/app_colors.dart';
// import 'package:breaking_project/data/models/items_model.dart';
// import 'package:breaking_project/presentation/widgets/Items_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class ItemsScreen extends StatefulWidget {
//   const ItemsScreen({super.key});

//   @override
//   State<ItemsScreen> createState() => _ItemsScreenState();
// }

// class _ItemsScreenState extends State<ItemsScreen> {
//   late List<Services> allitems;
//   late List<Services> searcheditems;
//   bool isSearching = false;
//   final searchTextController = TextEditingController();

//   Widget buildSearchField() {
//     return TextField(
//       controller: searchTextController,
//       cursorColor: AppColors.grey,
//       decoration: const InputDecoration(
//         hintText: 'Find An Item',
//         border: InputBorder.none,
//         hintStyle: TextStyle(
//           color: AppColors.grey,
//           fontSize: 18,
//         ),
//       ),
//       style: TextStyle(
//         color: AppColors.grey,
//         fontSize: 18,
//       ),
//       onChanged: (searched_text) {
//         addSearchingItemToViewedList(searched_text);
//       },
//     );
//   }

//   void addSearchingItemToViewedList(String searched_text) {
//     searcheditems = allitems
//         .where(
//             (item) => item.description.toLowerCase().startsWith(searched_text))
//         .toList();
//   }

//   @override
//   void initState() {
//     BlocProvider.of<ServicesCubit>(context).getAllItems();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: buildBlocWidget(),
//     );
//   }

//   Widget buildBlocWidget() {
//     return BlocBuilder<ServicesCubit, ServicesStates>(
//         builder: (context, state) {
//       if (state is ServicesLoaded) {
//         allitems = (state).services;
//         return buildLoadedListWidget();
//       } else {
//         return showloadingindicator();
//       }
//     });
//   }

//   Widget buildLoadedListWidget() {
//     return SingleChildScrollView(
//       child: Container(
//         color: AppColors.yellow,
//         child: Column(
//           children: [
//             builditemsList(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget showloadingindicator() {
//     return const Center(
//         child: CircularProgressIndicator(
//       color: AppColors.yellow,
//     ));
//   }

//   Widget builditemsList() {
//     return GridView.builder(
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           childAspectRatio: 2 / 3,
//           crossAxisSpacing: 1,
//           mainAxisSpacing: 1,
//         ),
//         shrinkWrap: true,
//         physics: const ClampingScrollPhysics(),
//         padding: EdgeInsets.zero,
//         itemCount: allitems.length,
//         itemBuilder: (ctx, index) {
//           return ItemWidget(item: allitems[index]);
//         });
//   }
// }
