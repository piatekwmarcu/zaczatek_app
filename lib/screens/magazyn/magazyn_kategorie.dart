import 'package:flutter/material.dart';
import '../../screens/magazyn/magazyn_lista.dart';

class MagazynKategoriePage extends StatelessWidget {
  final String login;
  final String lokalizacja;
  final String rola;

  const MagazynKategoriePage({
    super.key,
    required this.login,
    required this.lokalizacja,
    required this.rola,
  });

  final List<String> kategorie = const [
    'Kartony',
    'Napoje',
    'Bar',
    'Chemia',
  ];

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
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '📦 Kategorie magazynu',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Lokalizacja: $lokalizacja',
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFF725E54),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(16),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: kategorie.map((kategoria) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MagazynListaPage(
                              kategoria: kategoria,
                              lokalizacja: lokalizacja,
                              rola: rola,
                              login: login,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF093824),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            kategoria,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFFD2D4C8),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
