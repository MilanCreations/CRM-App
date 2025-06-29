import 'dart:async';
import 'dart:math';

import 'package:crm_milan_creations/Employee/Attendance%20History/attendanceHistoryController.dart';
import 'package:crm_milan_creations/Employee/Dashboard/dashboardController.dart';
import 'package:crm_milan_creations/Employee/Table%20Calender%20Dashboard/tableCalenderController.dart';
import 'package:crm_milan_creations/Employee/check%20clockin%20status/check-In-StatusController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/widgets/appBar.dart';
import 'package:crm_milan_creations/widgets/button.dart';
import 'package:crm_milan_creations/utils/font-styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class Dashboardscreen extends StatefulWidget {
  final String checkpagestatus;
  const Dashboardscreen({super.key, required this.checkpagestatus});

  @override
  State<Dashboardscreen> createState() => _DashboardscreenState();
}

class _DashboardscreenState extends State<Dashboardscreen> {
  late CheckClockInController checkClockInController;
  final DashboardController controller = Get.put(DashboardController());
  final TableCalendarController tableController = Get.put(
    TableCalendarController(),
  );
  final AttendanceHistoryController attendanceHistoryController = Get.put(
    AttendanceHistoryController(),
  );

  RxString totalHoursToday = '0h 00m'.obs;
  RxString totalWorkingHoursToday = '0h 00m'.obs;
  String username = "";
  Timer? workingTimeTimer;
  String name = "";

