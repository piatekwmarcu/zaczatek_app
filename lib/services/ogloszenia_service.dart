import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/ogloszenie.dart';

class OgloszeniaService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> dodajOgloszenie(Ogloszenie o) async {
    await _supabase.from('ogloszenia').insert({
      'tresc': o.tresc,
      'data_dodania': o.dataDodania.toIso8601String(),
      'autor': o.autor,
      'przeczytane_przez': o.przeczytanePrzez,
      'komentarze': o.komentarze,
      'serduszka': o.serduszka,
      'lapki_w_gore': o.lapkiWGore,
      'lapki_w_dol': o.lapkiWDol,
    });
  }

  Future<List<Ogloszenie>> pobierzOgloszenia() async {
    final res = await _supabase.from('ogloszenia').select().order('data_dodania', ascending: false);
    return (res as List).map((e) => Ogloszenie.fromMap(Map<String, dynamic>.from(e))).toList();
  }

  Future<void> aktualizujOgloszenie(Ogloszenie o) async {
    await _supabase
        .from('ogloszenia')
        .update({
      'przeczytane_przez': o.przeczytanePrzez,
      'komentarze': o.komentarze,
      'serduszka': o.serduszka,
      'lapki_w_gore': o.lapkiWGore,
      'lapki_w_dol': o.lapkiWDol,
    })
        .eq('id', o.id as Object);
  }
}
