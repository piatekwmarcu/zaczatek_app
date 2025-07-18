// Zaktualizowany model ogloszenia.dart
import 'package:hive/hive.dart';

part 'ogloszenie.g.dart';

@HiveType(typeId: 7)
class Ogloszenie extends HiveObject {
  String? id; // <--- to dodajesz

  @HiveField(0)
  String tresc;

  @HiveField(1)
  DateTime dataDodania;

  @HiveField(2)
  int serduszka;

  @HiveField(3)
  int lapkiWGore;

  @HiveField(4)
  int lapkiWDol;

  @HiveField(5)
  String autor;

  @HiveField(6)
  List<String> przeczytanePrzez = [];

  @HiveField(7)
  List<Map<String, dynamic>> komentarze;

  Ogloszenie({
    this.id, // <--- teraz może być null
    required this.tresc,
    required this.dataDodania,
    this.serduszka = 0,
    this.lapkiWGore = 0,
    this.lapkiWDol = 0,
    required this.autor,
    this.przeczytanePrzez = const [],
    this.komentarze = const [],
  });

  factory Ogloszenie.fromMap(Map<String, dynamic> map) {
    return Ogloszenie(
      id: map['id']?.toString(),
      tresc: map['tresc'],
      dataDodania: DateTime.parse(map['data_dodania']),
      serduszka: map['serduszka'] ?? 0,
      lapkiWGore: map['lapki_w_gore'] ?? 0,
      lapkiWDol: map['lapki_w_dol'] ?? 0,
      autor: map['autor'],
      przeczytanePrzez: List<String>.from(map['przeczytane_przez'] ?? []),
      komentarze: List<Map<String, dynamic>>.from(map['komentarze'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tresc': tresc,
      'data_dodania': dataDodania.toIso8601String(),
      'serduszka': serduszka,
      'lapki_w_gore': lapkiWGore,
      'lapki_w_dol': lapkiWDol,
      'autor': autor,
      'przeczytane_przez': przeczytanePrzez,
      'komentarze': komentarze,
    };
  }
}
