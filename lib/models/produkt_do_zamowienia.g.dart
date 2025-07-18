// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'produkt_do_zamowienia.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProduktDoZamowieniaAdapter extends TypeAdapter<ProduktDoZamowienia> {
  @override
  final int typeId = 0;

  @override
  ProduktDoZamowienia read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProduktDoZamowienia(
      nazwa: fields[0] as String,
      ilosc: fields[1] as int,
      dostawca: fields[2] as String,
      kategoria: fields[3] as String,
      lokal: fields[4] as String,
      pracownik: fields[5] as String,
      komentarz: fields[6] as String?,
      dataZlozenia: fields[7] as DateTime,
      czasZlozenia: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ProduktDoZamowienia obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.nazwa)
      ..writeByte(1)
      ..write(obj.ilosc)
      ..writeByte(2)
      ..write(obj.dostawca)
      ..writeByte(3)
      ..write(obj.kategoria)
      ..writeByte(4)
      ..write(obj.lokal)
      ..writeByte(5)
      ..write(obj.pracownik)
      ..writeByte(6)
      ..write(obj.komentarz)
      ..writeByte(7)
      ..write(obj.dataZlozenia)
      ..writeByte(8)
      ..write(obj.czasZlozenia);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProduktDoZamowieniaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
