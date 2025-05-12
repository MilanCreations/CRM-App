import 'package:get/get.dart';

class ClockController extends GetxController {
  RxString username = 'Alexander Morales'.obs;
  RxString role = 'Employees'.obs;
  RxString status = 'On Time'.obs;

  RxString clockInTime = '08:45:00'.obs;
  RxString clockOutTime = '17:10:00'.obs;

  RxBool isClockedIn = false.obs;
  RxBool isClockedOut = false.obs;

  void toggleClockIn() {
    isClockedIn.value = true;
  }

  void toggleClockOut() {
    isClockedOut.value = true;
  }
}
