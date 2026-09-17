import 'package:cryptotrack/domain/abstractRepo.dart';
import 'package:cryptotrack/presentation/Bloc/states.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// <----- Event -----> //
abstract class CryptoEvent {}

class FetchCryptosEvent extends CryptoEvent {
  final String currency;

  FetchCryptosEvent({this.currency = 'try'});
}

class FetchCryptoInfos extends CryptoEvent {
  final String code;

  FetchCryptoInfos({this.code = 'BTC'});
}

// <----- Bloc -----> // // -- Usecase yok 
class CryptoBloc extends Bloc<CryptoEvent, CryptoState> {
  final CryptoRepoAbstract repository;

  CryptoBloc({required this.repository}) : super(CryptoInitial()) {
    on<FetchCryptosEvent>((event, emit) async {
      emit(CryptoLoadingState());
      try {
        final cryptoList = await repository.getCryptos(event.currency);
        emit(CryptoLoadedState(cryptoList));
      } catch (e) {
        String errorMessage = 'Beklenmeyen bir hata oluştu.';

        if (e is DioException) {
          switch (e.type) {
            case DioExceptionType.connectionTimeout:
            case DioExceptionType.sendTimeout:
            case DioExceptionType.receiveTimeout:
              errorMessage =
                  'Bağlantı zaman aşımına uğradı. Lütfen internetinizi kontrol edin.';
              break;
            case DioExceptionType.connectionError:
              errorMessage = 'İnternet bağlantınız koptu.';
              break;
            case DioExceptionType.badResponse:
              final statusCode = e.response?.statusCode;
              if (statusCode == 400) {
                errorMessage =
                    'Bizim tarafımızda sorun oluştu (Hatalı parametre).';
              } else if (statusCode == 404) {
                errorMessage = 'Aradığınız kaynak bulunamadı.';
              } else if (statusCode != null && statusCode >= 500) {
                errorMessage =
                    'Sunucu kaynaklı bir sorun oluştu. Lütfen daha sonra tekrar deneyin.';
              } else {
                errorMessage = 'Sunucu hatası (Kod: $statusCode)';
              }
              break;
            default:
              errorMessage = 'Bir ağ hatası oluştu.';
              break;
          }
        } else {
          errorMessage = e.toString();
        }
        emit(CryptoErrorState(errorMessage));
      }
    });

    on<FetchCryptoInfos>((event, emit) async {
      emit(CryptoLoadingState());
      try {

      } catch (e) {
        String errorMessage = 'Bu kriptoya ait bir hata oluştu!';
        emit(CryptoErrorState(errorMessage));
      }
    });
  }
}
