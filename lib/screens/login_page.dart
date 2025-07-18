import 'package:flutter/material.dart';
import '../services/uzytkownik_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginController = TextEditingController();
  final _hasloController = TextEditingController();
  String _blad = '';

  Future<void> _login() async {
    final login = _loginController.text.trim().toLowerCase();
    final haslo = _hasloController.text.trim();

    final uzytkownik = await UzytkownikService().znajdz(login, haslo);

    if (uzytkownik == null) {
      setState(() {
        _blad = 'Nieprawidłowy login lub hasło';
      });
      return;
    }

    Navigator.pushReplacementNamed(
      context,
      '/dashboard',
      arguments: uzytkownik,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD2D4C8),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo.png', height: 100),
                const SizedBox(height: 16),

                TextField(
                  controller: _loginController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Login',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),

                TextField(
                  controller: _hasloController,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Hasło',
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 16),

                if (_blad.isNotEmpty)
                  Text(_blad, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF725E54),
                      foregroundColor: const Color(0xFFD2D4C8),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    onPressed: _login,
                    child: const Text('Zaloguj'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
