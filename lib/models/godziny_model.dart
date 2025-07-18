import 'package:hive/hive.dart';

part 'godziny_model.g.dart';

@HiveType(typeId: 4)
class GodzinyPracy extends HiveObject {
  @HiveField(0)
  String login;


  @HiveField(1)
  DateTime data;

  @HiveField(2)
  String lokal;

  @HiveField(3)
  String godzinaStart;

  @HiveField(4)
  String godzinaKoniec;

  @HiveField(5)
  int? kursy;

  @HiveField(6)
  double? kilometry;

  GodzinyPracy({
    required this.login,
    required this.data,
    required this.lokal,
    required this.godzinaStart,
    required this.godzinaKoniec,
    this.kursy,
    this.kilometry,
  });

  Duration get przepracowanyCzas {
    final start = DateTime(data.year, data.month, data.day,
        int.parse(godzinaStart.split(':')[0]), int.parse(godzinaStart.split(':')[1]));
    final koniec = DateTime(data.year, data.month, data.day,
        int.parse(godzinaKoniec.split(':')[0]), int.parse(godzinaKoniec.split(':')[1]));
    return koniec.difference(start);
  }

  factory GodzinyPracy.fromMap(Map<String, dynamic> map) {
    return GodzinyPracy(
      login: map['login'] ?? '',
      lokal: map['lokal'] ?? '',
      data: DateTime.parse(map['data']),
      godzinaStart: map['godzina_start'] ?? '',
      godzinaKoniec: map['godzina_koniec'] ?? '',
      kursy: map['kursy'],
      kilometry: map['kilometry'],
    );
  }

}
