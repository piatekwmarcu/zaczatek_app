import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/produkt_do_zamowienia.dart';

class ZamowienieService {
  final _supabase = Supabase.instance.client;

  Future<void> dodajZamowienie(ProduktDoZamowienia produkt) async {
    await _supabase.from('zamowienia').insert(produkt.toMap());
  }

  Future<List<ProduktDoZamowienia>> pobierzZamowienia() async {
    final response = await _supabase
        .from('zamowienia')
        .select()
        .order('data_zlozenia', ascending: false);

    return (response as List).map((e) =>
        ProduktDoZamowienia.fromMap(Map<String, dynamic>.from(e))).toList();
  }

  Future<void> usunZamowieniaStarszeNiz7Dni() async {
    final tydzienTemu = DateTime.now().subtract(const Duration(days: 7)).toIso8601String();

    await _supabase
        .from('zamowienia')
        .delete()
        .lt('data_zlozenia', tydzienTemu);
  }

}
