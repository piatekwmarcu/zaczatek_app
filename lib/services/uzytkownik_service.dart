import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/uzytkownik.dart';

class UzytkownikService {
  final _supabase = Supabase.instance.client;

  Future<void> dodajUzytkownika(Uzytkownik u) async {
    await _supabase.from('uzytkownicy').insert(u.toMap());
  }

  Future<void> usunUzytkownika(String login) async {
    await _supabase.from('uzytkownicy').delete().eq('login', login);
  }

  Future<List<Uzytkownik>> pobierzUzytkownikow() async {
    final res = await _supabase.from('uzytkownicy').select();
    return (res as List).map((e) => Uzytkownik.fromMap(Map<String, dynamic>.from(e))).toList();
  }

  Future<Uzytkownik?> znajdz(String login, String haslo) async {
    final res = await _supabase
        .from('uzytkownicy')
        .select()
        .eq('login', login)
        .eq('haslo', haslo)
        .maybeSingle();

    if (res == null) return null;
    return Uzytkownik.fromMap(Map<String, dynamic>.from(res));
  }
}
