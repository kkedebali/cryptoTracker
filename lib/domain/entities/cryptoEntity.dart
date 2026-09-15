class CryptoEntity {
  final String? image;
  final String? name;
  final String? code;
  final double? price;
  final double? change;

  CryptoEntity({
    required this.image,
    required this.name,
    required this.code,
    required this.price,
    required this.change, 
  });
  String get safeImage => image ?? 'Bilinmeyen';
  String get safeName => name ?? 'Bilinmeyen';
  String get safeCode => code ?? '???';
  double get safePrice => price ?? 0;
  double get safeChange => change ?? 0;
}
