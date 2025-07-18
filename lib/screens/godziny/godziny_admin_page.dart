import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../models/godziny_model.dart';
import '../../services/godziny_service.dart';

class GodzinyAdminPage extends StatefulWidget {
  const GodzinyAdminPage({super.key});

  @override
  State<GodzinyAdminPage> createState() => _GodzinyAdminPageState();
}

class _GodzinyAdminPageState extends State<GodzinyAdminPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<GodzinyPracy> _dane = [];
  final GodzinyService _godzinyService = GodzinyService();

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadDane();
  }

  Future<void> _loadDane() async {
    if (_selectedDay == null) return;
    final dane = await _godzinyService.pobierzGodzinyDlaDnia(_selectedDay!);
    setState(() {
      _dane = dane;
    });
  }

  String _obliczLiczbeGodzin(String start, String end) {
    try {
      final startParts = start.split(':');
      final endParts = end.split(':');

      if (startParts.length < 2 || endParts.length < 2) return '-';

      final startHour = int.parse(startParts[0]);
      final startMinute = int.parse(startParts[1]);

      final endHour = int.parse(endParts[0]);
      final endMinute = int.parse(endParts[1]);

      final startDate = DateTime(2025, 1, 1, startHour, startMinute);
      DateTime endDate = DateTime(2025, 1, 1, endHour, endMinute);

      if (endDate.isBefore(startDate)) {
        endDate = endDate.add(const Duration(days: 1));
      }

      final diff = endDate.difference(startDate);
      final hours = diff.inHours;
      final minutes = diff.inMinutes % 60;

      return '${hours}h ${minutes}min';
    } catch (e) {
      return '-';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF725E54),
        title: const Text('Godziny – Admin'),
        actions: [
          IconButton(
            icon: Icon(Icons.bar_chart),
            tooltip: 'Podsumowanie miesięczne',
            onPressed: () {
              Navigator.pushNamed(context, '/statystyki');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarStyle: const CalendarStyle(
              weekendTextStyle: TextStyle(color: Colors.red),
              defaultTextStyle: TextStyle(color: Colors.white),
              todayDecoration: BoxDecoration(
                color: Color(0xFFF08700),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Color(0xFF093824),
                shape: BoxShape.circle,
              ),
            ),
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekendStyle: TextStyle(color: Colors.red),
              weekdayStyle: TextStyle(color: Colors.white),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
              leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
              rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
            ),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              _loadDane();
            },
          ),
          const SizedBox(height: 12),
          const Text(
            'Wpisy pracowników:',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: _dane.length,
              itemBuilder: (context, index) {
                final wpis = _dane[index];
                return Card(
                  color: const Color(0xFF725E54),
                  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('👤 ${wpis.login}', style: const TextStyle(color: Colors.white, fontSize: 16)),
                        Text('📍 Lokal: ${wpis.lokal}', style: const TextStyle(color: Colors.white)),
                        Text('🕓 Od: ${wpis.godzinaStart}  Do: ${wpis.godzinaKoniec}', style: const TextStyle(color: Colors.white)),
                        Text('⏳ Liczba godzin: ${_obliczLiczbeGodzin(wpis.godzinaStart, wpis.godzinaKoniec)}', style: const TextStyle(color: Colors.white)),
                        if (wpis.kursy != null && wpis.kursy! > 0)
                          Text('🚗 Kursy: ${wpis.kursy}', style: const TextStyle(color: Colors.white)),
                        if (wpis.kilometry != null && wpis.kilometry! > 0)
                          Text('🛣️ Kilometry: ${wpis.kilometry}', style: const TextStyle(color: Colors.white)),
                      ],
                    ),
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
