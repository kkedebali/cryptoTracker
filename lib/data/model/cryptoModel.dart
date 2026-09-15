import 'package:cryptotrack/domain/entities/cryptoEntity.dart';

class CryptoModel extends CryptoEntity {
  CryptoModel({
    required super.image,
    required super.name,
    required super.code,
    required super.price,
    required super.change,
  });
  factory CryptoModel.fromJson(Map<String, dynamic> json) {
    return CryptoModel(
      image: json['image'] ?? '',
      name: json['name'],
      code: json['symbol']?.toString().toUpperCase(),
      price: (json['current_price'] as num?)?.toDouble(),
      change: (json['price_change_percentage_24h'] as num?)?.toDouble(),
    );
  }
}
