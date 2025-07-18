import '../models/sprzedaz_entry.dart';

class SprzedazService {
  static final SprzedazService _instance = SprzedazService._internal();
  factory SprzedazService() => _instance;
  SprzedazService._internal();

  final List<SprzedazEntry> _historia = [];

  void dodaj(String nazwa, int ilosc, String lokalizacja) {
    _historia.add(SprzedazEntry(
      nazwaProduktu: nazwa,
      ilosc: ilosc,
      data: DateTime.now(),
      lokalizacja: lokalizacja,
    ));
  }

  List<SprzedazEntry> topZOkresu({
    required Duration okres,
    required String lokalizacja,
    int limit = 10,
  }) {
    final teraz = DateTime.now();
    final odKiedy = teraz.subtract(okres);
    final mapa = <String, int>{};

    for (final wpis in _historia) {
      if (wpis.data.isAfter(odKiedy) && wpis.lokalizacja == lokalizacja) {
        mapa[wpis.nazwaProduktu] =
            (mapa[wpis.nazwaProduktu] ?? 0) + wpis.ilosc;
      }
    }

    final posortowane = mapa.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return posortowane.take(limit).map((e) {
      return SprzedazEntry(
        nazwaProduktu: e.key,
        ilosc: e.value,
        data: DateTime.now(),
        lokalizacja: lokalizacja,
      );
    }).toList();
  }

  List<SprzedazEntry> topWszystko({
    required String lokalizacja,
    int limit = 10,
  }) {
    final mapa = <String, int>{};

    for (final wpis in _historia) {
      if (wpis.lokalizacja == lokalizacja) {
        mapa[wpis.nazwaProduktu] =
            (mapa[wpis.nazwaProduktu] ?? 0) + wpis.ilosc;
      }
    }

    final posortowane = mapa.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return posortowane.take(limit).map((e) {
      return SprzedazEntry(
        nazwaProduktu: e.key,
        ilosc: e.value,
        data: DateTime.now(),
        lokalizacja: lokalizacja,
      );
    }).toList();
  }
}
