import 'package:flutter/material.dart';
import 'dostawa_lista_page.dart';

class DostawaLokalizacjaPage extends StatelessWidget {
  final String login;
  final String rola;

  const DostawaLokalizacjaPage({
    super.key,
    required this.login,
    required this.rola,
  });

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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Wybierz lokalizację dostawy:',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD2D4C8),
                  ),
                ),
                const SizedBox(height: 32),
                _lokalTile(context, 'Wola Duchacka'),
                const SizedBox(height: 16),
                _lokalTile(context, 'Ruczaj'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _lokalTile(BuildContext context, String lokalizacja) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DostawaListaPage(
              lokalizacja: lokalizacja,
              login: login,
              rola: rola,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF725E54),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          lokalizacja,
          style: const TextStyle(
            fontSize: 20,
            color: Color(0xFFD2D4C8),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
