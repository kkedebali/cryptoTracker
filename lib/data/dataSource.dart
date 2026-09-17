import 'package:cryptotrack/data/model/cryptoModel.dart';
import 'package:cryptotrack/domain/abstractRepo.dart';
import 'package:cryptotrack/domain/entities/cryptoEntity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CryptoRepoImpl implements CryptoRepoAbstract {
  final dio = Dio();

  @override
  Future<List<CryptoEntity>> getCryptos(String currency) async {
    try {
      final res = await dio.get(
        'https://api.coingecko.com/api/v3/coins/markets',
        queryParameters: {
          'vs_currency': currency,
          'order': 'market_cap_desc',
          'per_page': '10',
          'page': '1',
          'sparkline': 'false', // Grafik verisi
        },
      );

      if (res.statusCode == 200) {
        debugPrint('Başarili');

        final List data = res.data;
        final cryptos = data.map((json) => CryptoModel.fromJson(json)).toList();

        return cryptos;
      }
    } catch (e) {
      debugPrint('Hata oluştu: $e');
      rethrow;
    }

    return [];
  }

  @override
  Future<List<CryptoEntity>> filteredCryptos(
    List<CryptoEntity> cryptos,
    String search,
  ) async {
    try {
      final filteredCryptos = cryptos.where((cryptos) {
        final ccode = cryptos.code.toString().toLowerCase();
        final cname = cryptos.name.toString().toLowerCase();
        return ccode.contains(search.toLowerCase()) || cname.contains(search.toLowerCase());
      }).toList();

      return Future.value(filteredCryptos);
    } catch (e) {
      debugPrint('Hata oluştu: $e');
      rethrow;
    }
  }
}
