class Product {
  final String nazwa;
  final String kategoria;
  final String lokalizacja;
  int ilosc;

  Product({
    required this.nazwa,
    required this.kategoria,
    required this.lokalizacja,
    required this.ilosc,
  });

  @override
  String toString() {
    return '$nazwa ($kategoria - $lokalizacja): $ilosc';
  }

  Product copyWith({
    String? nazwa,
    String? kategoria,
    String? lokalizacja,
    int? ilosc,
  }) {
    return Product(
      nazwa: nazwa ?? this.nazwa,
      kategoria: kategoria ?? this.kategoria,
      lokalizacja: lokalizacja ?? this.lokalizacja,
      ilosc: ilosc ?? this.ilosc,
    );
  }

  /// 🔽 Dodaj to ⬇️
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      nazwa: map['nazwa'] ?? '',
      kategoria: map['kategoria'] ?? '',
      lokalizacja: map['lokalizacja'] ?? '',
      ilosc: map['ilosc'] is int ? map['ilosc'] : int.tryParse(map['ilosc'].toString()) ?? 0,
    );
  }

  /// 🔼 Dodaj to ⬆️
  Map<String, dynamic> toMap() {
    return {
      'nazwa': nazwa,
      'kategoria': kategoria,
      'lokalizacja': lokalizacja,
      'ilosc': ilosc,
    };
  }
}
