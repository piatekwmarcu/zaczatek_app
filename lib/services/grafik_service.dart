import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/grafik_model.dart';

class GrafikService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> dodajGrafik(GrafikTygodniowy grafik) async {
    await _supabase.from('grafik').insert(grafik.toMap());
  }

  Future<void> usunGrafik(String id) async {
    await _supabase.from('grafik').delete().eq('id', id);
  }

  Future<List<GrafikTygodniowy>> pobierzGrafiki() async {
    final res = await _supabase
        .from('grafik')
        .select()
        .order('data_dodania', ascending: false);
    return (res as List)
        .map((e) => GrafikTygodniowy.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }
}
