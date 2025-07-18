import 'package:flutter/material.dart';
import '../../services/magazyn_service.dart';
import '../../services/sprzedaz_service.dart';

class ImportCsvManualPage extends StatefulWidget {
  const ImportCsvManualPage({super.key});

  @override
  State<ImportCsvManualPage> createState() => _ImportCsvManualPageState();
}

class _ImportCsvManualPageState extends State<ImportCsvManualPage> {
  final _controller = TextEditingController();
  final _magazynService = MagazynService();
  final _sprzedazService = SprzedazService();

  String? _wybranaLokalizacja;

  final List<String> pizzaKeywords = [
    'Margherita', 'Tartufo', 'Capra', 'Verdure', 'Formaggio', 'Buratta',
    'Prosciutto', 'Napoli', 'Crudo', 'Tonno', 'Dinamite', 'Spianata',
    'Bresaola', 'Gamberi', 'Contadino', 'Zaczatek', 'Pizza'
  ];

  final List<String> calzoneKeywords = ['Calzone'];
  final List<String> deserKeywords = ['Cannoli', 'Tiramisu', 'Profiteroli', 'Affogato'];

  final Map<String, String> napojeMap = {
    'Pepsi': 'Pepsi',
    'Pepsi Max': 'Pepsi MAX',
    'LemonSoda': 'LemonSoda',
    'Mojito': 'MojitoSoda',
    'OranSoda': 'OranSoda',
    'Chino': 'SanPelli. Chino',
    'Limonata': 'SanPell. Limonata',
    'Aranciata': 'SanPelli. Aranciata',
    'San Benedetto Pesca': 'San Benedetto Pesca',
    'Succoso Mango Mela': 'San Benedetto Succoso Mango Mela',
    'Succoso Tutti Rossi': 'San Benedetto Succoso Tutti Rossi',
    'Succoso Frutta Mix': 'San Benedetto Succoso Frutta Mix',
    'Moretti': 'Moretti 0.0%',
    'Tifosi': 'Tifosi 0.0%',
  };

  void _przetworz() {
    final lokalizacja = _wybranaLokalizacja;
    if (lokalizacja == null) return;

    final lines = _controller.text.trim().split('\n');
    for (final line in lines) {
      if (!line.contains(',')) continue;
      final parts = line.split(',');
      final nazwa = parts[0].trim();
      final ilosc = int.tryParse(parts[1].trim()) ?? 0;

      if (ilosc <= 0) continue;

      for (final key in napojeMap.keys) {
        if (nazwa.toLowerCase().contains(key.toLowerCase())) {
          _magazynService.odejmijZeStanu(napojeMap[key]!, 'Napoje', lokalizacja, ilosc);
          _sprzedazService.dodaj(napojeMap[key]!, ilosc, lokalizacja);
          break;
        }
      }

      if (pizzaKeywords.any((k) => nazwa.toLowerCase().contains(k.toLowerCase()))) {
        _magazynService.odejmijZeStanu('Kartony na pizze', 'Kartony', lokalizacja, ilosc);
        _sprzedazService.dodaj('Kartony na pizze', ilosc, lokalizacja);
      }

      if (calzoneKeywords.any((k) => nazwa.toLowerCase().contains(k.toLowerCase()))) {
        _magazynService.odejmijZeStanu('Kartony na calzone', 'Kartony', lokalizacja, ilosc);
        _sprzedazService.dodaj('Kartony na calzone', ilosc, lokalizacja);
      }

      if (deserKeywords.any((k) => nazwa.toLowerCase().contains(k.toLowerCase()))) {
        _magazynService.odejmijZeStanu('Pudełka na desery', 'Kartony', lokalizacja, ilosc);
        _sprzedazService.dodaj('Pudełka na desery', ilosc, lokalizacja);
      }
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('✅ Gotowe'),
        content: const Text('Sprzedaż została przetworzona.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    _controller.clear();
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
                // Pasek górny
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Color(0xFFD2D4C8)),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '📂 Import sprzedaży',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFD2D4C8),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Wybierz lokalizację:',
                  style: TextStyle(color: Color(0xFFD2D4C8), fontSize: 16),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _LokalTile(
                      label: 'Ruczaj',
                      selected: _wybranaLokalizacja == 'Ruczaj',
                      onTap: () => setState(() => _wybranaLokalizacja = 'Ruczaj'),
                    ),
                    const SizedBox(width: 16),
                    _LokalTile(
                      label: 'Sławka',
                      selected: _wybranaLokalizacja == 'Sławka',
                      onTap: () => setState(() => _wybranaLokalizacja = 'Sławka'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _controller,
                    maxLines: 10,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color(0xFF725E54),
                      hintText: 'Np.\nMargherita,5\nPepsi,2\nCalzone No.2,3',
                      hintStyle: TextStyle(color: Color(0xFFD2D4C8)),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.check),
                  label: const Text('Zatwierdź sprzedaż'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF093824),
                    foregroundColor: const Color(0xFFD2D4C8),
                  ),
                  onPressed: _wybranaLokalizacja == null ? null : _przetworz,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LokalTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LokalTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF093824) : const Color(0xFF725E54),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xFFD2D4C8),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
