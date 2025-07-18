import 'package:flutter/material.dart';
import '../models/uzytkownik.dart';
import '../services/uzytkownik_service.dart';

class ZarzadzanieUzytkownikamiPage extends StatefulWidget {
  const ZarzadzanieUzytkownikamiPage({super.key});

  @override
  State<ZarzadzanieUzytkownikamiPage> createState() => _ZarzadzanieUzytkownikamiPageState();
}

class _ZarzadzanieUzytkownikamiPageState extends State<ZarzadzanieUzytkownikamiPage> {
  final _formKey = GlobalKey<FormState>();
  String login = '';
  String haslo = '';
  String rola = 'pracownik';
  List<Uzytkownik> uzytkownicy = [];

  @override
  void initState() {
    super.initState();
    _wczytajUzytkownikow();
  }

  Future<void> _wczytajUzytkownikow() async {
    uzytkownicy = await UzytkownikService().pobierzUzytkownikow();
    setState(() {});
  }

  Future<void> dodajUzytkownika() async {
    if (_formKey.currentState!.validate()) {
      final nowy = Uzytkownik(login: login, haslo: haslo, rola: rola.toUpperCase());
      await UzytkownikService().dodajUzytkownika(nowy);
      login = '';
      haslo = '';
      rola = 'pracownik';
      _formKey.currentState!.reset();
      await _wczytajUzytkownikow();
    }
  }

  Future<void> usunUzytkownika(String login) async {
    await UzytkownikService().usunUzytkownika(login);
    await _wczytajUzytkownikow();
  }

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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Color(0xFFD2D4C8)),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Zarządzanie użytkownikami',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFD2D4C8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration('Login'),
                        onChanged: (val) => login = val,
                        validator: (val) => val == null || val.isEmpty ? 'Wpisz login' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        decoration: _inputDecoration('Hasło'),
                        onChanged: (val) => haslo = val,
                        validator: (val) => val == null || val.isEmpty ? 'Wpisz hasło' : null,
                        obscureText: true,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: rola,
                        decoration: _inputDecoration('Rola'),
                        items: const [
                          DropdownMenuItem(value: 'admin', child: Text('Admin')),
                          DropdownMenuItem(value: 'pracownik', child: Text('Pracownik')),
                        ],
                        onChanged: (val) => rola = val!,
                        dropdownColor: const Color(0xFF725E54),
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: dodajUzytkownika,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF093824),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Dodaj użytkownika'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Divider(color: Colors.white70),
                const Text(
                  'Zapisani użytkownicy:',
                  style: TextStyle(color: Color(0xFFD2D4C8), fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: uzytkownicy.length,
                    itemBuilder: (context, index) {
                      final u = uzytkownicy[index];
                      return Card(
                        color: const Color(0xFF725E54),
                        child: ListTile(
                          title: Text(u.login, style: const TextStyle(color: Color(0xFFD2D4C8))),
                          subtitle: Text('Rola: ${u.rola}', style: const TextStyle(color: Color(0xFFD2D4C8))),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () => usunUzytkownika(u.login),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: const Color(0xAA040F0F),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
