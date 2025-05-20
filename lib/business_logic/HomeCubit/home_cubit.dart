import 'package:breaking_project/business_logic/HomeCubit/home_states.dart';
import 'package:breaking_project/data/models/banner_image_model.dart';
import 'package:breaking_project/data/models/searched_services_model.dart';
import 'package:breaking_project/data/models/searched_services_providers_model.dart';
import 'package:breaking_project/data/models/searched_technicians_model.dart';
import 'package:breaking_project/data/repository/home_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeCubit extends Cubit<HomeStates> {
  final HomeRepository homeRepository;
  late List<RSearchedTechsData> techssearchresult = [];
  late List<RSearchedServiceData> servicessearchresult = [];
  late List<RBannerImageData> bannerimages = [];
  List<RSearchesServiceProvidersData> serviceproviders = [];

  HomeCubit(
    this.homeRepository,
  ) : super(HomeInitial());

  Future<List<RBannerImageData>> getBannerImages(String token) async {
    final prefs = await SharedPreferences.getInstance();
    var tokenn = prefs.getString('auth_token');

    homeRepository.getBannerImages().then((theimages) {
      emit(BannerImagesSuccess(theimages));
      bannerimages = theimages;
    });
    return bannerimages;
  }

  Future<List<RSearchedTechsData>> searchTechsHome(
      String word, String type) async {
    emit(SearchTechsHomeLoading());
    try {
      final thetechssearchresult =
          await homeRepository.searchTechHome(word, type);
      print("insideee search cubitttt");
      print(thetechssearchresult);
      emit(SearchTechsHomeSuccess(thetechssearchresult));
      return thetechssearchresult;
    } catch (e) {
      print("error in cubit: $e");
      emit(SearchTechsHomeFailed(e.toString()));
      return [];
    }
  }

  Future<List<RSearchesServiceProvidersData>> getServicesProviders(
      List<String> selectedservices) async {
    emit(SearchServicesProvidersLoading());
    try {
      final thetechssearchresult =
          await homeRepository.getServicesProviders(selectedservices);
      print("insideee services providers cubitttt");
      print(thetechssearchresult);
      emit(SearchServicesProvidersSuccess(thetechssearchresult));
      serviceproviders = thetechssearchresult;
      return thetechssearchresult;
    } catch (e) {
      print("error in cubit: $e");
      emit(SearchServicesProvidersFailed(e.toString()));
      return [];
    }
  }

  Future<List<RSearchedServiceData>> searchServicesHome(
      String word, String type) async {
    emit(SearchServicesHomeLoading());
    try {
      final theservicesresult =
          await homeRepository.searchServiceHome(word, type);
      print("insideee search cubitttt");
      print(theservicesresult);
      emit(SearchServicesHomeSuccess(theservicesresult));
      return theservicesresult;
    } catch (e) {
      print("error in cubit: $e");
      emit(SearchServicesHomeFailed(e.toString()));
      return [];
    }
  }
}
