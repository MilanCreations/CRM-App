import 'package:crm_milan_creations/Employee/Get%20All%20Employees%20List/getAllEmployeeeListController.dart';
import 'package:crm_milan_creations/Lead%20Management/Creat%20lead%20Source%20List/SourcesInLeadController.dart';
import 'package:crm_milan_creations/Lead%20Management/Creat%20lead%20Source%20List/SourcesInLeadModel.dart';
import 'package:crm_milan_creations/Lead%20Management/Create%20Leads/createLeadController.dart';
import 'package:crm_milan_creations/Lead%20Management/Get%20All%20Companies%20list/getAllCompaniesController.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/utils/font-styles.dart';
import 'package:crm_milan_creations/widgets/appBar.dart';
import 'package:crm_milan_creations/widgets/button.dart';
import 'package:crm_milan_creations/widgets/textfiled.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CreateLeadsScreen extends StatefulWidget {
  final String token;
  final String name;
  final String visitTime;
  final String employeeid;
  const CreateLeadsScreen({
    super.key,
    required this.token,
    required this.name,
    required this.visitTime,
    required this.employeeid,
  });

  @override
  State<CreateLeadsScreen> createState() => _CreateLeadsScreenState();
}

class _CreateLeadsScreenState extends State<CreateLeadsScreen> {
  TextEditingController assignToController = TextEditingController();

  String? selectedCompany;
  String? assignEmployee;
  // final List<String> sourceItems = [
  //   'WalkIn',
  //   'Website',
  //   'Referral',
  //   'Advertisement',
  //   'Social Media',
  //   'Other',
  // ];
  // final List<String> company = ['Venus Studies'];
  final Getallemployeelistcontroller getallemployeelistcontroller = Get.put(
    Getallemployeelistcontroller(),
  );
  final GetallCompanieslistcontroller getallCompanieslistcontroller = Get.put(
    GetallCompanieslistcontroller(),
  );

  final CreateLeadcontroller createLeadcontroller = Get.put(
    CreateLeadcontroller(),
  );

