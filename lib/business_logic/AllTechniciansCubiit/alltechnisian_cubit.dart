import 'package:bloc/bloc.dart';
import 'package:breaking_project/business_logic/AllTechniciansCubiit/alltechnisian_states.dart';
import 'package:breaking_project/data/models/technisians_model.dart';
import 'package:breaking_project/data/repository/technicians_repository.dart';

class AlltechnisianCubit extends Cubit<AlltechnisiansStates> {
  AlltechnisianCubit(this.techniciansRepository)
      : super(AlltechnisiansInitial());

  final TechniciansRepository techniciansRepository;
  late List<RTechData> technicians = [];

  Future<List<RTechData>> getAlltechnisians({
    String? search,
    double? rating,
    String? jobCategoryId,
  }) async {
    techniciansRepository
        .getAlltechnicians(
            search: search, rating: rating, jobCategoryId: jobCategoryId)
        .then((thetechnisians) {
      emit(AllAlltechnisiansLoaded(technicians: thetechnisians));
      technicians = thetechnisians;
    });
    return technicians;
  }
}
