
import 'package:hive_flutter/hive_flutter.dart';

part 'favoritesEntity.g.dart';

@HiveType(typeId: 0)
class FavoritesEntity extends HiveObject{
  FavoritesEntity({required this.code});

  @HiveField(0)
  final String code;

}
