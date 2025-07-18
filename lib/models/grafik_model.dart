import 'package:hive/hive.dart';

part 'grafik_model.g.dart';

// === GRAFIK PRACOWNIK ===
@HiveType(typeId: 13)
class GrafikPracownik {
  @HiveField(0)
  String imie;

  @HiveField(1)
  String godziny;

  @HiveField(2)
  String lokal;

  GrafikPracownik({
    required this.imie,
    required this.godziny,
    required this.lokal,
  });

  Map<String, dynamic> toMap() {
    return {
      'imie': imie,
      'godziny': godziny,
      'lokal': lokal,
    };
  }

  factory GrafikPracownik.fromMap(Map<String, dynamic> map) {
    return GrafikPracownik(
      imie: map['imie'] ?? '',
      godziny: map['godziny'] ?? '',
      lokal: map['lokal'] ?? '',
    );
  }
}

// === GRAFIK TYGODNIOWY ===
@HiveType(typeId: 12)
class GrafikTygodniowy extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String tydzien;

  @HiveField(2)
  final Map<String, Map<String, GrafikPracownik>> dni;

  @HiveField(3)
  final DateTime dataDodania;

  GrafikTygodniowy({
    required this.id,
    required this.tydzien,
    required this.dni,
    required this.dataDodania,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tydzien': tydzien,
      'dni': dni.map((key, value) => MapEntry(key, value.map((k, v) => MapEntry(k, v.toMap())))),
      'data_dodania': dataDodania.toIso8601String(),
    };
  }

  factory GrafikTygodniowy.fromMap(Map<String, dynamic> map) {
    return GrafikTygodniowy(
      id: map['id'],
      tydzien: map['tydzien'],
      dni: Map<String, Map<String, GrafikPracownik>>.from(
        (map['dni'] as Map).map((dayKey, value) => MapEntry(
          dayKey as String,
          Map<String, GrafikPracownik>.from(
            (value as Map).map((personKey, inner) => MapEntry(
              personKey as String,
              GrafikPracownik.fromMap(Map<String, dynamic>.from(inner)),
            )),
          ),
        )),
      ),
      dataDodania: DateTime.parse(map['data_dodania']),
    );
  }
}
