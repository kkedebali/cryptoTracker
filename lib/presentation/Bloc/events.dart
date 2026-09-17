import 'package:cryptotrack/domain/abstractRepo.dart';
import 'package:cryptotrack/domain/entities/cryptoEntity.dart';
import 'package:cryptotrack/presentation/Bloc/states.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// <----- Event -----> //
abstract class CryptoEvent {}

class FetchCryptosEvent extends CryptoEvent {
  final String currency;

  FetchCryptosEvent({this.currency = 'try'});
}

class ToggleFavoritesEvent extends CryptoEvent {
  final String code;

  ToggleFavoritesEvent({required this.code});
}

class SearchCrypto extends CryptoEvent {
  final String search;

  SearchCrypto({required this.search});
}

class FetchCryptoInfos extends CryptoEvent {
  final String code;

  FetchCryptoInfos({this.code = 'BTC'});
}

// <----- Bloc -----> // // -- Usecase yok
class CryptoBloc extends Bloc<CryptoEvent, CryptoState> {
  final CryptoRepoAbstract repository;

  List<CryptoEntity> allCryptos = [];
  String searchQuery = '';

  CryptoBloc({required this.repository}) : super(CryptoInitial()) {
    on<FetchCryptosEvent>((event, emit) async {
      if (allCryptos.isEmpty) emit(CryptoLoadingState());
      try {
        allCryptos = await repository.getCryptos(event.currency);
        final favorites = await repository.getFavorites();

        final filtered = searchQuery.isEmpty
            ? allCryptos
            : await repository.filteredCryptos(allCryptos, searchQuery);

        emit(CryptoLoadedState(filtered, favorites: favorites));
      } catch (e) {
        emit(CryptoErrorState(parseErrorMessage(e)));
      }
    });

    on<SearchCrypto>((event, emit) {
      searchQuery = event.search;

      try {
        if (allCryptos.isEmpty) {
          return;
        }
        if (searchQuery.isEmpty) {
          emit(CryptoLoadedState(allCryptos));
        } else {
          final filteredCryptos = repository.filteredCryptos(
            allCryptos,
            searchQuery,
          );
          emit(CryptoLoadedState(filteredCryptos));
        }
      } catch (e) {
        String errorMessage = 'Kripto Arama Hatası!';
        emit(CryptoErrorState(errorMessage));
      }
    });

    on<ToggleFavoritesEvent>((event, emit) async {
      try {
        await repository.toggleFavorites(event.code);
        final updatedFavorites = await repository.getFavorites();

        if (state is CryptoLoadedState) {
          final currentState = state as CryptoLoadedState;
          emit(currentState.copyWith(favorites: updatedFavorites));
        }
      } catch (e) {
        emit(FavoritesErrorState(message: 'Favori güncellenemedi.'));
      }
    });

    on<FetchCryptoInfos>((event, emit) async {
      emit(CryptoLoadingState());
      try {} catch (e) {
        String errorMessage = 'Bu kriptoya ait bir hata oluştu!';
        emit(CryptoErrorState(errorMessage));
      }
    });
  }
}

String parseErrorMessage(dynamic e) {
  if (e is DioException) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Bağlantı zaman aşımına uğradı. Lütfen internetinizi kontrol edin.';
      case DioExceptionType.connectionError:
        return 'İnternet bağlantınız koptu.';
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 400) return 'Hatalı istek (400).';
        if (statusCode == 404) return 'Aradığınız kaynak bulunamadı.';
        if (statusCode != null && statusCode >= 500) {
          return 'Sunucu kaynaklı bir sorun oluştu.';
        }
        return 'Sunucu hatası (Kod: $statusCode)';
      default:
        return 'Bir ağ hatası oluştu.';
    }
  }
  return e.toString();
}
