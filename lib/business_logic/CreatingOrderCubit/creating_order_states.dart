
abstract class CreatingOrderStates {}

class CreatingOrderInitial extends CreatingOrderStates {}

class CreatingOrderLoading extends CreatingOrderStates {}

class CreatingOrderSuccess extends CreatingOrderStates {
}

class CreatingOrderError extends CreatingOrderStates {
  final String message;
  CreatingOrderError(this.message);
}



