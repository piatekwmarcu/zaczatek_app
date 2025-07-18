import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/godziny_model.dart';
import 'package:flutter/foundation.dart';

class GodzinyService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<GodzinyPracy>> pobierzWszystkieGodziny() async {
    final response = await _supabase
        .from('godziny')
        .select()
        .order('data', ascending: true);

    return (response as List)
        .map((e) => GodzinyPracy.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<String?> zapiszGodzinePracy({
    required String login,
    required DateTime data,
    required String lokal,
    required String godzinaStart,
    required String godzinaKoniec,
    int? kursy,
    double? kilometry,
  }) async {
    try {
      await _supabase.from('godziny').insert({
        'login': login,
        'data': data.toIso8601String(),
        'lokal': lokal,
        'godzina_start': godzinaStart,
        'godzina_koniec': godzinaKoniec,
        'kursy': kursy,
        'kilometry': kilometry,
      });
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<List<GodzinyPracy>> pobierzGodzinyDlaDnia(DateTime data) async {
    try {
      final response = await _supabase
          .from('godziny')
          .select()
          .eq('data', data.toIso8601String().split('T')[0]);

      final List<GodzinyPracy> wyniki = (response as List).map((item) {
        return GodzinyPracy(
          login: item['login'],
          data: DateTime.parse(item['data']),
          lokal: item['lokal'],
          godzinaStart: item['godzina_start'],
          godzinaKoniec: item['godzina_koniec'],
          kursy: item['kursy'],
          kilometry: item['kilometry']?.toDouble(),
        );
      }).toList();

      return wyniki;
    } catch (e) {
      debugPrint('❌ Błąd pobierania godzin: $e');
      return [];
    }
  }
}
