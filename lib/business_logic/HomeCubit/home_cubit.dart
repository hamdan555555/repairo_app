import 'package:breaking_project/business_logic/HomeCubit/home_states.dart';
import 'package:breaking_project/data/models/banner_image_model.dart';
import 'package:breaking_project/data/models/search_model.dart';
import 'package:breaking_project/data/repository/home_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeCubit extends Cubit<HomeStates> {
  final HomeRepository homeRepository;
  late List<RSearchData> searchresult = [];
  late List<RBannerImageData> bannerimages = [];

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

  // void searchHome(String word, String type) async {
  //   emit(SearchHomeLoading());
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     var tokenn = prefs.getString('auth_token');

  //     final searcheresult = await homeRepository.searchHome(word, type);
  //     emit(SearchHomeSuccess(searcheresult));
  //   } catch (e) {
  //     emit(SearchHomeFailed(e.toString()));
  //   }
  // }

  Future<List<RSearchData>> searchHome(String word, String type) async {
    homeRepository.searchHome(word, type).then((thesearchresult) {
      emit(SearchHomeSuccess(searchresult));
      searchresult = thesearchresult;
    });
    return searchresult;
  }
}
