import 'package:flutter/material.dart';
import 'package:zaczatek_app/screens/dostawa/dostawa_lokalizacja_page.dart';
import 'package:zaczatek_app/screens/stany/stany_admin_page.dart';
import '../screens/dostawa/dostawa_historia.dart';
import '../screens/sprzedaz/sprzedaz_kategorie_page.dart';
import '../screens/zarzadzanie_uzytkownikami_page.dart';
import '../screens/magazyn/magazyn_lokalizacja.dart';
import '../screens/ogloszenia/ogloszenia_admin_page.dart';
import '../screens/grafik/grafik_admin_page.dart';

class AdminDashboardPage extends StatelessWidget {
  final String login;
  final String rola;

  const AdminDashboardPage({super.key, required this.login, required this.rola});

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
              child: Image.asset('assets/zaczatek.jpg', fit: BoxFit.cover),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: IconButton(
                      icon: const Icon(Icons.logout, color: Color(0xFFD2D4C8)),
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Image.asset('assets/logo.png', width: 100, height: 100),
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
                            MagazynLokalizacjePage(login: login, rola: rola),
                          ),
                        ),
                        _Tile(
                          icon: Icons.local_shipping,
                          label: 'Dostawa',
                          onTap: () => _navigateWithFade(
                            context,
                            DostawaLokalizacjaPage(login: login, rola: rola),
                          ),
                        ),
                        _Tile(
                          icon: Icons.bar_chart,
                          label: 'Sprzedaż',
                          onTap: () => _navigateWithFade(
                            context,
                            const SprzedazKategoriePage(lokalizacja: 'Ruczaj'),
                          ),
                        ),
                        _Tile(
                          icon: Icons.assignment,
                          label: 'Stany',
                          onTap: () => _navigateWithFade(
                            context,
                            const StanyAdminPage(),
                          ),
                        ),
                        _Tile(
                          icon: Icons.supervised_user_circle,
                          label: 'Zarządzanie użytkownikami',
                          onTap: () => _navigateWithFade(
                            context,
                            const ZarzadzanieUzytkownikamiPage(),
                          ),
                        ),
                        _Tile(
                          icon: Icons.campaign,
                          label: 'Ogłoszenia',
                          onTap: () => _navigateWithFade(
                            context,
                            const OgloszeniaAdminPage(),
                          ),
                        ),
                        _Tile(
                          icon: Icons.calendar_today,
                          label: 'Grafik',
                          onTap: () => _navigateWithFade(
                            context,
                            const GrafikAdminPage(),
                          ),
                        ),
                        _Tile(
                          icon: Icons.access_time,
                          label: 'Godziny',
                          onTap: () => Navigator.pushNamed(context, '/godziny_admin'),
                        ),
                        _Tile(
                          icon: Icons.history,
                          label: 'Historia dostaw',
                          onTap: () => _navigateWithFade(
                            context,
                            const DostawaHistoriaPage(),
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
                offset: Offset(2, 4),
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
                textAlign: TextAlign.center,
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
