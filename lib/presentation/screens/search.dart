import 'package:breaking_project/business_logic/HomeCubit/home_cubit.dart';
import 'package:breaking_project/business_logic/HomeCubit/home_states.dart';
import 'package:breaking_project/data/models/search_model.dart';
import 'package:breaking_project/data/repository/home_repository.dart';
import 'package:breaking_project/data/web_services/home_webservices.dart';
import 'package:breaking_project/presentation/screens/searched_services.dart';
import 'package:breaking_project/presentation/screens/searched_technisians.dart';
import 'package:breaking_project/presentation/widgets/technisians_widget.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final PageController _pageController = PageController();
  int currentindex = 0;
  Color buttoncolour = Colors.grey;
  late TextEditingController searchcontroller;
  String type = 'technician';
  List<RSearchData>? searchlist;

  @override
  void initState() {
    searchcontroller = TextEditingController(text: '');
    super.initState();
  }

  Widget buildBlocWidget() {
    return BlocBuilder<HomeCubit, HomeStates>(builder: (context, state) {
      if (state is SearchHomeSuccess) {
        searchlist = (state).searchresult;
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

  List<Widget> get searchScreens => [
        BlocProvider(
          create: (context) =>
              HomeCubit(HomeRepository(homeWebservices: HomeWebservices())),
          child: SearchedTechnisians(
              word: searchcontroller.text == '' ? '.' : searchcontroller.text,
              type: type),
        ),
        BlocProvider(
          create: (context) =>
              HomeCubit(HomeRepository(homeWebservices: HomeWebservices())),
          child: SearchedServices(
              word: searchcontroller.text == '' ? '.' : searchcontroller.text,
              type: type),
        ),
      ];

  // final List<Widget> searchScreens = [
  //   BlocProvider(
  //     create: (context) =>
  //         HomeCubit(HomeRepository(homeWebservices: HomeWebservices())),
  //     child: SearchedTechnisians(word: 'حمد', type: type),
  //   ),
  //   BlocProvider(
  //     create: (context) =>
  //         HomeCubit(HomeRepository(homeWebservices: HomeWebservices())),
  //     child: SearchedServices(word: 'جمد', type: 'service'),
  //   ),
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 275,
            color: const Color.fromARGB(255, 236, 233, 233),
            child: Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 40),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.arrow_back_ios_new_outlined)),
                      SizedBox(
                        width: 100,
                      ),
                      Text(
                        "Search",
                        style: TextStyle(
                            fontSize: 21, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          Text(
                            "Deliver to : ",
                            style: TextStyle(fontSize: 17),
                          ),
                          Text(
                            "home",
                            style: TextStyle(
                                fontSize: 17,
                                color: const Color.fromARGB(255, 231, 150, 45),
                                fontWeight: FontWeight.bold),
                          ),
                          Icon(
                            Icons.keyboard_arrow_down,
                            color: const Color.fromARGB(255, 231, 150, 45),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 300,
                        height: 45,
                        child: TextFormField(
                          onChanged: (searchingtext) {
                            setState(() {
                              context
                                  .read<HomeCubit>()
                                  .searchHome(searchingtext, type);
                            });
                          },
                          controller: searchcontroller,
                          onFieldSubmitted: (searcheditem) {},
                          style: TextStyle(fontSize: 16),
                          keyboardType: TextInputType.text,
                          cursorWidth: 1.5,
                          textDirection: TextDirection.rtl,
                          cursorColor: const Color.fromARGB(255, 231, 150, 45),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  bottomLeft: Radius.circular(30),
                                ),
                                borderSide: BorderSide(color: Colors.black)),
                            filled: true,
                            fillColor: Colors.white,
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  bottomLeft: Radius.circular(30),
                                ),
                                borderSide: BorderSide(color: Colors.black)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  bottomLeft: Radius.circular(30),
                                ),
                                borderSide: BorderSide(color: Colors.black)),
                            disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  bottomLeft: Radius.circular(30),
                                ),
                                borderSide: BorderSide(color: Colors.black)),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  bottomLeft: Radius.circular(30),
                                ),
                                borderSide: BorderSide(color: Colors.black)),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 0.5,
                      ),
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              ),
                              border: Border.all(
                                color: Colors.black,
                              )),
                          height: 45,
                          width: 40,
                          child: Icon(
                            Icons.search,
                            color: const Color.fromARGB(255, 179, 174, 174),
                          ))
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: SizedBox(
                      width: 250,
                      child: ConvexAppBar(
                        initialActiveIndex: currentindex,
                        elevation: 0,
                        activeColor: Colors.black,
                        color: Colors.black,
                        disableDefaultTabController: false,
                        style: TabStyle.textIn,
                        backgroundColor:
                            const Color.fromARGB(255, 236, 233, 233),
                        items: [
                          TabItem(icon: Icons.person, title: 'technisians'),
                          TabItem(icon: Icons.settings, title: 'Services'),
                        ],
                        onTap: (index) {
                          setState(() {
                            currentindex = index;
                            type = currentindex == 0 ? 'technician' : 'service';
                            // _pageController.jumpToPage(index);
                          });
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          BlocProvider(
            create: (context) =>
                HomeCubit(HomeRepository(homeWebservices: HomeWebservices())),
            child: currentindex == 0
                ? SearchedTechnisians(
                    word: searchcontroller.text == ''
                        ? '.'
                        : searchcontroller.text,
                    type: type)
                : SearchedServices(
                    word: searchcontroller.text == ''
                        ? '.'
                        : searchcontroller.text,
                    type: type),
          )
          // Expanded(
          //     child: PageView.builder(
          //   controller: _pageController,
          //   itemCount: 2,
          //   onPageChanged: (index) {
          //     setState(() {
          //       currentindex = index;
          //     });
          //   },
          //   itemBuilder: (context, index) {
          //     return searchScreens[index];
          //   },
          // ))
        ],
      ),
    );
  }
}
