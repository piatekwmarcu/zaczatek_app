import 'package:flutter/material.dart';
import '../models/uzytkownik.dart';
import 'dashboard_admin.dart';
import 'dashboard_pracownik.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final uzytkownik = ModalRoute.of(context)?.settings.arguments as Uzytkownik;

    if (uzytkownik.rola == 'ADMIN') {
      return AdminDashboardPage(login: uzytkownik.login, rola: 'admin');
    } else {
      return PracownikDashboardPage(login: uzytkownik.login, rola:'pracownik');
    }
  }
}
