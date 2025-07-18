import 'package:hive/hive.dart';

part 'produkt_do_zamowienia.g.dart';

@HiveType(typeId: 0)
class ProduktDoZamowienia extends HiveObject {
  @HiveField(0)
  String nazwa;

  @HiveField(1)
  int ilosc;

  @HiveField(2)
  String dostawca;

  @HiveField(3)
  String kategoria;

  @HiveField(4)
  String lokal;

  @HiveField(5)
  String pracownik;

  @HiveField(6)
  String? komentarz;

  @HiveField(7)
  DateTime dataZlozenia;


  @HiveField(8)
  String czasZlozenia;

  ProduktDoZamowienia({
    required this.nazwa,
    required this.ilosc,
    required this.dostawca,
    required this.kategoria,
    required this.lokal,
    required this.pracownik,
    this.komentarz,
    required this.dataZlozenia,
    required this.czasZlozenia,
  });

  Map<String, dynamic> toMap() => {
    'nazwa': nazwa,
    'ilosc': ilosc,
    'dostawca': dostawca,
    'kategoria': kategoria,
    'lokal': lokal,
    'pracownik': pracownik,
    'komentarz': komentarz,
    'data_zlozenia': dataZlozenia.toIso8601String(),
    'czas_zlozenia': czasZlozenia,
  };

  factory ProduktDoZamowienia.fromMap(Map<String, dynamic> map) {
    return ProduktDoZamowienia(
      nazwa: map['nazwa'] ?? '',
      ilosc: map['ilosc'] ?? 0,
      dostawca: map['dostawca'] ?? '',
      kategoria: map['kategoria'] ?? '',
      lokal: map['lokal'] ?? '',
      pracownik: map['pracownik'] ?? '',
      komentarz: map['komentarz'],
      dataZlozenia: DateTime.parse(map['data_zlozenia']),
      czasZlozenia: map['czas_zlozenia'] ?? '',
    );
  }


}