  final SourcesInLeadcontroller sourcesInLeadcontroller = Get.put(
    SourcesInLeadcontroller(),
  );

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        createLeadcontroller.datetimeController.text = DateFormat(
          'yyyy-MM-dd',
        ).format(picked);
      });
    }
  }

  Future<void> _selectDateTime() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final DateTime finalDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        setState(() {
          createLeadcontroller.datetimeController.text = DateFormat(
            'MM-dd-yyyy hh:mm',
          ).format(finalDateTime);
        });
        print(
          "date and time:- ${createLeadcontroller.datetimeController.text}",
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    assignToController.text = widget.name;
    getallemployeelistcontroller.getAllEmployeeListFunction();
    getallCompanieslistcontroller.getAllCompaniesListFunction();
    sourcesInLeadcontroller.sourceListFunction();
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
          text: 'Create Leads',
          color: CRMColors.whiteColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: CRMColors.crmMainCOlor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTextFormField(
                label: 'Name',
                controller: createLeadcontroller.nameController,
                backgroundColor: CRMColors.whiteColor,
              ),

              const SizedBox(height: 12),
              GestureDetector(
                onTap: _selectDateTime,
                child: AbsorbPointer(
                  child: CustomTextFormField(
                    backgroundColor: CRMColors.whiteColor,
                    label: 'Select Date & Time',
                    controller: createLeadcontroller.datetimeController,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              CustomTextFormField(
                label: 'Email',
                controller: createLeadcontroller.emailController,
                backgroundColor: CRMColors.whiteColor,
              ),
              const SizedBox(height: 12),

              CustomTextFormField(
                label: 'Phone',
                controller: createLeadcontroller.phoneController,
                keyboardType: TextInputType.phone,
                backgroundColor: CRMColors.whiteColor,
              ),
              const SizedBox(height: 12),

              CustomTextFormField(
                label: 'Branch Name',
                controller: createLeadcontroller.branchNameController,
                backgroundColor: CRMColors.whiteColor,
              ),
              const SizedBox(height: 12),

             Obx(() {
  if (sourcesInLeadcontroller.isLoading.value) {
    return const Center(child: CircularProgressIndicator());
  }
  if (sourcesInLeadcontroller.sourceList.isEmpty) {
    return const Center(
      child: CustomText(text: 'No Source list found'),
    );
  }

  return Container(
    height: Get.height * 0.067,
    decoration: BoxDecoration(
      color: CRMColors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton2<Source>(
        isExpanded: true,
        hint: const Text(
          'Select Source',
          style: TextStyle(color: Colors.grey),
        ),
        items: sourcesInLeadcontroller.sourceList
            .map<DropdownMenuItem<Source>>((source) {
              return DropdownMenuItem<Source>(
                value: source,
                child: Text(
                  source.name,
                  style: const TextStyle(fontSize: 16),
                ),
              );
            })
            .toList(),
        value: sourcesInLeadcontroller.selectedSource.value,
        onChanged: (Source? newValue) {
          if (newValue != null) {
            sourcesInLeadcontroller.selectedSource.value = newValue;
          }
        },
        buttonStyleData: const ButtonStyleData(
          padding: EdgeInsets.symmetric(horizontal: 16),
          height: 50,
        ),
        dropdownStyleData: const DropdownStyleData(
          maxHeight: 200,
        ),
      ),
    ),
  );
}),
              const SizedBox(height: 12),

              CustomTextFormField(
                label: 'Address',
                controller: createLeadcontroller.addressController,
                backgroundColor: CRMColors.whiteColor,
              ),

              const SizedBox(height: 12),

              CustomTextFormField(
                label: 'Purpose',
                controller: createLeadcontroller.purposeController,
                backgroundColor: CRMColors.whiteColor,
              ),

              const SizedBox(height: 12),

              CustomTextFormField(
                label: 'Enter Query Type',
                controller: createLeadcontroller.queryTypeController,
                backgroundColor: CRMColors.whiteColor,
              ),

              // const SizedBox(height: 12),

              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     CustomText(
              //       text: 'Assign Info',
              //       fontWeight: FontWeight.bold,
              //       fontSize: 20,
              //     ),
              //   ],
              // ),

              // const SizedBox(height: 12),
              // Obx(() {
              //   return CustomDropdownButton2(
              //     hint: CustomText(text: 'Select Company'),
              //     value: selectedCompany,
              //     dropdownItems:
              //         getallCompanieslistcontroller.companiesList.toList(),
              //     onChanged: (value) {
              //       setState(() {
              //         selectedCompany = value; // ✅ Correct variable
              //         print(value);
              //       });
              //     },
              //   );
              // }),
              /* const SizedBox(height: 12),
              Obx(() {
                return CustomDropdownButton2(
                  hint: CustomText(text: 'Asign To'),
                  value: assignEmployee,
                  dropdownItems:
                      getallemployeelistcontroller.employeeList.toList(),
                  onChanged: (value) {
                    setState(() {
                      assignEmployee = value;
                    });
                  },
                );
              }), */
              const SizedBox(height: 12),

              CustomTextFormField(
                label: '',
                controller: assignToController,
                backgroundColor: CRMColors.whiteColor,
                showLabel: false,
                readOnly: true,
              ),
              SizedBox(height: 15),
              CustomButton(
                text: 'Register',
                onPressed: () {
                  if(sourcesInLeadcontroller.selectedSource.value != null){
                    createLeadcontroller.createLeadCOntrollerFunction(
                    context,
                   sourcesInLeadcontroller.selectedSource.value!.name,
                    widget.token,
                    widget.employeeid,
                    widget.visitTime,
                  );
                  } else{
                     Get.snackbar(
      "Validation Error",
      "Please select a lead source.",
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );
                  }
                  
                },
                gradient: const LinearGradient(
                  colors: [Color(0xFFEC32B1), Color(0xFF0C46CC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
