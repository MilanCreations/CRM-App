import 'package:crm_milan_creations/Employee/Attendance%20History/attendanceHistoryController.dart';
import 'package:crm_milan_creations/Employee/Table%20Calender%20Dashboard/tableCalenderController.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/utils/font-styles.dart';
import 'package:crm_milan_creations/widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final AttendanceHistoryController attendanceHistoryController = Get.put(
    AttendanceHistoryController(),
  );

  final TableCalendarController tableController = Get.put(
    TableCalendarController(),
  );

  late ScrollController _scrollController;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);

    // Fetch today's attendance only
    attendanceHistoryController.AttendanceHistoryfunctions(isRefresh: true);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      attendanceHistoryController.AttendanceHistoryfunctions();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  String formatDateTime(DateTime dateTime) {
    try {
      DateTime localDateTime = dateTime.toLocal();
      return DateFormat('hh:mm a').format(localDateTime);
    } catch (e) {
      return "";
    }
  }

  String formatDateOnly(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      return DateFormat('MMMM d, yyyy').format(date);
    } catch (e) {
      return "";
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: CustomAppBar(
      showBackArrow: true,
       leadingIcon: Icons.arrow_back_ios_new_sharp,
      gradient: const LinearGradient(
        colors: [Color(0xFFEC32B1), Color(0xFF0C46CC)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      title: CustomText(
        text: 'Attendance History',
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: CRMColors.whiteColor,
      ),
    ),
    body: PageView.builder(
      scrollDirection: Axis.vertical,
      controller: PageController(
        initialPage: 0,
      ),
      onPageChanged: (index) {
        final newDate = DateTime(
          tableController.focusedDay.value.year,
          tableController.focusedDay.value.month + index,
        );
        tableController.focusedDay.value = newDate;
      },
    itemBuilder: (context, index) {
  return Obx(() {
    final DateTime currentMonth = DateTime(
      tableController.focusedDay.value.year,
      tableController.focusedDay.value.month + index,
    );

    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: currentMonth,
      calendarFormat: CalendarFormat.month,
      headerVisible: true,
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
      },
      selectedDayPredicate: (day) =>
          isSameDay(tableController.selectedDay.value, day),
      onDaySelected: tableController.onDaySelected,
      calendarStyle: CalendarStyle(
        selectedDecoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
        todayDecoration: BoxDecoration(
          color: Colors.grey.shade300,
          shape: BoxShape.circle,
        ),
        defaultTextStyle: const TextStyle(color: Colors.red),
        selectedTextStyle: const TextStyle(color: Colors.white),
        weekendTextStyle: const TextStyle(color: Colors.red),
      ),
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, day, focusedDay) {
          final isSunday = day.weekday == DateTime.sunday;
          if (isSunday) {
            return Center(
              child: Text(
                '${day.day}',
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }

          final status = tableController.getStatus(day);

          Color dotColor;
          switch (status) {
            case 'approved':
              dotColor = Colors.green;
              break;
            case 'pending':
            case 'rejected':
              dotColor = Colors.orange;
              break;
            default:
              dotColor = Colors.transparent;
          }

          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 28,
                  decoration: BoxDecoration(
                    color: dotColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      '${day.day}',
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  });
}

    ),
  );
}

}
