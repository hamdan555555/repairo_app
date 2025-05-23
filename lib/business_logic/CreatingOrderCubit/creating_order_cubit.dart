import 'dart:io';
import 'package:breaking_project/business_logic/CreatingOrderCubit/creating_order_states.dart';
import 'package:breaking_project/business_logic/LoginCubit/login_cubit.dart';
import 'package:breaking_project/data/repository/creating_order_repository.dart';
import 'package:breaking_project/presentation/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreatingOrderCubit extends Cubit<CreatingOrderStates> {
  final CreatingOrderRepository creatingOrderRepository;

  final addressController = TextEditingController();
  final detailsController = TextEditingController();

  CreatingOrderCubit(this.creatingOrderRepository)
      : super(CreatingOrderInitial());

  void createOrder(
      {required String technicianId,
      required List<String> selectedServiceIds,
      required String location,
      required List<File> images,
      required String date,
      required String time,
      required String details}) async {
    emit(CreatingOrderLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      String lat = prefs.getString('lat')!;
      String lng = prefs.getString('lng')!;
      await creatingOrderRepository.createOrder(
          date: date,
          details: details,
          images: images,
          latitude: lat,
          location: location,
          longtude: lng,
          selectedServiceIds: selectedServiceIds,
          technicianId: technicianId,
          time: time);
      emit(CreatingOrderSuccess());
      // Get.back();
      // Get.defaultDialog(
      //   title: '',
      //   titlePadding: EdgeInsets.only(left: 16, right: 16, bottom: 0, top: 0),
      //   content: Column(
      //     children: [
      //       Container(
      //           width: 32,
      //           height: 32,
      //           child: SvgPicture.asset("assets/images/svg/checkc.svg")),
      //       SizedBox(
      //         height: 5,
      //       ),
      //       Text(
      //         "Your order has been created",
      //         style: TextStyle(
      //             fontSize: 15,
      //             fontWeight: FontWeight.w500,
      //             color: Color.fromRGBO(71, 71, 71, 1)),
      //       ),
      //     ],
      //   ),
      //   middleText: "Enter Correct Informations",
      //   backgroundColor: Colors.white,
      //   middleTextStyle: TextStyle(color: Colors.black),
      //   confirm: Padding(
      //     padding: const EdgeInsets.only(left: 63, right: 63, bottom: 12),
      //     child: CustomElevatedButton(
      //         text: 'ok',
      //         onpressed: () {
      //           //Get.back();
      //         }),
      //   ),
      //   barrierDismissible: false,
      // );
      print("Doneeeeeeeeeeeeeeeeeeee");
      //Get.back();
      //Get.toNamed('verification');
    } catch (e) {
      emit(CreatingOrderError(e.toString()));
    }
  }
}
