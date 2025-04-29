import 'package:breaking_project/data/models/banner_image_model.dart';
import 'package:breaking_project/data/models/search_model.dart';

abstract class HomeStates {}

class HomeInitial extends HomeStates {}

class BannerImagesInitial extends HomeStates {}

class BannerImagesLoading extends HomeStates {}

class BannerImagesFailed extends HomeStates {
  final String message;
  BannerImagesFailed(this.message);
}

class BannerImagesSuccess extends HomeStates {
  final List<RBannerImageData> bannerimages;
  BannerImagesSuccess(this.bannerimages);
}

class SearchHomeInitial extends HomeStates {}

class SearchHomeLoading extends HomeStates {}

class SearchHomeFailed extends HomeStates {
  final String message;
  SearchHomeFailed(this.message);
}

class SearchHomeSuccess extends HomeStates {
  final List<RSearchData> searchresult;
  SearchHomeSuccess(this.searchresult);
}
