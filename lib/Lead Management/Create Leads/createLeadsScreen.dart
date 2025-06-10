import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crm_milan_creations/Auth/noInternetScreen.dart';
import 'package:crm_milan_creations/Employee/Get%20All%20Employees%20List/getAllEmployeeeListController.dart';
import 'package:crm_milan_creations/Lead%20Management/Creat%20lead%20Source%20List/SourcesInLeadController.dart';
import 'package:crm_milan_creations/Lead%20Management/Creat%20lead%20Source%20List/SourcesInLeadModel.dart';
import 'package:crm_milan_creations/Lead%20Management/Create%20Leads/createLeadController.dart';
import 'package:crm_milan_creations/Lead%20Management/Get%20All%20Companies%20list/getAllCompaniesController.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/utils/font-styles.dart';
import 'package:crm_milan_creations/widgets/appBar.dart';
import 'package:crm_milan_creations/widgets/button.dart';
import 'package:crm_milan_creations/widgets/connectivity_service.dart';
import 'package:crm_milan_creations/widgets/textfiled.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
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

    NointernetScreen noInternetScreen = const NointernetScreen();
  final ConnectivityService _connectivityService = ConnectivityService();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

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
       _checkInitialConnection();
   _setupConnectivityListener();
  }

    @override
  void dispose() {
   _connectivitySubscription.cancel();
    super.dispose();
  }

      Future<void> _checkInitialConnection() async {
    if (!(await _connectivityService.isConnected())) {
      _connectivityService.showNoInternetScreen();
    }
  }

    void _setupConnectivityListener() {
    _connectivitySubscription = _connectivityService.listenToConnectivityChanges(
      onConnected: () {
        // Optional: You can automatically go back if connection is restored
        // Get.back();
      },
      onDisconnected: () {
        _connectivityService.showNoInternetScreen();
      },
    );
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
  padding: const EdgeInsets.all(16),
  child: SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: CRMColors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildSectionTitle('Lead Details'),
              const SizedBox(height: 12),

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
                    label: 'Select Date & Time',
                    controller: createLeadcontroller.datetimeController,
                    backgroundColor: CRMColors.whiteColor,
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
                maxLength: 10,
              ),
              const SizedBox(height: 12),

              CustomTextFormField(
                label: 'Branch Name',
                controller: createLeadcontroller.branchNameController,
                backgroundColor: CRMColors.whiteColor,
              ),
              const SizedBox(height: 12),

              _buildSectionTitle('Source of Lead'),
              const SizedBox(height: 8),
              Obx(() {
                if (sourcesInLeadcontroller.isLoading.value) {
                  return _buildShimmerLoader();
                }

                if (sourcesInLeadcontroller.sourceList.isEmpty) {
                  return const Center(child: CustomText(text: 'No Source list found'));
                }

                return _buildDropdownSource();
              }),
              const SizedBox(height: 12),

              _buildSectionTitle('Additional Details'),
              const SizedBox(height: 8),

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
              const SizedBox(height: 12),

              CustomTextFormField(
                label: 'Lead Creator',
                controller: assignToController,
                backgroundColor: CRMColors.whiteColor,
                readOnly: true,
              ),
              const SizedBox(height: 20),

              Obx(() {
                return createLeadcontroller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(
                        text: 'Register',
                        onPressed: () {
                           if(createLeadcontroller.nameController.text.isEmpty) {
                            Get.snackbar(
                              "Message",
                              "Enter Name",
                              backgroundColor: Colors.redAccent,
                              colorText: Colors.white,
                            );
                          }

                          else if(createLeadcontroller.datetimeController.text.isEmpty) {
                            Get.snackbar(
                              "Message",
                              "Select Date & Time",
                              backgroundColor: Colors.redAccent,
                              colorText: Colors.white,
                            );
                          }

                           else if(createLeadcontroller.phoneController.text.isEmpty) {
                            Get.snackbar(
                              "Message",
                              "Enter Phone Number",
                              backgroundColor: Colors.redAccent,
                              colorText: Colors.white,
                            );
                          }

                           else if(createLeadcontroller.branchNameController.text.isEmpty) {
                            Get.snackbar(
                              "Message",
                              "Enter Branch Name",
                              backgroundColor: Colors.redAccent,
                              colorText: Colors.white,
                            );
                          }

                           else if(createLeadcontroller.purposeController.text.isEmpty) {
                            Get.snackbar(
                              "Message",
                              "Enter Purpose",
                              backgroundColor: Colors.redAccent,
                              colorText: Colors.white,
                            );
                          }  else if (sourcesInLeadcontroller.selectedSource.value != null) {
                            createLeadcontroller.createLeadCOntrollerFunction(
                              context,
                              sourcesInLeadcontroller.selectedSource.value!.name,
                              widget.token,
                              widget.employeeid,
                              widget.visitTime,
                            );
                          } 
                        },
                        gradient: const LinearGradient(
                          colors: [Color(0xFFEC32B1), Color(0xFF0C46CC)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      );
              }),
            ],
          ),
        ),
      ],
    ),
  ),
),

    );
  }

  Widget _buildSectionTitle(String title) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: CRMColors.black1,
      ),
    ),
  );
}

Widget _buildShimmerLoader() {
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
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          child: FadeShimmer(
            height: 15,
            width: 150,
            radius: 4,
            millisecondsDelay: 300,
            fadeTheme: FadeTheme.light,
          ),
        ),
      );
    }),
  );
}

Widget _buildDropdownSource() {
  return Container(
    height: 55,
    decoration: BoxDecoration(
      color: CRMColors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey.shade400),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton2<Source>(
        isExpanded: true,
        hint: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: CustomText(
            text: 'Select Source',
            color: CRMColors.black1,
            fontWeight: FontWeight.w500,
          ),
        ),
        items: sourcesInLeadcontroller.sourceList.map((source) {
          return DropdownMenuItem<Source>(
            value: source,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                source.name,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          );
        }).toList(),
        value: sourcesInLeadcontroller.selectedSource.value,
        onChanged: (Source? newValue) {
          if (newValue != null) {
            sourcesInLeadcontroller.selectedSource.value = newValue;
          }
        },
        buttonStyleData: const ButtonStyleData(
          padding: EdgeInsets.only(right: 12),
          height: 50,
        ),
        dropdownStyleData: const DropdownStyleData(maxHeight: 200),
      ),
    ),
  );
}

}
