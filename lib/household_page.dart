import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'transaction_add_page.dart';

class HouseholdPage extends StatefulWidget {
  const HouseholdPage({super.key});

  @override
  _HouseholdPageState createState() => _HouseholdPageState();
}

class _HouseholdPageState extends State<HouseholdPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('가계부'),
      ),
      body: Column(
        children: [
          // 달력 위젯 영역
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
          // 거래 내역 요약 영역: 수익, 지출, 잔액 등을 표시
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Text('수익: 0'),
                Text('지출: 0'),
                Text('잔액: 0'),
              ],
            ),
          ),
          // 거래 내역 리스트 영역
          Expanded(
            child: ListView(
              children: [
                if (_selectedDay != null)
                  ListTile(
                    title: Text('선택된 날짜: ${_selectedDay.toString()}'),
                  ),
                // 거래 내역 리스트
                if (_selectedDay != null) // null 체크 추가
                  Expanded(
                    child: ListView(
                      children: const [
                        ListTile(title: Text('거래 내역 1')),
                        ListTile(title: Text('거래 내역 2')),
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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TransactionAddPage()),
          );
        },
        tooltip: '거래 추가',
        child: const Icon(Icons.add),
      ),
    );
  }
}
