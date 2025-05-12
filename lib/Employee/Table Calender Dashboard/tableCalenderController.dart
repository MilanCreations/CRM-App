import 'package:get/get.dart';

class CalendarController extends GetxController {
  Rx<DateTime> selectedDay = DateTime.now().obs;
  Rx<DateTime> focusedDay = DateTime.now().obs;

  // Sample attendance data
  RxMap<DateTime, String> attendanceMap = <DateTime, String>{
    DateTime.utc(2025, 5, 8): 'Present',
    DateTime.utc(2025, 5, 9): 'Absent',
    DateTime.utc(2025, 5, 10): 'Rejected',
  }.obs;

  void onDaySelected(DateTime selected, DateTime focused) {
    selectedDay.value = selected;
    focusedDay.value = focused;
  }
    String getStatus(DateTime day) {
    return attendanceMap[DateTime(day.year, day.month, day.day)] ?? '';
  }
}
