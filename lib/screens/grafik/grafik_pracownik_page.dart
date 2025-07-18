import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/grafik_model.dart';
import '../../services/grafik_service.dart';

class GrafikPracownikPage extends StatefulWidget {
  const GrafikPracownikPage({super.key});

  @override
  State<GrafikPracownikPage> createState() => _GrafikPracownikPageState();
}

class _GrafikPracownikPageState extends State<GrafikPracownikPage> {
  List<GrafikTygodniowy> grafiki = [];

  @override
  void initState() {
    super.initState();
    _loadGrafiki();
  }

  Future<void> _loadGrafiki() async {
    final fetched = await GrafikService().pobierzGrafiki();
    setState(() {
      grafiki = fetched..sort((a, b) => b.dataDodania.compareTo(a.dataDodania));
    });
  }

  String aktualnyTydzien() {
    final now = DateTime.now();
    final formatter = DateFormat('dd.MM');
    final pon = now.subtract(Duration(days: now.weekday - 1));
    final niedz = now.add(Duration(days: 7 - now.weekday));
    return '${formatter.format(pon)}–${formatter.format(niedz)}';
  }

  Color kolorTla(String lokal) {
    switch (lokal) {
      case 'Ruczaj':
        return const Color(0xFFF08700);
      case 'Wola Duchacka':
        return const Color(0xFF093824);
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF725E54),
        title: const Text('Grafik pracownika'),
      ),
      body: grafiki.isEmpty
          ? const Center(
        child: Text(
          'Brak dostępnych grafików',
          style: TextStyle(color: Colors.white),
        ),
      )
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextButton(
              onPressed: () {
                final tydzien = aktualnyTydzien();
                final tylkoAktualne = grafiki
                    .where((g) => g.tydzien == tydzien)
                    .toList();
                setState(() => grafiki = tylkoAktualne);
              },
              child: const Text(
                'Pokaż tylko aktualny tydzień',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: grafiki.length,
              itemBuilder: (context, index) {
                final grafik = grafiki[index];
                return Card(
                  color: Colors.white10,
                  margin: const EdgeInsets.all(12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tydzień: ${grafik.tydzien}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        ...grafik.dni.entries.map((dzienEntry) {
                          final dzien = dzienEntry.key;
                          final pracownicy = dzienEntry.value;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dzien,
                                style: const TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.bold),
                              ),
                              ...pracownicy.entries.map((e) {
                                final p = e.value;
                                if (p.godziny.isEmpty ||
                                    p.lokal.isEmpty) {
                                  return const SizedBox.shrink();
                                }
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 4),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: kolorTla(p.lokal),
                                    borderRadius:
                                    BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${p.imie}: ${p.godziny}h (${p.lokal})',
                                    style: const TextStyle(
                                        color: Colors.white),
                                  ),
                                );
                              }).toList(),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
