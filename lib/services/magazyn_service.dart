import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product.dart';

class MagazynService {
  static final MagazynService _instance = MagazynService._internal();
  factory MagazynService({String rola = 'PRACOWNIK'}) {
    _instance.rola = rola;
    return _instance;
  }

  MagazynService._internal();

  String rola = 'PRACOWNIK';

  final ValueNotifier<List<Product>> produktyNotifier = ValueNotifier<List<Product>>([]);

  Future<void> pobierzProduktyZChmury(String lokalizacja) async {
    final supabase = Supabase.instance.client;

    final response = await supabase
        .from('magazyn')
        .select()
        .eq('lokalizacja', lokalizacja);

    final List<Product> produkty = (response as List)
        .map((json) => Product.fromMap(json))
        .toList();

    produktyNotifier.value = produkty;
  }

  List<Product> getProduktyDlaKategoriiILokalizacji(String kategoria, String lokalizacja) {
    return produktyNotifier.value
        .where((p) => p.kategoria == kategoria && p.lokalizacja == lokalizacja)
        .toList();
  }

  void aktualizujIlosc(Product produkt, int nowaIlosc) {
    produkt.ilosc = nowaIlosc;
    produktyNotifier.notifyListeners();
  }

  Product _znajdzProdukt(String nazwa, String kategoria, String lokalizacja) {
    return produktyNotifier.value.firstWhere(
          (p) =>
      p.nazwa == nazwa &&
          p.kategoria == kategoria &&
          p.lokalizacja == lokalizacja,
      orElse: () => throw Exception('Produkt nie znaleziony'),
    );
  }

  Future<void> dodajProdukt(Product produkt) async {
    final supabase = Supabase.instance.client;

    await supabase.from('magazyn').insert(produkt.toMap());

    await pobierzProduktyZChmury(produkt.lokalizacja);
  }

  Future<void> usunProdukt(Product produkt) async {
    final supabase = Supabase.instance.client;

    await supabase
        .from('magazyn')
        .delete()
        .match({'nazwa': produkt.nazwa, 'lokalizacja': produkt.lokalizacja});

    await pobierzProduktyZChmury(produkt.lokalizacja);
  }

  Future<void> odejmijZeStanu(String nazwa, String kategoria, String lokalizacja, int ile) async {
    final supabase = Supabase.instance.client;

    final existing = await supabase
        .from('magazyn')
        .select()
        .eq('nazwa', nazwa)
        .eq('lokalizacja', lokalizacja)
        .maybeSingle();

    if (existing == null) {
      print('❌ Nie znaleziono produktu do odjęcia');
      return;
    }

    int aktualnaIlosc = existing['ilosc'] ?? 0;
    int nowaIlosc = (aktualnaIlosc - ile).clamp(0, 999);

    await supabase.from('magazyn').upsert({
      'nazwa': nazwa,
      'kategoria': kategoria,
      'lokalizacja': lokalizacja,
      'ilosc': nowaIlosc,
    }, onConflict: 'nazwa,lokalizacja');

    // odśwież widok
    await pobierzProduktyZChmury(lokalizacja);
  }
}