// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:breaking_project/business_logic/HomeCubit/home_cubit.dart';
import 'package:breaking_project/business_logic/HomeCubit/home_states.dart';
import 'package:breaking_project/data/models/searched_technicians_model.dart';
import 'package:breaking_project/presentation/widgets/technisians_widget.dart';

class SearchedTechs extends StatelessWidget {
  SearchedTechs({
    super.key,
  });

  List<RSearchedTechsData> searchresult = [];
  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.white10, child: buildBlocWidget());
  }

  Widget buildBlocWidget() {
    return BlocBuilder<HomeCubit, HomeStates>(builder: (context, state) {
      if (state is SearchTechsHomeSuccess) {
        print("searchedddd tech homeee successss");
        searchresult = (state).techssearchresult;
        print("this is techsssss");
        print(searchresult);
        return buildLoadedListWidget();
      } else if (state is SearchTechsHomeLoading) {
        return showloadingindicator();
      } else if (state is SearchServicesHomeFailed) {
        return Center(child: Text("No Result !"));
      } else {
        return buildLoadedListWidget();
      }
    });
  }

  Widget buildLoadedListWidget() {
    return builditemsList();
  }

  Widget showloadingindicator() {
    return const Center(
        child: CircularProgressIndicator(
      color: const Color.fromRGBO(95, 50, 20, 1),
    ));
  }

  Widget builditemsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: searchresult.length,
      itemBuilder: (ctx, index) {
        return TechnisiansWidget(
          technisians: searchresult[index],
        );
      },
    );
  }
}




// class SearchedTechnisians extends StatefulWidget {
//   final String word;
//   final String type;
//   const SearchedTechnisians({Key? key, required this.word, required this.type})
//       : super(key: key);
//   @override
//   State<SearchedTechnisians> createState() => SearchedTechnisiansStatee();
// }

// class SearchedTechnisiansStatee extends State<SearchedTechnisians> {
//   late List<RSearchedTechsData> searchresult;
//   final searchTextController = TextEditingController();
//   late String id;
//   bool isInitialized = false;

//   // @override
//   // void initState() {
//   //   super.initState();
//   //   BlocProvider.of<HomeCubit>(context)
//   //       .searchTechsHome(widget.word, widget.type);
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Container(color: Colors.white10, child: buildBlocWidget());
//   }

//   Widget buildBlocWidget() {
//     return BlocBuilder<HomeCubit, HomeStates>(builder: (context, state) {
//       if (state is SearchTechsHomeSuccess) {
//         print("searchedddd tech homeee successss");
//         searchresult = (state).techssearchresult;
//         return buildLoadedListWidget();
//       } else {
//         return showloadingindicator();
//       }
//     });
//   }

//   Widget buildLoadedListWidget() {
//     return builditemsList();
//   }

//   Widget showloadingindicator() {
//     return const Center(
//         child: CircularProgressIndicator(
//       color: const Color.fromRGBO(95, 96, 185, 1),
//     ));
//   }

//   Widget builditemsList() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: GridView.builder(
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           childAspectRatio: 0.8,
//           crossAxisSpacing: 16,
//           mainAxisSpacing: 16,
//         ),
//         shrinkWrap: true,
//         //physics: const NeverScrollableScrollPhysics(),
//         itemCount: searchresult.length,
//         itemBuilder: (ctx, index) {
//           return TechnisiansWidget(
//             technisians: searchresult[index],
//           );
//         },
//       ),
//     );
//   }
// }
