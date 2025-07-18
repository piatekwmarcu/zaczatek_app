import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/ogloszenie.dart';
import '../../services/ogloszenia_service.dart';

class OgloszeniaPracownikPage extends StatefulWidget {
  final String login;

  const OgloszeniaPracownikPage({super.key, required this.login});

  @override
  State<OgloszeniaPracownikPage> createState() => _OgloszeniaPracownikPageState();
}

class _OgloszeniaPracownikPageState extends State<OgloszeniaPracownikPage> {
  final OgloszeniaService _ogloszeniaService = OgloszeniaService();
  List<Ogloszenie> _ogloszenia = [];

  @override
  void initState() {
    super.initState();
    _loadOgloszenia();
  }

  Future<void> _loadOgloszenia() async {
    final fetched = await _ogloszeniaService.pobierzOgloszenia();
    setState(() {
      _ogloszenia = fetched;
    });
    await _oznaczJakoPrzeczytane();
  }

  Future<void> _oznaczJakoPrzeczytane() async {
    for (var o in _ogloszenia) {
      if (!o.przeczytanePrzez.contains(widget.login)) {
        o.przeczytanePrzez.add(widget.login);
        await _ogloszeniaService.aktualizujOgloszenie(o);
      }
    }
  }

  Future<void> _reakcja(Ogloszenie ogloszenie, String typ) async {
    setState(() {
      if (typ == 'like') {
        ogloszenie.lapkiWGore++;
      } else if (typ == 'heart') {
        ogloszenie.serduszka++;
      } else if (typ == 'dislike') {
        ogloszenie.lapkiWDol++;
      }
    });
    await _ogloszeniaService.aktualizujOgloszenie(ogloszenie);
  }

  Future<void> _dodajKomentarz(Ogloszenie o, String text) async {
    o.komentarze.add({
      'login': widget.login,
      'tresc': text.trim(),
      'czas': DateFormat('HH:mm dd.MM').format(DateTime.now()),
    });
    await _ogloszeniaService.aktualizujOgloszenie(o);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Ogłoszenia 📢',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD2D4C8),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _ogloszenia.length,
                    itemBuilder: (context, index) {
                      final o = _ogloszenia[index];

                      return Card(
                        color: const Color.fromRGBO(114, 94, 84, 0.95),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                o.tresc,
                                style: const TextStyle(fontSize: 18, color: Colors.white),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.favorite_border, color: Colors.redAccent),
                                    onPressed: () => _reakcja(o, 'heart'),
                                  ),
                                  Text('${o.serduszka}', style: const TextStyle(color: Colors.white)),
                                  const SizedBox(width: 12),
                                  IconButton(
                                    icon: const Icon(Icons.thumb_up_alt_outlined, color: Colors.green),
                                    onPressed: () => _reakcja(o, 'like'),
                                  ),
                                  Text('${o.lapkiWGore}', style: const TextStyle(color: Colors.white)),
                                  const SizedBox(width: 12),
                                  IconButton(
                                    icon: const Icon(Icons.thumb_down_alt_outlined, color: Colors.orange),
                                    onPressed: () => _reakcja(o, 'dislike'),
                                  ),
                                  Text('${o.lapkiWDol}', style: const TextStyle(color: Colors.white)),
                                ],
                              ),
                              const SizedBox(height: 12),
                              const Text("💬 Komentarze:", style: TextStyle(color: Colors.white)),
                              const SizedBox(height: 4),
                              for (var k in o.komentarze)
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 2),
                                  child: Text(
                                    '${k['login']} (${k['czas']}): ${k['tresc']}',
                                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                                  ),
                                ),
                              const SizedBox(height: 8),
                              TextField(
                                decoration: const InputDecoration(
                                  hintText: 'Dodaj komentarz...',
                                  filled: true,
                                  fillColor: Colors.white24,
                                  hintStyle: TextStyle(color: Colors.white54),
                                ),
                                style: const TextStyle(color: Colors.white),
                                onSubmitted: (text) {
                                  if (text.trim().isNotEmpty) {
                                    _dodajKomentarz(o, text);
                                  }
                                },
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '✅ Przeczytane przez: ${o.przeczytanePrzez.join(', ')}',
                                style: const TextStyle(color: Colors.white60, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
