// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grafik_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GrafikPracownikAdapter extends TypeAdapter<GrafikPracownik> {
  @override
  final int typeId = 13;

  @override
  GrafikPracownik read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GrafikPracownik(
      imie: fields[0] as String,
      godziny: fields[1] as String,
      lokal: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GrafikPracownik obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.imie)
      ..writeByte(1)
      ..write(obj.godziny)
      ..writeByte(2)
      ..write(obj.lokal);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GrafikPracownikAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GrafikTygodniowyAdapter extends TypeAdapter<GrafikTygodniowy> {
  @override
  final int typeId = 12;

  @override
  GrafikTygodniowy read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GrafikTygodniowy(
      id: fields[0] as String,
      tydzien: fields[1] as String,
      dni: (fields[2] as Map).map((dynamic k, dynamic v) =>
          MapEntry(k as String, (v as Map).cast<String, GrafikPracownik>())),
      dataDodania: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, GrafikTygodniowy obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.tydzien)
      ..writeByte(2)
      ..write(obj.dni)
      ..writeByte(3)
      ..write(obj.dataDodania);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GrafikTygodniowyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
