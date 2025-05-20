import 'package:breaking_project/business_logic/HomeCubit/home_cubit.dart';
import 'package:breaking_project/business_logic/HomeCubit/home_states.dart';
import 'package:flutter/material.dart';
import 'package:breaking_project/presentation/screens/searched_services.dart';
import 'package:breaking_project/presentation/screens/searched_technisians.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController searchController;
  String type = 'technician';
  late int techcount;
  late int servicecount;
  late String techTab;
  late String serviceTab;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController(text: '');
    final cubit = context.read<HomeCubit>();
    techcount = cubit.techssearchresult.length;
    servicecount = cubit.servicessearchresult.length;
    techTab = 'Technician(${techcount.toString()})';
    serviceTab = 'Services(${servicecount.toString()})';
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        body: Column(
          children: [
            Container(
              height: 280,
              color: const Color.fromARGB(255, 236, 233, 233),
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 40),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(Icons.arrow_back_ios_new_outlined),
                        ),
                        const Spacer(),
                        const Text(
                          "Search",
                          style: TextStyle(
                              fontSize: 21, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(flex: 2),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: GestureDetector(
                        onTap: () {},
                        child: Row(
                          children: const [
                            Text(
                              "Current Location : ",
                              style: TextStyle(fontSize: 17),
                            ),
                            Text(
                              "home",
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.bold),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.deepPurple,
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        SizedBox(
                          width: 300,
                          height: 45,
                          child: TextFormField(
                            controller: searchController,
                            onChanged: (value) {
                              final cubit = context.read<HomeCubit>();
                              cubit.searchServicesHome(
                                  searchController.text, 'service');
                              cubit.searchTechsHome(
                                  searchController.text, 'technician');
                              setState(() {
                                techcount = cubit.techssearchresult.length;
                                servicecount =
                                    cubit.servicessearchresult.length;
                                techTab = 'Technician ($techcount)';
                                serviceTab = 'Services ($servicecount)';
                                print(serviceTab);
                              });
                            },
                            style: const TextStyle(fontSize: 16),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  bottomLeft: Radius.circular(30),
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  bottomLeft: Radius.circular(30),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  bottomLeft: Radius.circular(30),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 45,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                            border: Border.all(color: Colors.black),
                          ),
                          child: const Icon(
                            Icons.search,
                            color: Color.fromARGB(255, 179, 174, 174),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    BlocBuilder<HomeCubit, HomeStates>(
                      builder: (context, state) {
                        final cubit = context.read<HomeCubit>();
                        final techcount = cubit.techssearchresult.length;
                        final servicecount = cubit.servicessearchresult.length;
                        final techTab = 'Technicians ($techcount)';
                        final serviceTab = 'Services ($servicecount)';

                        return TabBar(
                          indicatorColor: Colors.black,
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.grey,
                          tabs: [
                            Tab(icon: const Icon(Icons.person), text: techTab),
                            Tab(
                                icon: const Icon(Icons.settings),
                                text: serviceTab),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            //const SizedBox(height: 5),
            Expanded(
              child: TabBarView(
                children: [
                  SearchedTechs(), // أو SearchedTechnisians(...)
                  SearchedServ(), // أو SearchedServices(...)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
