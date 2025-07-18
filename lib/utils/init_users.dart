import '../models/uzytkownik.dart';
import '../services/uzytkownik_service.dart';

Future<void> dodajDomyslnychUzytkownikowDoSupabase() async {
  final lista = [
    Uzytkownik(login: 'emka', haslo: 'zaczateklove', rola: 'ADMIN'),
    Uzytkownik(login: 'ksobczyk', haslo: 'kondzio', rola: 'PRACOWNIK'),
    Uzytkownik(login: 'msroka', haslo: 'madzia', rola: 'PRACOWNIK'),
    Uzytkownik(login: 'pkukla', haslo: 'lysy', rola: 'PRACOWNIK'),
    Uzytkownik(login: 'pkazimierczak', haslo: 'sabeuszp', rola: 'PRACOWNIK'),
    Uzytkownik(login: 'adas', haslo: 'kochamcb', rola: 'ADMIN'),
    Uzytkownik(login: 'dgronek', haslo: 'donatella', rola: 'PRACOWNIK'),
    Uzytkownik(login: 'mniemiec', haslo: 'niemcu', rola: 'PRACOWNIK'),
    Uzytkownik(login: 'wtarasowski', haslo: 'wlodek', rola: 'PRACOWNIK'),
  ];

  final istniejacy = await UzytkownikService().pobierzUzytkownikow();
  final istniejaceLoginy = istniejacy.map((e) => e.login.toLowerCase()).toSet();

  for (var u in lista) {
  if (!istniejaceLoginy.contains(u.login.toLowerCase())) {
  await UzytkownikService().dodajUzytkownika(u);
  }
  }
}
