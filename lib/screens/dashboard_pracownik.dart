import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import 'package:zaczatek_app/models/godziny_model.dart';
import 'package:zaczatek_app/screens/godziny/godziny_pracownik_page.dart';
import 'package:zaczatek_app/screens/grafik/grafik_pracownik_page.dart';
import '../screens/dostawa/dostawa_lokalizacja_page.dart';
import '../screens/magazyn/magazyn_lokalizacja.dart';
import '../screens/ogloszenia/ogloszenia_pracownik_page.dart';

class PracownikDashboardPage extends StatefulWidget {
  final String login;
  final String rola;

  const PracownikDashboardPage({
    super.key,
    required this.login,
    required this.rola,
  });

  @override
  State<PracownikDashboardPage> createState() => _PracownikDashboardPageState();
}

class _PracownikDashboardPageState extends State<PracownikDashboardPage> {
  bool brakGodzin = false;

  @override
  void initState() {
    super.initState();
    _sprawdzGodziny();
  }

  void _sprawdzGodziny() async {
    final box = Hive.box<GodzinyPracy>('godziny');
    final teraz = DateTime.now();
    final poczatekTygodnia = teraz.subtract(Duration(days: teraz.weekday - 1));
    final koniecTygodnia = poczatekTygodnia.add(const Duration(days: 6));

    final godzinyTygodnia = box.values.where((g) =>
    g.login == widget.login &&
        g.data.isAfter(poczatekTygodnia.subtract(const Duration(days: 1))) &&
        g.data.isBefore(koniecTygodnia.add(const Duration(days: 1))));

    setState(() {
      brakGodzin = godzinyTygodnia.isEmpty;
    });
  }

  void _navigateWithFade(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(opacity: animation, child: child);
        },
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
              child: Image.asset(
                'assets/zaczatek.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12, right: 12),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFFD2D4C8),
                      ),
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Wyloguj'),
                    ),
                  ),
                ),
                if (brakGodzin)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.warning, color: Colors.white),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Nie dodałeś godzin pracy w tym tygodniu!',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                Center(
                  child: Image.asset(
                    'assets/logo.png',
                    width: 100,
                    height: 100,
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        _Tile(
                          icon: Icons.inventory_2,
                          label: 'Magazyn',
                          onTap: () => _navigateWithFade(
                            context,
                            MagazynLokalizacjePage(login: widget.login, rola: 'pracownik'),
                          ),
                        ),
                        _Tile(
                          icon: Icons.local_shipping,
                          label: 'Dostawa',
                          onTap: () => _navigateWithFade(
                            context,
                            DostawaLokalizacjaPage(login: widget.login, rola: widget.rola),
                          ),
                        ),
                        _Tile(
                          icon: Icons.assignment,
                          label: 'Stany',
                          onTap: () => Navigator.pushNamed(context, '/stany'),
                        ),
                        _Tile(
                          icon: Icons.history,
                          label: 'Historia dostaw',
                          onTap: () => Navigator.pushNamed(context, '/dostawa_historia'),
                        ),
                        _Tile(
                          icon: Icons.campaign,
                          label: 'Ogłoszenia',
                          onTap: () => _navigateWithFade(
                            context,
                            OgloszeniaPracownikPage(login: widget.login),
                          ),
                        ),
                        _Tile(
                          icon: Icons.calendar_today,
                          label: 'Grafik',
                          onTap: () => _navigateWithFade(
                            context,
                            const GrafikPracownikPage(),
                          ),
                        ),
                        _Tile(
                          icon: Icons.access_time,
                          label: 'Godziny',
                          onTap: () => _navigateWithFade(
                            context,
                            GodzinyPracownikPage(login: widget.login),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
        decoration: BoxDecoration(
          color: const Color(0xFF725E54).withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 36),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFFD2D4C8),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
