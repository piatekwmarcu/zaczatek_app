import 'package:hive/hive.dart';

part 'uzytkownik.g.dart';

@HiveType(typeId: 1)
class Uzytkownik extends HiveObject {
  @HiveField(0)
  String login;

  @HiveField(1)
  String haslo;

  @HiveField(2)
  String rola; // 'ADMIN' lub 'PRACOWNIK'

  Uzytkownik({
    required this.login,
    required this.haslo,
    required this.rola,
  });

  Map<String, dynamic> toMap() {
    return {
      'login': login,
      'haslo': haslo,
      'rola': rola,
    };
  }

  factory Uzytkownik.fromMap(Map<String, dynamic> map) {
    return Uzytkownik(
      login: map['login'] ?? '',
      haslo: map['haslo'] ?? '',
      rola: map['rola'] ?? 'PRACOWNIK',
    );
  }

}
