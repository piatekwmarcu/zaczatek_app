import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../services/godziny_service.dart';

class GodzinyPracownikPage extends StatefulWidget {
  final String login;

  const GodzinyPracownikPage({super.key, required this.login});

  @override
  State<GodzinyPracownikPage> createState() => _GodzinyPracownikPageState();
}

class _GodzinyPracownikPageState extends State<GodzinyPracownikPage> {
  final GodzinyService _godzinyService = GodzinyService();

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  final TextEditingController _kursyController = TextEditingController();
  final TextEditingController _kmController = TextEditingController();
  String? _lokal;

  Future<void> _pickTime({required bool start}) async {
    final result = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (result != null) {
      setState(() {
        if (start) {
          _startTime = result;
        } else {
          _endTime = result;
        }
      });
    }
  }

  Future<void> _zapisz() async {
    if (_selectedDay == null || _startTime == null || _endTime == null || _lokal == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❗ Wypełnij wszystkie wymagane pola')),
      );
      return;
    }

    final error = await _godzinyService.zapiszGodzinePracy(
      login: widget.login,
      data: _selectedDay!,
      lokal: _lokal!,
      godzinaStart: '${_startTime!.hour.toString().padLeft(2, '0')}:${_startTime!.minute.toString().padLeft(2, '0')}',
      godzinaKoniec: '${_endTime!.hour.toString().padLeft(2, '0')}:${_endTime!.minute.toString().padLeft(2, '0')}',
      kursy: int.tryParse(_kursyController.text),
      kilometry: double.tryParse(_kmController.text),
    );

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Błąd: $error')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Zapisano godziny')),
      );

      setState(() {
        _startTime = null;
        _endTime = null;
        _lokal = null;
        _kursyController.clear();
        _kmController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF725E54),
        title: const Text('Godziny pracy'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TableCalendar(
              focusedDay: _focusedDay,
              firstDay: DateTime.utc(2024, 1, 1),
              lastDay: DateTime.utc(2026, 12, 31),
              calendarFormat: CalendarFormat.month,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              headerStyle: const HeaderStyle(titleCentered: true),
              calendarStyle: const CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Color(0xFF093824),
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Color(0xFFF08700),
                  shape: BoxShape.circle,
                ),
                defaultTextStyle: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _pickTime(start: true),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF093824)),
                    child: Text(
                      _startTime == null ? 'Godzina start' : 'Start: ${_startTime!.hour}:${_startTime!.minute.toString().padLeft(2, '0')}',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _pickTime(start: false),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF093824)),
                    child: Text(
                      _endTime == null ? 'Godzina koniec' : 'Koniec: ${_endTime!.hour}:${_endTime!.minute.toString().padLeft(2, '0')}',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _lokal,
              decoration: const InputDecoration(
                labelText: 'Lokal',
                filled: true,
                fillColor: Colors.white24,
                labelStyle: TextStyle(color: Colors.white),
              ),
              dropdownColor: Colors.black,
              style: const TextStyle(color: Colors.white),
              items: const [
                DropdownMenuItem(value: 'Ruczaj', child: Text('Ruczaj')),
                DropdownMenuItem(value: 'Wola Duchacka', child: Text('Wola Duchacka')),
              ],
              onChanged: (val) => setState(() => _lokal = val),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _kursyController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Liczba kursów (opcjonalnie)',
                filled: true,
                fillColor: Colors.white24,
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _kmController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Kilometry (opcjonalnie)',
                filled: true,
                fillColor: Colors.white24,
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _zapisz,
              icon: const Icon(Icons.save),
              label: const Text('Zapisz'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF725E54),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