  @override
  void initState() {
    print(widget.checkpagestatus);
    checkClockInController = Get.put(
      CheckClockInController(checkpagestatus: widget.checkpagestatus),
    );
    checkClockInController.getlocaldata();
    getUserData();
    attendanceHistoryController.AttendanceHistoryfunctions();

    // Start timer to update working hours every second
workingTimeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
  if (checkClockInController.checkInTime.value.isNotEmpty) {
    if (checkClockInController.checkOutTime.value.isEmpty || 
        checkClockInController.checkOutTime.value == "checkout") {
      calculateCurrentWorkingHours();
    } else {
      calculateTotalHoursToday();
    }
  } else {
    timer.cancel();
  }
});

    print("Check In Time: ${checkClockInController.checkInTime}");
    super.initState();
  }

  @override
  void dispose() {
    workingTimeTimer?.cancel();
    super.dispose();
  }

  Future<void> getUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      username = sharedPreferences.getString("fullname") ?? "";
      name = sharedPreferences.getString('name') ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CRMColors.whiteColor,
      appBar: CustomAppBar(
        gradient: const LinearGradient(
          colors: [Color(0xFFEC32B1), Color(0xFF0C46CC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        title: Row(
          children: [
            CustomText(
              text: "Hello ",
              fontWeight: FontWeight.w400,
              fontSize: 18,
              color: CRMColors.whiteColor,
            ),
            CustomText(
              text: username.toString(),
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: CRMColors.whiteColor,
            ),
          ],
        ),
        actions: [
          Obx(() {
            final picture = checkClockInController.pictureuser.value;
            final pickedImage = controller.image.value;

            Widget avatar;

            if (pickedImage != null) {
              avatar = CircleAvatar(
                radius: 25,
                backgroundImage: FileImage(pickedImage),
              );
            } else if (picture.isNotEmpty && picture.toLowerCase() != 'null') {
              avatar = CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(picture),
              );
            } else {
              avatar = const CircleAvatar(
                radius: 25,
                backgroundColor: CRMColors.grey,
                child: Icon(Icons.person, color: Colors.white),
              );
            }

            return GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder:
                      (_) => Dialog(
                        backgroundColor: Colors.transparent,
                        insetPadding: const EdgeInsets.all(20),
                        child: InteractiveViewer(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child:
                                pickedImage != null
                                    ? Image.file(pickedImage, fit: BoxFit.cover)
                                    : (picture.isNotEmpty &&
                                        picture.toLowerCase() != 'null')
                                    ? Image.network(picture, fit: BoxFit.cover)
                                    : const Icon(
                                      Icons.person,
                                      size: 100,
                                      color: Colors.white,
                                    ),
                          ),
                        ),
                      ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: avatar,
              ),
            );
          }),
        ],
      ),

      body: Obx(() {
        if (checkClockInController.checkInTime.toString() == "checkin") {
          return showcheckin();
        } else {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    todayTime(),
                    const SizedBox(height: 16),
                    checkInTime(),
                    const SizedBox(height: 10),
                    startBreakTime(),
                    const SizedBox(height: 10),
                    endBreakTime(),

                    // const SizedBox(height: 10),
                    // totalWorkingHours(),
                    // const SizedBox(height: 10),
                    Obx(
                      () => Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.redAccent.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            CustomText(text: "Working Time:", fontSize: 17),
                            Spacer(),
                            CustomText(
                              text:
                                  checkClockInController
                                              .checkOutTime
                                              .value
                                              .isNotEmpty &&
                                          checkClockInController
                                                  .checkOutTime
                                                  .value !=
                                              "checkout"
                                      ? totalHoursToday.value
                                      : totalWorkingHoursToday.value,
                              color: CRMColors.black,
                              fontSize: 21.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    checkOutTime(),

                    const SizedBox(height: 10),
                    showbuttonbreakinout(),
                    const SizedBox(height: 20),

                    CustomText(
                      text: "Today's Attendance",
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),

                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              color: Colors.green,
                              margin: const EdgeInsets.only(right: 6),
                            ),
                            CustomText(text: 'Present'),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              color: Colors.red,
                              margin: const EdgeInsets.only(right: 6),
                            ),
                            CustomText(text: 'Absent'),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              color: Colors.orange,
                              margin: const EdgeInsets.only(right: 6),
                            ),
                            CustomText(text: 'Pending'),
                          ],
                        ),
                      ],
                    ),

                    Obx(
                      () => TableCalendar(
                        firstDay: DateTime.utc(2020, 1, 1),
                        lastDay: DateTime.utc(2030, 12, 31),

                        focusedDay: tableController.focusedDay.value,
                        selectedDayPredicate:
                            (day) => isSameDay(
                              tableController.selectedDay.value,
                              day,
                            ),
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
                          selectedTextStyle: TextStyle(color: Colors.white),
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
                                dotColor = Colors.orange;
                                break;
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
                                      // pill shape
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${day.day}',
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    CustomText(
                      text: "Today's Task",
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),

              // API Loader
              if (controller.isLoading.value)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.blue),
                  ),
                ),
            ],
          );
        }
      }),
    );
  }

  Color _getDotColor(String status) {
    switch (status) {
      case 'Present':
        return CRMColors.succeed;
      case 'Absent':
        return CRMColors.error;
      case 'Rejected':
        return Colors.orange;
      default:
        return Colors.transparent;
    }
  }

  String formatUtcTime(String utcTimeString) {
    if (utcTimeString.isEmpty) return "";
    try {
      DateTime utcTime = DateTime.parse(utcTimeString);
      DateTime localTime = utcTime.toLocal();
      return DateFormat('hh:mm a').format(localTime);
    } catch (e) {
      return "";
    }
  }

  void calculateTotalHoursToday() {
    try {
      final checkInStr = checkClockInController.checkInTime.value;
      final breakStartStr = checkClockInController.breackinTime.value;
      final breakEndStr = checkClockInController.breackOutTime.value;
      final checkOutStr = checkClockInController.checkOutTime.value;

      if (checkInStr.isEmpty) {
        totalHoursToday.value = "0h 00m";
        return;
      }

      final checkIn = DateTime.parse(checkInStr).toLocal();
      final checkOut =
          checkOutStr.isNotEmpty
              ? DateTime.parse(checkOutStr).toLocal()
              : DateTime.now();

      Duration totalWorkedDuration = checkOut.difference(checkIn);

      // Subtract break duration if both start and end times are available
      if (breakStartStr.isNotEmpty && breakEndStr.isNotEmpty) {
        final breakStart = DateTime.parse(breakStartStr).toLocal();
        final breakEnd = DateTime.parse(breakEndStr).toLocal();

        if (breakStart.isAfter(checkIn) &&
            breakEnd.isBefore(checkOut) &&
            breakEnd.isAfter(breakStart)) {
          final breakDuration = breakEnd.difference(breakStart);
          totalWorkedDuration -= breakDuration;
        }
      }

      final hours = totalWorkedDuration.inHours;
      final minutes = totalWorkedDuration.inMinutes.remainder(60);

      totalHoursToday.value =
          "${hours}h ${minutes.toString().padLeft(2, '0')}m";
    } catch (e) {
      totalHoursToday.value = "0h 00m";
    }
  }

  void calculateCurrentWorkingHours() {
    final checkInStr = checkClockInController.checkInTime.value;
    final breakStartStr = checkClockInController.breackinTime.value;
    final breakEndStr = checkClockInController.breackOutTime.value;

    if (checkInStr.isEmpty) {
      totalWorkingHoursToday.value = "0h 00m";
      return;
    }

    final checkIn = DateTime.parse(checkInStr).toLocal();
    final now = DateTime.now();

    Duration workedDuration = now.difference(checkIn);

    // Subtract break duration if both start and end times are available
    if (breakStartStr.isNotEmpty && breakEndStr.isNotEmpty) {
      final breakStart = DateTime.parse(breakStartStr).toLocal();
      final breakEnd = DateTime.parse(breakEndStr).toLocal();

      // Ensure break time is within the working period
      if (breakStart.isAfter(checkIn) &&
          breakEnd.isBefore(now) &&
          breakEnd.isAfter(breakStart)) {
        final breakDuration = breakEnd.difference(breakStart);
        workedDuration -= breakDuration;
      }
    }

    if (workedDuration.isNegative) {
      // If something is wrong with timing, fallback to zero
      totalWorkingHoursToday.value = "0h 00m";
      return;
    }

    final hours = workedDuration.inHours;
    final minutes = workedDuration.inMinutes.remainder(60);

    totalWorkingHoursToday.value =
        "${hours}h ${minutes.toString().padLeft(2, '0')}m";
  }

  Widget showcheckin() {
    return Stack(
      children: [
        // Google Map Background
        Obx(
          () => GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                controller.latitude.value,
                controller.longitude.value,
              ),
              zoom: 16,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            markers: {
              Marker(
                markerId: MarkerId('currentLocation'),
                position: LatLng(
                  controller.latitude.value,
                  controller.longitude.value,
                ),
                infoWindow: InfoWindow(title: 'Your Location'),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRose,
                ),
              ),
            },
            onMapCreated: (controller) {
              this.controller.mapController = controller;
            },
          ),
        ),

        // Curved Background at Bottom
        Positioned(
          bottom: 0,

          child: SizedBox(
            width: MediaQuery.of(context).size.width * 1.5,
            height: 150,
            child: CustomPaint(painter: BellCurvePainter()),
          ),
        ),

        // Circular Check-in Button
        Positioned(
          bottom: 40, // Set this around the peak of the bell curve
          left:
              MediaQuery.of(context).size.width / 2 -
              40, // 40 = half of button width
          child: GestureDetector(
            onTap: () async {
              await controller.pickImageFromCamera();
              if (controller.image.value != null) {
                controller.clockInProcess(context);
              }
            },
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: CRMColors.crmMainCOlor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      blue: 0.5,
                      red: 0.5,
                      green: 0.5,
                    ),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Obx(() {
                  return controller.isLoading.value
                      ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                      : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.watch_later_rounded,
                            size: 30,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 4),
                          CustomText(
                            text: "Check In",
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      );
                }),
              ),
            ),
          ),
        ),
        // My Location Button (top right)
        Positioned(
          right: 16,
          top: 16,
          child: FloatingActionButton(
            mini: true,
            backgroundColor: Colors.white,
            child: Icon(Icons.my_location, color: Colors.blue),
            onPressed: () {
              if (controller.mapController != null) {
                controller.mapController!.animateCamera(
                  CameraUpdate.newLatLng(
                    LatLng(
                      controller.latitude.value,
                      controller.longitude.value,
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget todayTime() {
    return Visibility(
      visible: true,
      child: //  Position
          Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: CRMColors.dashboardClockInContainer),
        ),

        // Clock In/Out and Break Buttons
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center, // helps when multiline
          children: [
            CustomText(
              text: "Today, ${DateFormat('dd MMM ').format(DateTime.now())}",
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
            const Spacer(),
            Expanded(
              child: Obx(
                () => CustomText(
                  text: controller.location.value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  fontSize: 13.0,
                  fontFamily: 'Roboto',
                  color: CRMColors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget checkInTime() {
    if (checkClockInController.checkInTime.value != "checkin") {
      return Visibility(
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color.fromARGB(255, 177, 228, 179)),
          ),

          // Clock In/Out and Break Buttons
          child: Row(
            children: [
              CustomText(text: 'Checkin', fontSize: 17),
              const Spacer(),
              Obx(
                () => CustomText(
                  text:
                      checkClockInController.checkInTime.value.isNotEmpty
                          ? formatUtcTime(
                            checkClockInController.checkInTime.value,
                          )
                          : "0h 00m",

                  color: CRMColors.black,
                  fontSize: 21.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Visibility(visible: false, child: Text(""));
    }
  }

  Widget checkOutTime() {
    if (checkClockInController.checkOutTime.value.toString() != "checkout") {
      return Obx(
        () => Visibility(
          visible: true,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.redAccent.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
              // border: Border.all(color: const Color.fromARGB(255, 177, 228, 179)),
            ),

            // Clock In/Out and Break Buttons
            child: Row(
              children: [
                CustomText(text: "Checkout: ", fontSize: 17),
                Spacer(),
                CustomText(
                  text:
                      checkClockInController.checkOutTime.value.isNotEmpty
                          ? formatUtcTime(
                            checkClockInController.checkOutTime.value,
                          )
                          : "0h 00 m",

                  color: CRMColors.black,
                  fontSize: 21.0,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Visibility(visible: true, child: Text(""));
    }
  }

  Widget startBreakTime() {
    print("startBreakTime: ${checkClockInController.breackinTime.value}");
    if (checkClockInController.breackinTime.value.toString().isNotEmpty) {
      return Obx(
        () => Visibility(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),

            // Clock In/Out and Break Buttons
            child: Row(
              children: [
                CustomText(text: "Break Start: ", fontSize: 17),
                Spacer(),
                CustomText(
                  text:
                      checkClockInController.breackinTime.value.isNotEmpty
                          ? formatUtcTime(
                            checkClockInController.breackinTime.value,
                          )
                          : "0h 00m",

                  color: CRMColors.black,
                  fontSize: 21.0,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Visibility(visible: false, child: Text("0h 00 m"));
    }
  }

  Widget endBreakTime() {
    if (checkClockInController.breackOutTime.value.isNotEmpty) {
      return Obx(
        () => Visibility(
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),

            // Clock In/Out and Break Buttons
            child: Row(
              children: [
                CustomText(text: "Break End: ", fontSize: 17),
                Spacer(),
                CustomText(
                  text:
                      checkClockInController.breackOutTime.value.isNotEmpty
                          ? formatUtcTime(
                            checkClockInController.breackOutTime.value,
                          )
                          : "0h 00m",

                  color: CRMColors.black,
                  fontSize: 21.0,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Visibility(visible: false, child: Text("0h 00 m"));
    }
  }

  Widget totalWorkingHours() {
    return Visibility(
      visible: checkClockInController.checkInTime.value.isNotEmpty,
      child: Row(
        children: [
          const CustomText(text: "Total hours today: "),
          Obx(() {
            if (checkClockInController.checkOutTime.value.isEmpty) {
              calculateCurrentWorkingHours(); // before clock-out
              print("if statement");
            } else {
              print("else statement in total working hours widget");
              calculateTotalHoursToday(); // after clock-out
            }

            return CustomText(text: totalHoursToday.value);
          }),
        ],
      ),
    );
  }

  Widget showbuttonbreakinout() {
    return Obx(() {
      print(
        "showbuttonbreakinout: ${checkClockInController.checkOutTime.value}",
      );
      if (checkClockInController.checkOutTime.value.toString() != "checkout") {
        return Center(
          child: CustomText(
            text: "All done for today",
            fontWeight: FontWeight.bold,
          ),
        );
      } else {
        return Row(
          children: [
            Expanded(
              child: CustomButton(
                text:
                    controller.breakStartTime.value ? 'Break Out' : 'Break In',
                onPressed:
                    () =>
                        controller.breakStartTime.value
                            ? controller.breakOut(context)
                            : controller.breakIn(context),
                backgroundColor:
                    controller.breakStartTime.value
                        ? Colors.green
                        : Colors.orange,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomButton(
                text: 'Clock Out',
                onPressed: () {
                  controller.checkoutController(context);
                  stopAndResetWorkingTime();
                },
                backgroundColor: Colors.red,
              ),
            ),
          ],
        );
      }
    });
  }

void stopAndResetWorkingTime() {
  workingTimeTimer?.cancel();
  calculateTotalHoursToday(); // Calculate final hours when clocking out
}
}

// bell_curve_painter.dart

class BellCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white
          ..strokeWidth = 3
          ..style = PaintingStyle.fill;

    final path = Path();
    final double midHeight = size.height * 1.1;
    final double width = size.width;
    final double height = midHeight;

    // Bell curve parameters
    for (double x = 0; x <= width; x++) {
      double normX = (x / width) * 9 - 3; // range [-3, 3]
      double y = exp(-normX * normX / 4) / sqrt(2 * pi); // Gaussian formula
      double plotY = height - y * height * 2.5;

      if (x == 0) {
        path.moveTo(x, plotY);
      } else {
        path.lineTo(x, plotY);
      }
    }

    canvas.drawPath(path, paint);

    // Draw baseline
    /*  canvas.drawLine(
      Offset(0, height),
      Offset(width, height),
      Paint()
        ..color = Colors.black87
        ..strokeWidth = 2,
    ); */
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
