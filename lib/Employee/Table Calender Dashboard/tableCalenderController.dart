import 'package:crm_milan_creations/Employee/Attendance%20History/allendanceHistoryMode.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';

class TableCalendarController extends GetxController {
  var focusedDay = DateTime.now().obs;
  var selectedDay = DateTime.now().obs;

  // Map of attendance status for each date
  var attendanceStatusMap = <DateTime, String>{}.obs;

  void onDaySelected(DateTime selected, DateTime focused) {
    selectedDay.value = selected;
    focusedDay.value = focused;
  }

  /// Map attendance list to a map of DateTime -> status string
void mapAttendanceStatus(List<Attendance> attendanceList) {
  final map = <DateTime, String>{};
  for (var att in attendanceList) {
    final normalizedDate = DateTime(
      att.attendanceDate.year,
      att.attendanceDate.month,
      att.attendanceDate.day,
    );
    print('Mapping attendance: $normalizedDate -> ${att.status}');
    map[normalizedDate] = att.status.toLowerCase();
  }

  // ✅ Merge with existing map instead of replacing
  attendanceStatusMap.addAll(map);
}






  /// Get status for a specific date
String getStatus(DateTime date) {
  // Normalize input date
  final normalizedDate = DateTime(date.year, date.month, date.day);

  final statusEntry = attendanceStatusMap.entries.firstWhereOrNull(
    (entry) => entry.key.year == normalizedDate.year &&
               entry.key.month == normalizedDate.month &&
               entry.key.day == normalizedDate.day,
  );

  print('Checking date: $normalizedDate — Found entry: ${statusEntry?.key}, Status: ${statusEntry?.value}');
  return statusEntry?.value ?? ''; 
}



}