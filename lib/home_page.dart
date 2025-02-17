import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'database_helper.dart';
import 'household_page.dart';
import 'schedule_page.dart';
import 'meal_detail_page.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Map<String, dynamic>> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    final transactions = await DatabaseHelper().getTransactions();
    setState(() {
      _transactions = transactions;
    });
  }

  List<DateTime> _getWeekDays() {
    DateTime now = DateTime.now();
    int currentWeekday = now.weekday;
    DateTime sunday = now.subtract(Duration(days: currentWeekday % 7));
    return List.generate(7, (index) => sunday.add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BBUU'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  '가계부',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HouseholdPage()),
                    );
                  },
                  child: const Text('상세'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildSummaryCard('총 수입', 'XXX 원', '월별 수입 내역을 확인하세요.'),
            _buildSummaryCard('총 지출', 'XXX 원', '월별 지출 내역을 확인하세요.'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  '일정',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SchedulePage()),
                    );
                  },
                  child: const Text('상세'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildInfoCard('경환', 'XXX 건'),
                _buildInfoCard('믿음', 'XXX 건'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  '식단',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MealDetailPage()),
                    );
                  },
                  child: const Text('상세'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _getWeekDays().map((date) {
                  return Container(
                    width: 120,
                    child: _buildImageCard(
                      '${date.month}월 ${date.day}일 ${_getWeekdayName(date.weekday)}',
                      date.weekday % 2 == 0
                          ? 'assets/food/good_animation.json'
                          : 'assets/food/bad_animation.json',
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${_focusedDay.year}년 ${_focusedDay.month}월',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            TableCalendar(
              firstDay: DateTime.utc(1900, 1, 1),
              lastDay: DateTime.utc(DateTime.now().year + 3, 12, 31),
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
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  final transaction = _transactions.firstWhere(
                    (tx) => isSameDay(DateTime.parse(tx['date']), date),
                    orElse: () => {},
                  );
                  if (transaction.isNotEmpty) {
                    return Positioned(
                      bottom: 1,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        color: Colors.blue,
                        child: const Text(
                          '태그',
                          style: TextStyle(color: Colors.white, fontSize: 10),
                        ),
                      ),
                    );
                  }
                  return null;
                },
              ),
              calendarStyle: CalendarStyle(
                outsideDecoration: const BoxDecoration(
                  color: Colors.white, // ✅ 달력 배경을 흰색으로 변경
                ),
                todayTextStyle: const TextStyle(
                  color: Colors.black, // ✅ 당일 글씨 검은색 유지
                ),
                outsideDaysVisible: false, // ✅ 이전/다음 달 날짜 흐리게 표시
                todayDecoration: BoxDecoration(
                  shape: BoxShape.circle, // ✅ 원형 유지
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.blueAccent,
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekendStyle: TextStyle(color: Colors.red),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getWeekdayName(int weekday) {
    switch (weekday) {
      case 1:
        return '월요일';
      case 2:
        return '화요일';
      case 3:
        return '수요일';
      case 4:
        return '목요일';
      case 5:
        return '금요일';
      case 6:
        return '토요일';
      case 7:
        return '일요일';
      default:
        return '';
    }
  }

  Widget _buildSummaryCard(String title, String amount, String description) {
    return Card(
      child: ListTile(
        leading: Lottie.asset(
          title == '총 수입'
              ? 'assets/household/income_animation.json'
              : 'assets/household/expense_animation.json',
          width: 50,
          height: 50,
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            Text(amount),
          ],
        ),
        subtitle: Text(description),
      ),
    );
  }

  Widget _buildInfoCard(String title, String count) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text(count,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCard(String date, String animationPath) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(date, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Lottie.asset(animationPath, width: 100, height: 100),
          ],
        ),
      ),
    );
  }
}
