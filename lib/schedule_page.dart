import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('일정 관리'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: TableCalendar(
              firstDay: DateTime.utc(1900, 1, 1),
              lastDay: DateTime.utc(DateTime.now().year + 3, 12, 31), // ✅ 3년 뒤 12월까지 이동 가능
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
              },
              calendarStyle: CalendarStyle(
              outsideDecoration: const BoxDecoration(
                color: Colors.white, // ✅ 달력 배경을 흰색으로 변경
              ),
              todayDecoration: BoxDecoration(
                shape: BoxShape.circle, // ✅ 원형 유지
              ),
              todayTextStyle: const TextStyle(
                color: Colors.black, // ✅ 당일 글씨 검은색 유지
              ),
                outsideDaysVisible: false, // ✅ 이전/다음 달 날짜 흐리게 표시
              ),
              availableGestures: AvailableGestures.all,
              onDayLongPressed: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onDisabledDayTapped: (day) {
                // ✅ 이전/다음 달 날짜 클릭 시 자동 이동
                setState(() {
                  _focusedDay = day;
                });
              },
            ),
          ),
          Expanded(
            child: _selectedDay == null
                ? const Center(child: Text('선택된 일정이 없습니다.'))
                : Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: const [
                            ListTile(
                              title: Text('일정 1'),
                              subtitle: Text('공유: 나'),
                            ),
                            ListTile(
                              title: Text('일정 2'),
                              subtitle: Text('공유: 배우자'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 일정 추가 로직
        },
        tooltip: '일정 추가',
        child: const Icon(Icons.add),
      ),
    );
  }
}
