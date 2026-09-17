import 'package:cryptotrack/data/model/cryptoModel.dart';
import 'package:cryptotrack/domain/abstractRepo.dart';
import 'package:cryptotrack/domain/entities/cryptoEntity.dart';
import 'package:cryptotrack/domain/entities/favoritesEntity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
  List<CryptoEntity> filteredCryptos(
    List<CryptoEntity> cryptos,
    String search,
  ) {
    if (search.trim().isEmpty) return cryptos;

    try {
      final query = search.trim().toLowerCase();

      return cryptos.where((crypto) {
        final code = crypto.code.toString().toLowerCase();
        final name = crypto.name.toString().toLowerCase();

        return code.contains(query) || name.contains(query);
      }).toList();
    } catch (e) {
      debugPrint('Filtreleme hatası: $e');
      return cryptos; // Hata durumunda uygulamayı patlatmak yerine orijinal listeyi dönmek daha güvenlidir
    }
  }

  @override
  Future<void> toggleFavorites(String code) async {
    final favoritesBox = Hive.box<FavoritesEntity>('favorites_box');
    final cleanCode = code.toLowerCase().trim();

    if (favoritesBox.containsKey(cleanCode)) {
      await favoritesBox.delete(cleanCode);
    } else {
      await favoritesBox.put(cleanCode, FavoritesEntity(code: cleanCode));
    }
  }

  @override
  Future<List<String>> getFavorites() async {
    final favoritesBox = Hive.box<FavoritesEntity>('favorites_box');

    return favoritesBox.values.map((e) => e.code.toLowerCase().trim()).toList();
  }
}
