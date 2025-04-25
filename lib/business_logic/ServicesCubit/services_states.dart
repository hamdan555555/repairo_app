part of 'services_cubit.dart';

sealed class ServicesStates {}

final class ServicesInitial extends ServicesStates {}

final class ServicesFailed extends ServicesStates {}

final class ServicesLoaded extends ServicesStates {
  final List<Services> services;

  ServicesLoaded({required this.services});
}
