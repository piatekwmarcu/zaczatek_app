import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/dostawa.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DostawaService {
  static const String _boxName = 'dostawy';
  final ValueNotifier<List<Dostawa>> dostawyNotifier = ValueNotifier([]);
  final List<Dostawa> _historia = [];
  DostawaService() {
    _wczytajDostawy();
  }

  Future<void> _wczytajDostawy() async {
    final box = await Hive.openBox(_boxName);
    final lista = box.values.map((e) => Dostawa.fromMap(Map<String, dynamic>.from(e))).toList();
    dostawyNotifier.value = lista;
  }

  Future<void> dodajDostawe(Dostawa dostawa) async {
    final box = await Hive.openBox(_boxName);
    await box.add(dostawa.toMap());
    dostawyNotifier.value = [...dostawyNotifier.value, dostawa];
  }

  List<Dostawa> getDostawyDlaLokalizacji(String lokalizacja) {
    return dostawyNotifier.value
        .where((d) => d.lokalizacja.toLowerCase() == lokalizacja.toLowerCase())
        .toList()
      ..sort((a, b) => b.data.compareTo(a.data)); // od najnowszych
  }

  Future<void> wyczysc() async {
    final box = await Hive.openBox(_boxName);
    await box.clear();
    dostawyNotifier.value = [];
  }

  Future<String?> zatwierdzDostawe({
    required String nazwaProduktu,
    required int ilosc,
    required String kategoria,
    required String lokalizacja,
    required String uzytkownik,
  }) async {
    final supabase = Supabase.instance.client;

    try {
      // 1. Zapisz dostawę do tabeli "dostawy"
      await supabase.from('dostawy').insert({
        'nazwa_produktu': nazwaProduktu,
        'ilosc': ilosc,
        'kategoria': kategoria,
        'lokalizacja': lokalizacja,
        'data_dostawy': DateTime.now().toIso8601String(),
        'uzytkownik': uzytkownik,
      });

      // 2. Sprawdź, czy produkt istnieje w magazynie
      final existing = await supabase
          .from('magazyn')
          .select()
          .eq('nazwa', nazwaProduktu)
          .eq('lokalizacja', lokalizacja)
          .maybeSingle();

      int nowaIlosc = ilosc;
      if (existing != null && existing['ilosc'] != null) {
        nowaIlosc += existing['ilosc'] as int;
      }

      // 3. Zaktualizuj stan magazynu (lub dodaj jeśli nie istnieje)
      await supabase.from('magazyn').upsert({
        'nazwa': nazwaProduktu,
        'ilosc': nowaIlosc,
        'lokalizacja': lokalizacja,
        'kategoria': kategoria,
      }, onConflict: 'nazwa,lokalizacja');

      return null; // wszystko OK
    } catch (e) {
      return e.toString(); // zwróć błąd
    }
  }

  List<Dostawa> getHistoria() {
    return _historia;
  }
}
