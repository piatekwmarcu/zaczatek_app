import 'package:flutter/material.dart';
import '../../models/produkt_do_zamowienia.dart';
import '../../services/zamowienie_service.dart';

class ZamowieniaDoZlozeniaPage extends StatefulWidget {
  const ZamowieniaDoZlozeniaPage({super.key});

  @override
  State<ZamowieniaDoZlozeniaPage> createState() => _ZamowieniaDoZlozeniaPageState();
}

class _ZamowieniaDoZlozeniaPageState extends State<ZamowieniaDoZlozeniaPage> {
  final Map<String, List<ProduktDoZamowienia>> _zamowieniaPoDacie = {};

  @override
  @override
  void initState() {
    super.initState();
    _usunStareZamowienia();
    _wczytajZamowienia();
  }

  void _usunStareZamowienia() async {
    await ZamowienieService().usunZamowieniaStarszeNiz7Dni();
  }

  Future<void> _wczytajZamowienia() async {
    final produkty = await ZamowienieService().pobierzZamowienia();

    // Sortujemy od najnowszych
    produkty.sort((a, b) => b.dataZlozenia.compareTo(a.dataZlozenia));

    _zamowieniaPoDacie.clear();

    for (var produkt in produkty) {
      // KLUCZ: data + lokal
      final dataLokal = '${produkt.dataZlozenia.toIso8601String().substring(0, 10)} • ${produkt.lokal}';

      _zamowieniaPoDacie.putIfAbsent(dataLokal, () => []).add(produkt);
    }

    setState(() {});
  }


  Map<String, List<ProduktDoZamowienia>> _grupujPoDostawcy(List<ProduktDoZamowienia> produkty) {
    final Map<String, List<ProduktDoZamowienia>> wynik = {};
    for (var p in produkty) {
      wynik.putIfAbsent(p.dostawca, () => []).add(p);
    }
    return wynik;
  }

  void _scalZamowienia(List<ProduktDoZamowienia> produkty) {
    final Map<String, ProduktDoZamowienia> scalone = {};

    for (var p in produkty) {
      final klucz = '${p.nazwa}_${p.dostawca}';
      if (scalone.containsKey(klucz)) {
        scalone[klucz]!.ilosc += p.ilosc;
      } else {
        scalone[klucz] = ProduktDoZamowienia(
          nazwa: p.nazwa,
          ilosc: p.ilosc,
          dostawca: p.dostawca,
          kategoria: p.kategoria,
          lokal: 'SŁAWKA + RUCZAJ',
          pracownik: 'scalone',
          komentarz: null,
          dataZlozenia: p.dataZlozenia,
          czasZlozenia: p.czasZlozenia, // ← DODAJ TO
        );

      }
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Scalone zamówienie'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: scalone.values.map((p) {
              return ListTile(
                title: Text('${p.nazwa}'),
                subtitle: Text('Dostawca: ${p.dostawca}'),
                trailing: Text('${p.ilosc} szt.'),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Zamknij'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/zaczatek.jpg'),
            fit: BoxFit.cover,
            opacity: 0.6,
          ),
        ),
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: _wczytajZamowienia,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Zamówienia od pracowników',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD2D4C8),
                  ),
                ),
                const SizedBox(height: 20),
                ..._zamowieniaPoDacie.entries.map((entry) {
                  final data = entry.key;
                  final produkty = entry.value;
                  final pogrupowane = _grupujPoDostawcy(produkty);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        '📅 $data',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFD2D4C8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...pogrupowane.entries.map((e) {
                        final dostawca = e.key;
                        final lista = e.value;

                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF725E54),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '🧾 $dostawca',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFD2D4C8),
                                  ),
                                ),
                                ...lista.map((p) => ListTile(
                                  title: Text(
                                    p.nazwa,
                                    style: const TextStyle(color: Color(0xFFD2D4C8)),
                                  ),
                                  subtitle: Text(
                                    '${p.ilosc} szt. – ${p.lokal}, ${p.pracownik}\n${p.komentarz ?? ''}',
                                    style: const TextStyle(color: Color(0xFFD2D4C8)),
                                  ),
                                )),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: 8),
                      Center(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.merge_type),
                          label: const Text('Scal zamówienia'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF093824),
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () => _scalZamowienia(produkty),
                        ),
                      ),
                      const Divider(color: Colors.white54),
                    ],
                  );
                }),
              ],
            ),
          )

        ),
      ),
    );
  }
}
