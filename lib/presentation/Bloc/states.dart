// <----- State -----> //
import 'package:cryptotrack/domain/entities/cryptoEntity.dart';

abstract class CryptoState {}

class CryptoInitial extends CryptoState {}

class CryptoLoadingState extends CryptoState {}

class CryptoLoadedState extends CryptoState {
  final List<CryptoEntity> cryptos;
  final List<String> favorites;

  CryptoLoadedState(this.cryptos, {this.favorites = const []});

  CryptoLoadedState copyWith({
    List<CryptoEntity>? cryptos,
    List<String>? favorites,
  }) {
    return CryptoLoadedState(
      cryptos ?? this.cryptos,
      favorites: favorites ?? this.favorites,
    );
  }
}

class FavoritesLoadedState extends CryptoState {
  final List<String> favorites;
  FavoritesLoadedState(this.favorites);
}

class CryptoErrorState extends CryptoState {
  final String message;
  CryptoErrorState(this.message);
}

class FavoritesErrorState extends CryptoState {
  final String message;

  FavoritesErrorState({required this.message});
}
