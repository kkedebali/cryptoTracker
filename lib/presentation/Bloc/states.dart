// <----- State -----> //
import 'package:cryptotrack/domain/entities/cryptoEntity.dart';

abstract class CryptoState {}

class CryptoInitial extends CryptoState {}

class CryptoLoadingState extends CryptoState {}

class CryptoLoadedState extends CryptoState {
  final List<CryptoEntity> cryptos;
  CryptoLoadedState(this.cryptos);
}

class CryptoErrorState extends CryptoState {
  final String message;
  CryptoErrorState(this.message);
}