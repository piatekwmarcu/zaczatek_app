import 'package:flutter/material.dart';
import '../../services/dostawa_service.dart';
import '../../models/dostawa.dart';

class DostawaHistoriaPage extends StatefulWidget {
  const DostawaHistoriaPage({super.key});

  @override
  State<DostawaHistoriaPage> createState() => _DostawaHistoriaPageState();
}

class _DostawaHistoriaPageState extends State<DostawaHistoriaPage> {
  final DostawaService _dostawaService = DostawaService();
  String _wybranaLokalizacja = 'Ruczaj'; // domyślna

  @override
  Widget build(BuildContext context) {
    final dostawy = _dostawaService.getDostawyDlaLokalizacji(_wybranaLokalizacja);

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
              const SizedBox(height: 16),
              const Text(
                'Historia dostaw',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD2D4C8),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: ['Ruczaj', 'Wola Duchacka'].map((lokal) {
                  final aktywny = _wybranaLokalizacja == lokal;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: aktywny ? const Color(0xFF093824) : const Color(0xFF725E54),
                        foregroundColor: const Color(0xFFD2D4C8),
                      ),
                      onPressed: () {
                        setState(() {
                          _wybranaLokalizacja = lokal;
                        });
                      },
                      child: Text(lokal),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ValueListenableBuilder<List<Dostawa>>(
                  valueListenable: _dostawaService.dostawyNotifier,
                  builder: (context, _, __) {
                    final lokalne = _dostawaService.getDostawyDlaLokalizacji(_wybranaLokalizacja);

                    if (lokalne.isEmpty) {
                      return const Center(
                        child: Text(
                          'Brak zapisanych dostaw',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: lokalne.length,
                      itemBuilder: (context, index) {
                        final d = lokalne[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          color: const Color(0xFF725E54),
                          child: ListTile(
                            title: Text(
                              '${d.kategoria} – ${d.nazwaProduktu}',
                              style: const TextStyle(color: Color(0xFFD2D4C8)),
                            ),
                            subtitle: Text(
                              'Dostarczono: ${d.ilosc} • ${d.data.toLocal().toString().substring(0, 16)}',
                              style: const TextStyle(color: Color(0xFFD2D4C8)),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
