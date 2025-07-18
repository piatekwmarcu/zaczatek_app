import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/ogloszenie.dart';
import '../../services/ogloszenia_service.dart';

class OgloszeniaAdminPage extends StatefulWidget {
  const OgloszeniaAdminPage({super.key});

  @override
  State<OgloszeniaAdminPage> createState() => _OgloszeniaAdminPageState();
}

class _OgloszeniaAdminPageState extends State<OgloszeniaAdminPage> {
  final OgloszeniaService _ogloszeniaService = OgloszeniaService();
  List<Ogloszenie> _ogloszenia = [];

  @override
  void initState() {
    super.initState();
    _pobierzOgloszenia();
  }

  Future<void> _pobierzOgloszenia() async {
    final lista = await _ogloszeniaService.pobierzOgloszenia();
    setState(() {
      _ogloszenia = lista;
    });
  }

  void _dodajOgloszenie() {
    final TextEditingController _controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Nowe ogłoszenie'),
        content: TextField(
          controller: _controller,
          maxLines: 4,
          decoration: const InputDecoration(hintText: 'Wpisz treść ogłoszenia'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Anuluj'),
          ),
          TextButton(
            onPressed: () async {
              final tresc = _controller.text.trim();
              if (tresc.isNotEmpty) {
                final ogloszenie = Ogloszenie(
                  tresc: tresc,
                  dataDodania: DateTime.now(),
                  autor: 'admin',
                  serduszka: 0,
                  lapkiWGore: 0,
                  lapkiWDol: 0,
                  przeczytanePrzez: [],
                  komentarze: [],
                );
                await _ogloszeniaService.dodajOgloszenie(ogloszenie);
                _pobierzOgloszenia();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Dodano ogłoszenie!'),
                    backgroundColor: Colors.green.shade700,
                    duration: Duration(seconds: 2),
                  ),
                );
              }
              Navigator.pop(context);
            },
            child: const Text('Dodaj'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Ogłoszenia'),
        backgroundColor: const Color(0xFF093824),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _dodajOgloszenie,
          ),
        ],
      ),
      body: Container(
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
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _ogloszenia.length,
          itemBuilder: (context, index) {
            final o = _ogloszenia[index];
            return Card(
              color: const Color(0xFF725E54).withOpacity(0.95),
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      o.tresc,
                      style: const TextStyle(fontSize: 16, color: Color(0xFFD2D4C8)),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('👤 ${o.autor}', style: const TextStyle(color: Colors.white70)),
                        Text(DateFormat('dd.MM.yyyy HH:mm').format(o.dataDodania),
                            style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (o.przeczytanePrzez.isNotEmpty)
                      Text(
                        '✅ Przeczytane przez: ${o.przeczytanePrzez.join(', ')}',
                        style: const TextStyle(color: Colors.white60, fontSize: 13),
                      ),
                    const SizedBox(height: 10),
                    if (o.komentarze.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("💬 Komentarze:", style: TextStyle(color: Colors.white)),
                          const SizedBox(height: 4),
                          ...o.komentarze.map((k) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text(
                              '${k['login']} (${k['czas']}): ${k['tresc']}',
                              style: const TextStyle(color: Colors.white70, fontSize: 13),
                            ),
                          )),
                        ],
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
