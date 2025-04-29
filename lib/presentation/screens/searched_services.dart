import 'package:breaking_project/business_logic/HomeCubit/home_cubit.dart';
import 'package:breaking_project/business_logic/HomeCubit/home_states.dart';
import 'package:breaking_project/business_logic/ServiceCubit/service_cubit.dart';
import 'package:breaking_project/data/models/search_model.dart';
import 'package:breaking_project/presentation/widgets/technisians_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchedServices extends StatefulWidget {
  final String word;
  final String type;
  const SearchedServices({Key? key, required this.word, required this.type})
      : super(key: key);
  @override
  State<SearchedServices> createState() => SearchedServicesStatee();
}

class SearchedServicesStatee extends State<SearchedServices> {
  late List<RSearchData> searchresult;
  final searchTextController = TextEditingController();
  late String id;
  bool isInitialized = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomeCubit>(context).searchHome(widget.word, widget.type);
  }

  @override
  Widget build(BuildContext context) {
    return
        //Scaffold(
        // appBar: AppBar(
        //   leading: IconButton(
        //       onPressed: () {
        //         Get.back();
        //       },
        //       icon: Icon(Icons.arrow_back_ios_new)),
        //   title: Text("te"),
        // ),
        // body:
        Container(color: Colors.white10, child: buildBlocWidget());
  }

  Widget buildBlocWidget() {
    return BlocBuilder<HomeCubit, HomeStates>(builder: (context, state) {
      if (state is SearchHomeSuccess) {
        searchresult = (state).searchresult;
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
      color: const Color.fromRGBO(95, 96, 185, 1),
    ));
  }

  Widget builditemsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: context.read<HomeCubit>().searchresult.length,
        itemBuilder: (ctx, index) {
          return TechnisiansWidget(
            technisians: context.read<HomeCubit>().searchresult[index],
          );
        },
      ),
    );
  }
}
