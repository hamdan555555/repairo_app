abstract class CancelOrderStates {}

class CancelOrderInitial extends CancelOrderStates {}

class CancelOrderLoading extends CancelOrderStates {}

class CancelOrderSuccess extends CancelOrderStates {}

class CancelOrderError extends CancelOrderStates {
  final String message;
  CancelOrderError(this.message);
}
