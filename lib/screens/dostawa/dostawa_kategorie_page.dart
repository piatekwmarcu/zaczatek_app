import 'package:flutter/material.dart';
import 'dostawa_formularz_page.dart';

class DostawaKategoriePage extends StatelessWidget {
  final String login;
  final String lokalizacja;
  final String rola;

  const DostawaKategoriePage({
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
              const SizedBox(height: 20),
              Text(
                'Dostawa – $lokalizacja',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD2D4C8),
                ),
              ),
              const SizedBox(height: 32),
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
                            builder: (_) => DostawaFormularzPage(
                              kategoria: kategoria,
                              lokalizacja: lokalizacja,
                              login: login,
                              rola: rola,
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
