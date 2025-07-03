abstract class WalletTopupStates {}

class WalletTopupInitial extends WalletTopupStates {}

class WalletTopupLoading extends WalletTopupStates {}

class WalletTopupSuccess extends WalletTopupStates {}

class WalletTopupError extends WalletTopupStates {
  final String message;
  WalletTopupError(this.message);
}
