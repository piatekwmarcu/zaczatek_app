import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import '../../models/grafik_model.dart';
import 'package:uuid/uuid.dart'; // na górze pliku
import '../../services/grafik_service.dart';

class GrafikAdminPage extends StatefulWidget {
  const GrafikAdminPage({super.key});

  @override
  State<GrafikAdminPage> createState() => _GrafikAdminPageState();
}

class _GrafikAdminPageState extends State<GrafikAdminPage> {
  late Box<GrafikTygodniowy> grafikBox;
  final List<String> dniTygodnia = ['Pon', 'Wt', 'Śr', 'Czw', 'Pt', 'Sob', 'Niedz'];
  final List<String> pracownicy = [
    'PIOTREK', 'PAWEŁ', 'PRZEMO', 'SABEUSZ', 'DONATELLA', 'KONDZIO',
    'WŁODEK', 'NIEMCU', 'MADZIA', 'EMKA', 'ADAM', 'KRZYSIEK', 'SEBA'
  ];

  final Map<String, Map<String, GrafikPracownik>> nowyGrafik = {};
  final TextEditingController _tydzienController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      grafikBox = Hive.box<GrafikTygodniowy>('grafiki');
      for (var dzien in dniTygodnia) {
        nowyGrafik[dzien] = {};
        for (var pracownik in pracownicy) {
          nowyGrafik[dzien]![pracownik] = GrafikPracownik(imie: pracownik, godziny: '', lokal: '');
        }
      }
      setState(() {}); // ← jeśli grafika ma się odświeżyć po załadowaniu
    });
  }


  Future<void> zapiszGrafik() async {
    final grafik = GrafikTygodniowy(
      id: const Uuid().v4(), // NOWE
      tydzien: _tydzienController.text,
      dni: nowyGrafik,
      dataDodania: DateTime.now(),
    );

// lokalnie:
    grafikBox.add(grafik);

// ONLINE:
    await GrafikService().dodajGrafik(grafik);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Grafik zapisany ✅')),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final poprzednieGrafiki = grafikBox.values.toList()
      ..sort((a, b) => b.dataDodania.compareTo(a.dataDodania));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF725E54),
        title: const Text('Tworzenie grafiku'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: zapiszGrafik,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _tydzienController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Tydzień (np. 16.06–22.06)',
                labelStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.white24,
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: pracownicy.map((pracownik) {
                return Card(
                  color: Colors.white10,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(pracownik, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 8),
                        ...dniTygodnia.map((dzien) {
                          final dane = nowyGrafik[dzien]![pracownik]!;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                SizedBox(width: 40, child: Text(dzien, style: const TextStyle(color: Colors.white))),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    style: const TextStyle(color: Colors.white),
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      hintText: 'godz.',
                                      hintStyle: TextStyle(color: Colors.white54),
                                      border: OutlineInputBorder(),
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                    ),
                                    onChanged: (val) => dane.godziny = val,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                DropdownButton<String>(
                                  dropdownColor: Colors.grey[900],
                                  value: dane.lokal.isEmpty ? null : dane.lokal,
                                  hint: const Text('Lokal', style: TextStyle(color: Colors.white)),
                                  items: ['Ruczaj', 'Wola Duchacka'].map((lok) {
                                    return DropdownMenuItem<String>(
                                      value: lok,
                                      child: Text(lok, style: const TextStyle(color: Colors.white)),
                                    );
                                  }).toList(),
                                  onChanged: (val) => setState(() => dane.lokal = val ?? ''),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(color: Colors.white),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Archiwalne grafiki',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: poprzednieGrafiki.length,
              itemBuilder: (context, index) {
                final g = poprzednieGrafiki[index];
                return ListTile(
                  title: Text(
                    g.tydzien,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    'Dodano: ${DateFormat('yyyy-MM-dd – kk:mm').format(g.dataDodania)}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () async {
                      await GrafikService().usunGrafik(g.id);
                      setState(() {}); // odświeżenie
                    },
                  ),
                );

              },
            ),
          ),
        ],
      ),
    );
  }
}
