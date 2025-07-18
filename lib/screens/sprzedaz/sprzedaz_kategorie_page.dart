import 'package:flutter/material.dart';
import 'import_csv_manual.dart';
import '../analiza/analiza_sprzedazy.dart';

class SprzedazKategoriePage extends StatelessWidget {
  final String lokalizacja;

  const SprzedazKategoriePage({super.key, required this.lokalizacja});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Tło – zdjęcie z 60% kryciem
          Positioned.fill(
            child: Opacity(
              opacity: 0.6,
              child: Image.asset(
                'assets/zaczatek.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Przycisk wstecz i logo
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Color(0xFFD2D4C8)),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      Image.asset('assets/logo.png', width: 80),
                      const Spacer(flex: 2),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Wybierz opcję sprzedaży:',
                  style: TextStyle(
                    color: Color(0xFFD2D4C8),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    children: [
                      _Tile(
                        icon: Icons.file_upload,
                        label: 'Import sprzedaży',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ImportCsvManualPage(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _Tile(
                        icon: Icons.bar_chart,
                        label: 'Analiza sprzedaży',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AnalizaSprzedazyPage(lokalizacja: lokalizacja),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _Tile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: const Color(0xFF725E54).withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Color(0xFFD2D4C8), size: 28),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFFD2D4C8),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
