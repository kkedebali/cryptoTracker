import 'package:cryptotrack/domain/entities/cryptoEntity.dart';

abstract class CryptoRepoAbstract {
  Future<List<CryptoEntity>> getCryptos(String currency);

  List<CryptoEntity> filteredCryptos(
    List<CryptoEntity> cryptos,
    String code,
  );

  Future<List<String>> getFavorites();
  Future<void> toggleFavorites(String code);
}
