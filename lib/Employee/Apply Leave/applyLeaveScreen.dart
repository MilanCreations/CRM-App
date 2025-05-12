import 'package:crm_milan_creations/Employee/Apply%20Leave/applyLeaveController.dart';
import 'package:crm_milan_creations/Employee/leave%20Type/leaveTypeController.dart';
import 'package:crm_milan_creations/Employee/leave%20Type/leaveTypeModel.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/utils/font-styles.dart';
import 'package:crm_milan_creations/widgets/appBar.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
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
      border: OutlineInputBorder(),
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 14),
    );

    return Scaffold(
      backgroundColor: CRMColors.whiteColor,
      appBar: CustomAppBar(title: const Text('Leave Request')),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
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
                          hintText: "MM/DD/YYYY hh:mm aa",
                          suffixIcon: Icon(Icons.calendar_today_outlined),
                        ),
                        controller: TextEditingController(
                          text:
                              leaveRequestcontroller.startDateTime.value == null
                                  ? ''
                                  : DateFormat.yMd().add_jm().format(
                                    leaveRequestcontroller.startDateTime.value!,
                                  ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
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
                          hintText: "MM/DD/YYYY hh:mm aa",
                          suffixIcon: Icon(Icons.calendar_today_outlined),
                        ),
                        controller: TextEditingController(
                          text:
                              leaveRequestcontroller.endDateTime.value == null
                                  ? ''
                                  : DateFormat.yMd().add_jm().format(
                                    leaveRequestcontroller.endDateTime.value!,
                                  ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Obx(() {
                if (leaveTypeController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return Container(
                    height: Get.height * 0.067,
                    decoration: BoxDecoration(
                      color: CRMColors.cardBackground,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: CRMColors.black),
                    ),
                    child: DropdownButton2<Datum>(
                      underline: SizedBox(),
                      isExpanded: true,
                      hint: const CustomText(
                        text: 'Leave Type',
                        fontSize: 16,
                        color: CRMColors.darkGrey,
                      ),
                      value: leaveTypeController.selectedLeaveType.value,
                      selectedItemBuilder: (context) {
                        return leaveTypeController.leavtypeList.map((
                          Datum item,
                        ) {
                          return Row(
                            children: [
                             
                              Text(
                                item.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          );
                        }).toList();
                      },
                      items:
                          leaveTypeController.leavtypeList.map((datum) {
                            return DropdownMenuItem<Datum>(
                              value: datum,
                              child: Text(
                                datum.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                      onChanged: (Datum? value) {
                        leaveTypeController.selectedLeaveType.value = value;
                        
                           leaveRequestcontroller .leavetypeid = RxString(value!.id.toString()) ;
                      },
                    ),
                  );
                }
              }),

              const SizedBox(height: 20),
              TextFormField(
                controller: leaveRequestcontroller.reasonController,
                maxLines: 3,
                decoration: inputDecoration.copyWith(
                  labelText: "Reason",
                  hintText: "Enter reason",
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding:
                        EdgeInsets
                            .zero, // Remove default padding to use our own
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        12,
                      ), // Rounded corners
                    ),
                    elevation: 4, // Optional: to give some shadow
                    backgroundColor:
                        Colors.transparent, // Set to transparent for gradient
                    shadowColor: Colors.black45, // Optional: shadow color
                  ),
                  onPressed:(){
                  leaveRequestcontroller.submitLeaveRequest();
                  } ,
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF001B7A), // Dark Blue
                          Color(0xFF002B90), // Slightly Lighter Blue
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 14,
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "Submit",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
