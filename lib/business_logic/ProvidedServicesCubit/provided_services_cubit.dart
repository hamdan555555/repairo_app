import 'package:breaking_project/business_logic/LoginCubit/login_states.dart';
import 'package:breaking_project/business_logic/ProvidedServicesCubit/provided_services_states.dart';
import 'package:breaking_project/data/models/provided_services.dart';
import 'package:breaking_project/data/repository/login_repository.dart';
import 'package:breaking_project/data/repository/provided_services_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProvidedServicesCubit extends Cubit<ProvidedServicesStates> {
  final ProvidedServicesRepository providedServicesRepository;

  ProvidedServicesCubit(this.providedServicesRepository)
      : super(ProvidedServicesInitial());

  // Future<RProvidedServicesData> getThisTechServices(
  //     String id, List<String> selectedervices) async {
  //   emit(ProvidedServicesLoading());
  //   try {
  //     final techServices = await providedServicesRepository.getThisTechServices(
  //         id, selectedervices);
  //     emit(ProvidedServicesSuccess(techServices));
  //     Get.back();
  //     Get.toNamed('verification');
  //   } catch (e) {
  //     emit(LoginError(e.toString()));
  //   }
  // }

  Future<void> fetchProvidedServices(
      String techId, List<String> selectedServiceIds) async {
    emit(ProvidedServicesLoading());

    try {
      final services = await providedServicesRepository.getThisTechServices(
          techId, selectedServiceIds);

      emit(ProvidedServicesSuccess(services));
    } catch (e) {
      emit(ProvidedServicesError(e.toString()));
    }
  }
}
