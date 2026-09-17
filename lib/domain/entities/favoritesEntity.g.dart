// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favoritesEntity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoritesEntityAdapter extends TypeAdapter<FavoritesEntity> {
  @override
  final int typeId = 0;

  @override
  FavoritesEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoritesEntity(
      code: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FavoritesEntity obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.code);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoritesEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
