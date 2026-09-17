import 'package:cryptotrack/domain/entities/cryptoEntity.dart';

abstract class CryptoRepoAbstract {
  Future<List<CryptoEntity>> getCryptos(String currency);

  Future<List<CryptoEntity>> filteredCryptos(
    List<CryptoEntity> cryptos,
    String code,
  );
}
