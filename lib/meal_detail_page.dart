import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MealDetailPage extends StatefulWidget {
  const MealDetailPage({super.key});

  @override
  _MealDetailPageState createState() => _MealDetailPageState();
}

class _MealDetailPageState extends State<MealDetailPage> {
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<String>> events = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('식단 상세'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TableCalendar(
              focusedDay: _focusedDay,
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (_selectedDay != null) {
                    events[_selectedDay!] = (events[_selectedDay!] ?? [])
                      ..add('새로운 식단');
                  }
                });
              },
              child: const Text('카드 추가'),
            ),
            Expanded(
              child: ListView(
                children: (events[_selectedDay] ?? []).map((event) {
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(title: Text(event)),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
