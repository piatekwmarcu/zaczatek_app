// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'uzytkownik.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UzytkownikAdapter extends TypeAdapter<Uzytkownik> {
  @override
  final int typeId = 1;

  @override
  Uzytkownik read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Uzytkownik(
      login: fields[0] as String,
      haslo: fields[1] as String,
      rola: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Uzytkownik obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.login)
      ..writeByte(1)
      ..write(obj.haslo)
      ..writeByte(2)
      ..write(obj.rola);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UzytkownikAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
