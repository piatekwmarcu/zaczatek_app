import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/godziny_service.dart';


class StatystykiPracownikowPage extends StatefulWidget {
  const StatystykiPracownikowPage({super.key});

  @override
  State<StatystykiPracownikowPage> createState() => _StatystykiPracownikowPageState();
}

class _StatystykiPracownikowPageState extends State<StatystykiPracownikowPage> {
  final GodzinyService _godzinyService = GodzinyService();
  DateTime _wybranyMiesiac = DateTime.now();
  Map<String, Duration> _sumaGodzin = {};

  @override
  void initState() {
    super.initState();
    _obliczGodziny();
  }

  Future<void> _obliczGodziny() async {
    final wszystkie = await _godzinyService.pobierzWszystkieGodziny();

    final pierwszyDzienMiesiaca = DateTime(_wybranyMiesiac.year, _wybranyMiesiac.month, 1);
    final ostatniDzienMiesiaca = DateTime(_wybranyMiesiac.year, _wybranyMiesiac.month + 1, 0);

    final aktualnyMiesiac = wszystkie.where((w) =>
    w.data.isAfter(pierwszyDzienMiesiaca.subtract(const Duration(days: 1))) &&
        w.data.isBefore(ostatniDzienMiesiaca.add(const Duration(days: 1))));

    final Map<String, Duration> suma = {};

    for (var wpis in aktualnyMiesiac) {
      try {
        final start = _parseTime(wpis.godzinaStart);
        final koniec = _parseTime(wpis.godzinaKoniec);
        final roznica = koniec.difference(start);

        if (!suma.containsKey(wpis.login)) {
          suma[wpis.login] = roznica;
        } else {
          suma[wpis.login] = suma[wpis.login]! + roznica;
        }
      } catch (e) {
        continue;
      }
    }

    setState(() {
      _sumaGodzin = suma;
    });
  }

  DateTime _parseTime(String time) {
    final parts = time.split(':');
    final godzina = int.parse(parts[0]);
    final minuta = int.parse(parts[1]);
    return DateTime(2025, 1, 1, godzina, minuta);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF725E54),
        title: const Text('Podsumowanie miesięczne'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButton<DateTime>(
              value: _wybranyMiesiac,
              dropdownColor: Colors.black,
              isExpanded: true,
              items: List.generate(6, (index) {
                final miesiac = DateTime.now().subtract(Duration(days: 30 * index));
                final label = DateFormat('MMMM yyyy', 'pl_PL').format(miesiac);
                return DropdownMenuItem(
                  value: DateTime(miesiac.year, miesiac.month),
                  child: Text(label, style: const TextStyle(color: Colors.white)),
                );
              }),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    _wybranyMiesiac = val;
                  });
                  _obliczGodziny();
                }
              },
            ),
          ),
          const SizedBox(height: 12),
          const Text('Suma godzin dla każdego pracownika:', style: TextStyle(color: Colors.white)),
          const SizedBox(height: 12),
          Expanded(
            child: ListView(
              children: _sumaGodzin.entries.map((entry) {
                final godziny = entry.value.inHours;
                final minuty = entry.value.inMinutes % 60;
                return ListTile(
                  title: Text(entry.key, style: const TextStyle(color: Colors.white)),
                  trailing: Text('${godziny}h ${minuty}min', style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
