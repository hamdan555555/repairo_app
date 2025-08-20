import 'package:breaking_project/business_logic/HomeCubit/home_cubit.dart';
import 'package:breaking_project/business_logic/HomeCubit/home_states.dart';
import 'package:breaking_project/data/models/searched_services_model.dart';
import 'package:breaking_project/presentation/widgets/searching_services_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchedServ extends StatefulWidget {
  SearchedServ({super.key});
  @override
  State<SearchedServ> createState() => _SearchedServState();
}

class _SearchedServState extends State<SearchedServ> {
  List<RSearchedServiceData> searchresult = [];
  List<String> selectedServices = [];

  void toggleServiceSelection(String service, bool selected) {
    setState(() {
      if (selected) {
        selectedServices.add(service);
      } else {
        selectedServices.removeWhere((element) => element == service);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.white10, child: buildBlocWidget());
  }

  Widget buildBlocWidget() {
    return BlocBuilder<HomeCubit, HomeStates>(builder: (context, state) {
      if (state is SearchServicesHomeSuccess) {
        searchresult = (state).servicessearchresult;
        return buildLoadedListWidget();
      } else if (state is SearchServicesHomeLoading) {
        return showloadingindicator();
      } else if (state is SearchTechsHomeFailed) {
        return Center(
          child: Text("NO Result !"),
        );
      } else {
        return buildLoadedListWidget();
      }
    });
  }

  Widget buildLoadedListWidget() {
    return builditemsList();
  }

  Widget showloadingindicator() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      child: const Center(
          child: CircularProgressIndicator(
        color: Colors.teal,
      )),
    );
  }

  Widget builditemsList() {
    // فرز القائمة أولاً لضمان الترتيب الصحيح
    searchresult.sort((a, b) {
      if (a.type == "category" && b.type != "category") return -1;
      if (a.type != "category" && b.type == "category") return 1;

      if (a.type == "sub_category" && b.type != "sub_category") return -1;
      if (a.type != "sub_category" && b.type == "sub_category") return 1;

      if (a.type == "service" && b.type != "service") return -1;
      if (a.type != "service" && b.type == "service") return 1;

      return 0;
    });

    // إنشاء القائمة الجديدة مع العناوين
    List<dynamic> combinedList = [];
    String? lastType;

    for (var item in searchresult) {
      // إضافة عنوان جديد إذا كان نوع العنصر مختلف عن السابق
      if (item.type != lastType) {
        combinedList.add(item.type); // هنا نضيف العنوان كـ String
        lastType = item.type;
      }
      combinedList.add(item); // ثم نضيف العنصر نفسه
    }

    // استخدام ListView.builder على القائمة المدمجة
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: combinedList.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (ctx, index) {
        final item = combinedList[index];

        if (item is String) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            child: Text(
              item == "category"
                  ? "الفئات"
                  : item == "sub_category"
                      ? " الفئات الفرعية"
                      : "الخدمات",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: "Cairo",
                color: Colors.grey,
              ),
            ),
          );
        } else {
          return SearchingServicesWidget(
            onToggle: toggleServiceSelection,
            indexx: index,
            services: item as RSearchedServiceData,
          );
        }
      },
    );
  }
}
