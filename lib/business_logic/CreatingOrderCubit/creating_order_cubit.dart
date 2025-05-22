import 'dart:io';
import 'package:breaking_project/business_logic/CreatingOrderCubit/creating_order_states.dart';
import 'package:breaking_project/data/repository/creating_order_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      print("Doneeeeeeeeeeeeeeeeeeee");
      //Get.back();
      //Get.toNamed('verification');
    } catch (e) {
      emit(CreatingOrderError(e.toString()));
    }
  }
}
