// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ogloszenie.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OgloszenieAdapter extends TypeAdapter<Ogloszenie> {
  @override
  final int typeId = 7;

  @override
  Ogloszenie read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Ogloszenie(
      tresc: fields[0] as String,
      dataDodania: fields[1] as DateTime,
      serduszka: fields[2] as int,
      lapkiWGore: fields[3] as int,
      lapkiWDol: fields[4] as int,
      autor: fields[5] as String,
      przeczytanePrzez: (fields[6] as List).cast<String>(),
      komentarze: (fields[7] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList(),
    );
  }

  @override
  void write(BinaryWriter writer, Ogloszenie obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.tresc)
      ..writeByte(1)
      ..write(obj.dataDodania)
      ..writeByte(2)
      ..write(obj.serduszka)
      ..writeByte(3)
      ..write(obj.lapkiWGore)
      ..writeByte(4)
      ..write(obj.lapkiWDol)
      ..writeByte(5)
      ..write(obj.autor)
      ..writeByte(6)
      ..write(obj.przeczytanePrzez)
      ..writeByte(7)
      ..write(obj.komentarze);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OgloszenieAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
