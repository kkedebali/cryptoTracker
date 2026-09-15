import 'package:cryptotrack/domain/entities/cryptoEntity.dart';

abstract class CryptoRepoAbstract {
  Future<List<CryptoEntity>> getCryptos(String currency);
}
