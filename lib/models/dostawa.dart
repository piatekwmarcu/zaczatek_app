class Dostawa {
  final String nazwaProduktu;
  final String kategoria;
  final String lokalizacja;
  final int ilosc;
  final DateTime data;

  Dostawa({
    required this.nazwaProduktu,
    required this.kategoria,
    required this.lokalizacja,
    required this.ilosc,
    required this.data,
  });

  // ZAPISZ do Hive
  Map<String, dynamic> toMap() {
    return {
      'nazwaProduktu': nazwaProduktu,
      'kategoria': kategoria,
      'lokalizacja': lokalizacja,
      'ilosc': ilosc,
      'data': data.toIso8601String(),
    };
  }

  // WCZYTAJ z Hive
  factory Dostawa.fromMap(Map<String, dynamic> map) {
    return Dostawa(
      nazwaProduktu: map['nazwaProduktu'] ?? '',
      kategoria: map['kategoria'] ?? '',
      lokalizacja: map['lokalizacja'] ?? '',
      ilosc: map['ilosc'] ?? 0,
      data: DateTime.parse(map['data']),
    );
  }
}
