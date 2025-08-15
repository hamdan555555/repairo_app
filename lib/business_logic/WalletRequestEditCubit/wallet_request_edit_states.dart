abstract class WalletTopupEditStates {}

class WalletTopupEditInitial extends WalletTopupEditStates {}

class WalletTopupEditLoading extends WalletTopupEditStates {}

class WalletTopupEditSuccess extends WalletTopupEditStates {}

class WalletTopupEditError extends WalletTopupEditStates {
  final String message;
  WalletTopupEditError(this.message);
}
