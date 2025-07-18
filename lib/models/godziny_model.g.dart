// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'godziny_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GodzinyPracyAdapter extends TypeAdapter<GodzinyPracy> {
  @override
  final int typeId = 4;

  @override
  GodzinyPracy read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GodzinyPracy(
      login: fields[0] as String,
      data: fields[1] as DateTime,
      lokal: fields[2] as String,
      godzinaStart: fields[3] as String,
      godzinaKoniec: fields[4] as String,
      kursy: fields[5] as int?,
      kilometry: fields[6] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, GodzinyPracy obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.login)
      ..writeByte(1)
      ..write(obj.data)
      ..writeByte(2)
      ..write(obj.lokal)
      ..writeByte(3)
      ..write(obj.godzinaStart)
      ..writeByte(4)
      ..write(obj.godzinaKoniec)
      ..writeByte(5)
      ..write(obj.kursy)
      ..writeByte(6)
      ..write(obj.kilometry);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GodzinyPracyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
