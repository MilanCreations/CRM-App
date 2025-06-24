import 'package:crm_milan_creations/Employee/Apply%20Leave/applyLeaveController.dart';
import 'package:crm_milan_creations/Employee/leave%20Type/leaveTypeController.dart';
import 'package:crm_milan_creations/Employee/leave%20Type/leaveTypeModel.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/utils/font-styles.dart';
import 'package:crm_milan_creations/widgets/appBar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class LeaveRequestScreen extends StatelessWidget {
  final leaveRequestcontroller = Get.put(LeaveRequestController());
  final leaveTypeController = Get.put(LeaveTypeController());

  LeaveRequestScreen({super.key});

  Future<void> pickDateTime(Rx<DateTime?> dateTime) async {
    DateTime now = DateTime.now();
    DateTime today = DateTime(
      now.year,
      now.month,
      now.day,
    ); // removes time part

    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: today,
      firstDate: today, // disallow past dates
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: Get.context!,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        dateTime.value = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: CRMColors.crmMainCOlor, width: 1.5),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      labelStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14),
    );

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: CustomAppBar(
        showBackArrow: true,
        leadingIcon: Icons.arrow_back_ios_new_sharp,
        title: const CustomText(
          text: 'Leave Request',
          color: CRMColors.whiteColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        gradient: const LinearGradient(
          colors: [Color(0xFFEC32B1), Color(0xFF0C46CC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => TextFormField(
                            readOnly: true,
                            onTap:
                                () => pickDateTime(
                                  leaveRequestcontroller.startDateTime,
                                ),
                            decoration: inputDecoration.copyWith(
                              labelText: "Start Date & Time",
                              hintText: "Select date and time",
                              suffixIcon: Icon(
                                Icons.calendar_today_outlined,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            controller: TextEditingController(
                              text:
                                  leaveRequestcontroller
                                              .startDateTime
                                              .value ==
                                          null
                                      ? ''
                                      : DateFormat(
                                        'MMM dd, yyyy hh:mm a',
                                      ).format(
                                        leaveRequestcontroller
                                            .startDateTime
                                            .value!,
                                      ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Obx(
                          () => TextFormField(
                            readOnly: true,
                            onTap:
                                () => pickDateTime(
                                  leaveRequestcontroller.endDateTime,
                                ),
                            decoration: inputDecoration.copyWith(
                              labelText: "End Date & Time",
                              hintText: "Select date and time",
                              suffixIcon: Icon(
                                Icons.calendar_today_outlined,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            controller: TextEditingController(
                              text:
                                  leaveRequestcontroller.endDateTime.value ==
                                          null
                                      ? ''
                                      : DateFormat(
                                        'MMM dd, yyyy hh:mm a',
                                      ).format(
                                        leaveRequestcontroller
                                            .endDateTime
                                            .value!,
                                      ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Obx(() {
                    if (leaveTypeController.isLoading.value) {
                      return Column(
                        children: List.generate(1, (index) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            height: 55,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: CRMColors.grey),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 14,
                              ),
                              child: Row(
                                children: [
                                  FadeShimmer(
                                    height: 15,
                                    width: 150,
                                    radius: 4,
                                    millisecondsDelay: 300,
                                    fadeTheme: FadeTheme.light,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      );
                    } else {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<Datum>(
                            isExpanded: true,
                            hint: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 1),
                              child: Text(
                                'Select Leave Type',
                                style: TextStyle(
                                  // fontSize: 16,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ),
                            value:
                                leaveTypeController.selectedLeaveType.value,
                            selectedItemBuilder: (context) {
                              return leaveTypeController.leavtypeList.map((
                                Datum item,
                              ) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Text(
                                    item.name,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey.shade800,
                                    ),
                                  ),
                                );
                              }).toList();
                            },
                            items:
                                leaveTypeController.leavtypeList.map((datum) {
                                  return DropdownMenuItem<Datum>(
                                    value: datum,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: Text(
                                        datum.name,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey.shade800,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                            onChanged: (Datum? value) {
                              leaveTypeController.selectedLeaveType.value =
                                  value;
                              leaveRequestcontroller.leavetypeid = RxString(
                                value!.id.toString(),
                              );
                            },
                            buttonStyleData: ButtonStyleData(
                              height: 56,
                              padding: EdgeInsets.only( right: 10),
                            ),
                            dropdownStyleData: DropdownStyleData(
                              maxHeight: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                              ),
                            ),
                            menuItemStyleData: MenuItemStyleData(height: 48),
                          ),
                        ),
                      );
                    }
                  }),
                  
                  SizedBox(height: 20),
                  TextFormField(
                    controller: leaveRequestcontroller.reasonController,
                    maxLines: 4,
                    decoration: inputDecoration.copyWith(
                      labelText: "Reason for Leave",
                      hintText: "Enter your reason here...",
                      alignLabelWithHint: true,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            Obx(() {
  return leaveRequestcontroller.isLoading.value
      ? const CircularProgressIndicator()
      : Center(
        child: Container(
            width: Get.width * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                colors: [Color(0xFFEC32B1), Color(0xFF0C46CC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                minimumSize: const Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                leaveRequestcontroller.submitLeaveRequest();
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                child: CustomText(
                  text: "Submit Request",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      );
})

         
          ],
        ),
      ),
    );
  }
}
