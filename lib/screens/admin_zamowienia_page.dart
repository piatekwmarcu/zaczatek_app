import 'package:flutter/material.dart';
import '../models/produkt_do_zamowienia.dart';
import '../services/zamowienie_service.dart';

enum LokalWidok { wszystkie, slawka, ruczaj }

class AdminZamowieniaPage extends StatefulWidget {
  const AdminZamowieniaPage({super.key});

  @override
  State<AdminZamowieniaPage> createState() => _AdminZamowieniaPageState();
}

class _AdminZamowieniaPageState extends State<AdminZamowieniaPage> {
  bool _pokazSumy = false;
  LokalWidok wybranyWidok = LokalWidok.wszystkie;
  List<ProduktDoZamowienia> wszystkie = [];

  @override
  void initState() {
    super.initState();
    _pobierzZamowienia();
  }

  Future<void> _pobierzZamowienia() async {
    wszystkie = await ZamowienieService().pobierzZamowienia();
    wszystkie.sort((a, b) => b.dataZlozenia.compareTo(a.dataZlozenia));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final produkty = wszystkie.where((p) {
      switch (wybranyWidok) {
        case LokalWidok.slawka:
          return p.lokal.toLowerCase().contains('sławka');
        case LokalWidok.ruczaj:
          return p.lokal.toLowerCase().contains('ruczaj');
        case LokalWidok.wszystkie:
          return true;
      }
    }).toList();

    final Map<String, Map<String, int>> agregacja = {};
    for (var produkt in produkty) {
      agregacja.putIfAbsent(produkt.dostawca, () => {});
      agregacja[produkt.dostawca]![produkt.nazwa] =
          (agregacja[produkt.dostawca]![produkt.nazwa] ?? 0) + produkt.ilosc;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Zamówienia – Admin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Odśwież',
            onPressed: () async {
              await _pobierzZamowienia();
            },
          ),
          IconButton(
            icon: const Icon(Icons.auto_graph),
            tooltip: 'Scal / Zsumuj',
            onPressed: () {
              setState(() {
                _pokazSumy = !_pokazSumy;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: DropdownButton<LokalWidok>(
              value: wybranyWidok,
              items: LokalWidok.values.map((lok) {
                final txt = lok == LokalWidok.wszystkie
                    ? 'Wszystkie lokale'
                    : (lok == LokalWidok.slawka ? 'Sławka' : 'Ruczaj');
                return DropdownMenuItem(
                  value: lok,
                  child: Text(txt),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  wybranyWidok = val!;
                });
              },
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _pobierzZamowienia,
              child: _pokazSumy
                  ? _buildWidokSum(agregacja)
                  : _buildWidokSzczegolowy(produkty),
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildWidokSzczegolowy(List<ProduktDoZamowienia> produkty) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: produkty.length,
      itemBuilder: (context, index) {
        final p = produkty[index];
        return Card(
          child: ListTile(
            title: Text('${p.nazwa} – ${p.ilosc} szt.'),
            subtitle: Text(
              'Lokal: ${p.lokal}, Pracownik: ${p.pracownik}'
                  '${(p.komentarz ?? '').isNotEmpty ? '\nKomentarz: ${p.komentarz}' : ''}',
            ),
            trailing: Text(p.dostawca),
          ),
        );
      },
    );
  }

  Widget _buildWidokSum(Map<String, Map<String, int>> agregacja) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: agregacja.entries.map((entry) {
        final dostawca = entry.key;
        final produkty = entry.value;

        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dostawca: $dostawca',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...produkty.entries.map((e) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(e.key)),
                    Text('${e.value} szt.'),
                  ],
                )),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}