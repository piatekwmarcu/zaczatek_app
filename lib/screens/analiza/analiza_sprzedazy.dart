import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/sprzedaz_service.dart';

class AnalizaSprzedazyPage extends StatefulWidget {
  final String lokalizacja;

  const AnalizaSprzedazyPage({super.key, required this.lokalizacja});

  @override
  State<AnalizaSprzedazyPage> createState() => _AnalizaSprzedazyPageState();
}

class _AnalizaSprzedazyPageState extends State<AnalizaSprzedazyPage> {
  final _sprzedazService = SprzedazService();
  String _wybranyOkres = 'Wszystko';
  String? _wybranaLokalizacja;

  Duration get _zakresCzasu {
    switch (_wybranyOkres) {
      case '1 miesiąc':
        return const Duration(days: 30);
      case '3 miesiące':
        return const Duration(days: 90);
      default:
        return const Duration(days: 10000); // "Wszystko"
    }
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
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '📈 Analiza sprzedaży',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLokalizacjaButton('Ruczaj'),
                    const SizedBox(width: 16),
                    _buildLokalizacjaButton('Sławka'),
                  ],
                ),
                const SizedBox(height: 8),
                if (_wybranaLokalizacja != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Zakres: '),
                      const SizedBox(width: 8),
                      DropdownButton<String>(
                        value: _wybranyOkres,
                        items: const [
                          DropdownMenuItem(value: '1 miesiąc', child: Text('1 miesiąc')),
                          DropdownMenuItem(value: '3 miesiące', child: Text('3 miesiące')),
                          DropdownMenuItem(value: 'Wszystko', child: Text('Wszystko')),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _wybranyOkres = value);
                          }
                        },
                      ),
                    ],
                  ),
                const SizedBox(height: 16),
                Expanded(
                  child: _wybranaLokalizacja == null
                      ? const Center(child: Text('Wybierz lokalizację'))
                      : _buildWykres(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLokalizacjaButton(String lokalizacja) {
    final isSelected = _wybranaLokalizacja == lokalizacja;
    return GestureDetector(
      onTap: () => setState(() => _wybranaLokalizacja = lokalizacja),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF725E54) : const Color(0xFFD2D4C8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          lokalizacja,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildWykres() {
    final top = _wybranyOkres == 'Wszystko'
        ? _sprzedazService.topWszystko(lokalizacja: widget.lokalizacja)
        : _sprzedazService.topZOkresu(
      okres: _zakresCzasu,
      lokalizacja: widget.lokalizacja,
    );

    if (top.isEmpty) {
      return const Center(child: Text('Brak danych sprzedażowych'));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barGroups: top.asMap().entries.map((entry) {
            final index = entry.key;
            final produkt = entry.value;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: produkt.ilosc.toDouble(),
                  width: 20,
                  borderRadius: BorderRadius.circular(4),
                  color: const Color(0xFF093824),
                ),
              ],
            );
          }).toList(),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final i = value.toInt();
                  if (i >= 0 && i < top.length) {
                    return RotatedBox(
                      quarterTurns: 1,
                      child: Text(
                        top[i].nazwaProduktu,
                        style: const TextStyle(fontSize: 10),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: false),
        ),
      ),
    );
  }
}
