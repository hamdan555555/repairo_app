import 'package:breaking_project/data/models/provided_services.dart';

abstract class ProvidedServicesStates {}

class ProvidedServicesInitial extends ProvidedServicesStates {}

class ProvidedServicesLoading extends ProvidedServicesStates {}

class ProvidedServicesSuccess extends ProvidedServicesStates {
  final List<RProvidedServices> providedservices;
  ProvidedServicesSuccess(this.providedservices);
}

class ProvidedServicesError extends ProvidedServicesStates {
  final String message;
  ProvidedServicesError(this.message);
}
