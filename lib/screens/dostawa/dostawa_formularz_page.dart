import 'package:flutter/material.dart';
import '../../models/dostawa.dart';
import '../../services/magazyn_service.dart';
import '../../services/dostawa_service.dart';
import '../../models/product.dart';

class DostawaFormularzPage extends StatefulWidget {
  final String kategoria;
  final String lokalizacja;
  final String login;
  final String rola;

  const DostawaFormularzPage({
    super.key,
    required this.kategoria,
    required this.lokalizacja,
    required this.login,
    required this.rola,
  });

  @override
  State<DostawaFormularzPage> createState() => _DostawaFormularzPageState();
}

class _DostawaFormularzPageState extends State<DostawaFormularzPage> {
  @override
  void initState() {
    super.initState();
    _magazynService.pobierzProduktyZChmury(widget.lokalizacja);
  }
  final MagazynService _magazynService = MagazynService();
  final DostawaService _dostawaService = DostawaService();

  final Map<String, int> _ilosci = {};

  @override
  Widget build(BuildContext context) {
    final produkty = _magazynService.getProduktyDlaKategoriiILokalizacji(
      widget.kategoria,
      widget.lokalizacja,
    );

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
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                'Dostawa – ${widget.kategoria}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD2D4C8),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ValueListenableBuilder<List<Product>>(
                  valueListenable: _magazynService.produktyNotifier,
                  builder: (context, produkty, _) {
                    final widoczne = produkty
                        .where((p) =>
                    p.kategoria == widget.kategoria &&
                        p.lokalizacja == widget.lokalizacja)
                        .toList();

                    if (widoczne.isEmpty) {
                      return const Center(
                        child: Text(
                          'Brak produktów w tej kategorii',
                          style: TextStyle(color: Colors.white70),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: widoczne.length,
                      itemBuilder: (context, index) {
                        final produkt = widoczne[index];
                        final ilosc = _ilosci[produkt.nazwa] ?? 0;

                        return ListTile(
                          title: Text(produkt.nazwa, style: const TextStyle(color: Colors.white)),
                          subtitle: Text('Ilość: ${produkt.ilosc}', style: const TextStyle(color: Colors.white70)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove, color: Colors.white),
                                onPressed: () {
                                  setState(() {
                                    _ilosci[produkt.nazwa] = (ilosc - 1).clamp(0, 999);
                                  });
                                },
                              ),
                              Text('$ilosc', style: const TextStyle(color: Colors.white)),
                              IconButton(
                                icon: const Icon(Icons.add, color: Colors.white),
                                onPressed: () {
                                  setState(() {
                                    _ilosci[produkt.nazwa] = ilosc + 1;
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('Zatwierdź dostawę'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF725E54),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _zatwierdzDostawe,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _zatwierdzDostawe() async {
    final List<Dostawa> zapisane = [];

    for (var entry in _ilosci.entries) {
      final nazwa = entry.key;
      final ilosc = entry.value;

      if (ilosc > 0) {
        final error = await _dostawaService.zatwierdzDostawe(
          nazwaProduktu: nazwa,
          ilosc: ilosc,
          kategoria: widget.kategoria,
          lokalizacja: widget.lokalizacja,
          uzytkownik: widget.login,
        );

        if (error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ Błąd dla "$nazwa": $error'),
              backgroundColor: Colors.red,
            ),
          );
          return; // przerywamy na pierwszym błędzie
        }

        zapisane.add(
          Dostawa(
            nazwaProduktu: nazwa,
            kategoria: widget.kategoria,
            lokalizacja: widget.lokalizacja,
            ilosc: ilosc,
            data: DateTime.now(),
          ),
        );
      }
    }

    for (var d in zapisane) {
      await _dostawaService.dodajDostawe(d); // zapis do Hive jeśli chcesz zachować historię lokalnie
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Dostawa zapisana i magazyn zaktualizowany'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

}
