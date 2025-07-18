import 'package:flutter/material.dart';
import 'analiza_sprzedazy.dart';

class AnalizaLokalizacjaPage extends StatelessWidget {
  const AnalizaLokalizacjaPage({super.key});

  void otworzAnalize(BuildContext context, String lokalizacja) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AnalizaSprzedazyPage(lokalizacja: lokalizacja),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.6,
              child: Image.asset('assets/zaczatek.jpg', fit: BoxFit.cover),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(height: 32),
                const Center(
                  child: Text(
                    'Wybierz lokalizację:',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    padding: const EdgeInsets.all(24),
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    children: [
                      _buildTile(context, 'Ruczaj', Icons.storefront),
                      _buildTile(context, 'Sławka', Icons.local_pizza),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTile(BuildContext context, String lokalizacja, IconData icon) {
    return GestureDetector(
      onTap: () => otworzAnalize(context, lokalizacja),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Color(0xFFD2D4C8)),
            const SizedBox(height: 12),
            Text(
              lokalizacja,
              style: const TextStyle(
                fontSize: 20,
                color: Color(0xFFD2D4C8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
