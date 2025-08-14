// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crm_milan_creations/Auth/noInternetScreen.dart';
import 'package:crm_milan_creations/HR%20App/Add%20Employee/addEmployeeController.dart';
import 'package:crm_milan_creations/HR%20App/Department%20List/departmentListController.dart';
import 'package:crm_milan_creations/HR%20App/Department%20List/departmentListModel.dart';
import 'package:crm_milan_creations/HR%20App/Employee%20Designation/empDesignationController.dart';
import 'package:crm_milan_creations/HR%20App/Employee%20Designation/empDesignationModel.dart';
import 'package:crm_milan_creations/HR%20App/Employee%20List/EmployeeListController.dart';
import 'package:crm_milan_creations/Razorpay%20Services/razorpay_services.dart';
import 'package:crm_milan_creations/Subscription/Check%20Subscripion/checkSubscriptionController.dart';
import 'package:crm_milan_creations/Subscription/Create%20Order/createOrderController.dart';
import 'package:crm_milan_creations/Subscription/Upgrade/upgradeController.dart';
import 'package:crm_milan_creations/Subscription/Verify%20Payment/verify-payment-Controller.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/utils/font-styles.dart';
import 'package:crm_milan_creations/widgets/appBar.dart';
import 'package:crm_milan_creations/widgets/button.dart';
import 'package:crm_milan_creations/widgets/connectivity_service.dart';
import 'package:crm_milan_creations/widgets/textfiled.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddemployeeScreen extends StatefulWidget {
  const AddemployeeScreen({super.key});

  @override
  State<AddemployeeScreen> createState() => _AddemployeeScreenState();
}

class _AddemployeeScreenState extends State<AddemployeeScreen> {
  final AddEmployeeController employeeFormController = Get.put(AddEmployeeController());
  final DepartmentlistController departmentlistController = Get.put(DepartmentlistController());
  final DesignationListController designationListController = Get.put(DesignationListController());
  final CheckEmployeesLengthcontroller checkEmployeesLengthcontroller = Get.put(CheckEmployeesLengthcontroller());
  final Createordercontroller createOrderController = Get.put(Createordercontroller());
  final VerifyPaymentController verifyPaymentController = Get.put(VerifyPaymentController());
  final UpgradeController upgradeController = Get.put(UpgradeController());
  final RazorpayService razorpayService = RazorpayService();
  final EmployeeListcontroller employeeListcontroller = Get.put(EmployeeListcontroller());

  NointernetScreen noInternetScreen = const NointernetScreen();
  final ConnectivityService _connectivityService = ConnectivityService();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  String totalEmployeesStroedInLocal = "0";

  @override
  void initState() {
    departmentlistController.departmentListFunction();
    designationListController.designationListFunction();
    _checkInitialConnection();
    _setupConnectivityListener();
    employeeListcontroller.employeeListFunction(isRefresh: true);
    checkEmployeesLengthcontroller.checkEmployeesLengthFunction();
    super.initState();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    RazorpayService.dispose();
    super.dispose();
  }

  Future<void> _checkInitialConnection() async {
    if (!(await _connectivityService.isConnected())) {
      _connectivityService.showNoInternetScreen();
    }
  }

  void _setupConnectivityListener() {
    _connectivitySubscription = _connectivityService.listenToConnectivityChanges(
      onConnected: () {},
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
          text: 'Add Employee',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: CRMColors.whiteColor,
        ),
        backgroundColor: CRMColors.crmMainCOlor,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Picture Placeholder
                Center(
                  child: const CustomText(
                    text: "Profile Picture",
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: GestureDetector(
                    onTap: () => employeeFormController.pickFileImage(),
                    child: Obx(
                      () => employeeFormController.profileImage.value != null
                          ? CircleAvatar(
                              radius: 50,
                              backgroundImage: FileImage(
                                employeeFormController.profileImage.value!,
                              ),
                            )
                          : const CircleAvatar(
                              radius: 50,
                              child: Icon(Icons.camera_alt),
                            ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Joining Date and Name
                Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomText(text: "Joining Date"),
                            const SizedBox(height: 8),
                            TextField(
                              readOnly: true,
                              onTap: employeeFormController.selectJoinDate,
                              decoration: InputDecoration(
                                hintText: employeeFormController.joinDate.value != null
                                    ? DateFormat('MM/dd/yyyy').format(
                                        employeeFormController.joinDate.value!)
                                    : "MM/DD/YYYY",
                                suffixIcon: const Icon(Icons.calendar_today),
                                border: const OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        "Name",
                        controller: employeeFormController.nameController,
                        hint: "Enter Name...",
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Email and Department
                _buildTextField(
                  "Email",
                  controller: employeeFormController.emailController,
                  hint: "Enter Email...",
                ),
                const SizedBox(height: 16),

                Obx(() {
                  if (departmentlistController.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  } else if (departmentlistController.departmentList.isEmpty) {
                    return Container(
                      padding: EdgeInsets.all(16),
                      child: CustomText(
                        text: "No departments available",
                        color: Colors.grey,
                      ),
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(text: "Department", fontSize: 16),
                        SizedBox(height: 8),
                        Container(
                          height: Get.height * 0.067,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: CRMColors.black),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<Department>(
                              isExpanded: true,
                              hint: Text(
                                'Select Department',
                                style: TextStyle(color: Colors.grey),
                              ),
                              items: departmentlistController.departmentList
                                  .map(
                                    (Department item) => DropdownMenuItem<Department>(
                                      value: item,
                                      child: CustomText(
                                        text: item.name,
                                        fontSize: 16,
                                      ),
                                    ),
                                  )
                                  .toList(),
                              value: departmentlistController.selectedDepartment.value,
                              onChanged: (Department? value) {
                                departmentlistController.selectedDepartment.value = value;
                                if (value != null) {
                                  employeeFormController.department.value = value.id.toString();
                                }
                              },
                              buttonStyleData: ButtonStyleData(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                height: 50,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                maxHeight: 200,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                }),

                const SizedBox(height: 16),
                Obx(() {
                  if (designationListController.isLoading.value) {
                    return Center(child: CircularProgressIndicator());
                  } else if (designationListController.designationList.isEmpty) {
                    return Container(
                      padding: EdgeInsets.all(16),
                      child: CustomText(
                        text: "No Designation available",
                        color: Colors.grey,
                      ),
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(text: "Designation", fontSize: 16),
                        SizedBox(height: 8),
                        Container(
                          height: Get.height * 0.067,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: CRMColors.black),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<Designation>(
                              isExpanded: true,
                              hint: CustomText(
                                text: 'Select Department',
                                color: Colors.grey,
                              ),
                              items: designationListController.designationList
                                  .map(
                                    (Designation item) => DropdownMenuItem<Designation>(
                                      value: item,
                                      child: CustomText(
                                        text: item.name,
                                        fontSize: 16,
                                      ),
                                    ),
                                  )
                                  .toList(),
                              value: designationListController.selectedDesignation.value,
                              onChanged: (Designation? value) {
                                designationListController.selectedDesignation.value = value;
                                if (value != null) {
                                  employeeFormController.designation.value = value.id.toString();
                                }
                              },
                              buttonStyleData: ButtonStyleData(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                height: 50,
                              ),
                              dropdownStyleData: DropdownStyleData(
                                maxHeight: 200,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                }),

                const SizedBox(height: 16),

                // Emergency Contact and Address
                _buildTextField(
                  "Emergency Contact",
                  controller: employeeFormController.emergencyContactController,
                  hint: "Enter emergency contact...",
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                ),
                const SizedBox(height: 16),

                _buildTextField(
                  "Address",
                  controller: employeeFormController.addressController,
                  hint: "Enter address...",
                ),
                const SizedBox(height: 16),

                // Salary and Phone
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        "Salary",
                        controller: employeeFormController.salaryController,
                        hint: "Enter Salary...",
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        "Phone Number",
                        controller: employeeFormController.phoneController,
                        hint: "Enter Phone...",
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Shift Time Pickers
                Row(
                  children: [
                    Expanded(
                      child: _buildTimePicker(
                        "Shift Start",
                        employeeFormController.shiftStart,
                        () => employeeFormController.selectTime(isStart: true),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTimePicker(
                        "Shift End",
                        employeeFormController.shiftEnd,
                        () => employeeFormController.selectTime(isStart: false),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                CustomText(
                  text: 'Account Details',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  "Bank Name",
                  controller: employeeFormController.bankNameController,
                  hint: "Enter Bank Name...",
                ),

                const SizedBox(height: 16),
                _buildTextField(
                  "Account Number",
                  controller: employeeFormController.accountNumberController,
                  hint: "Enter Account Number...",
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  "IFSC Code",
                  controller: employeeFormController.ifscController,
                  hint: "Enter IFSC Code...",
                ),

                SizedBox(height: 16),
                CustomText(
                  text: "Pan card",
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () => employeeFormController.pickFile(true),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: CRMColors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: CRMColors.black,
                                width: 1,
                              ),
                            ),
                          ),
                          padding: EdgeInsets.only(right: 16),
                          child: CustomText(
                            text: "Choose file",
                            color: Colors.grey.shade900,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Obx(
                            () => CustomText(
                              text: employeeFormController.panCardFile.value == null
                                  ? "No file chosen"
                                  : employeeFormController.panCardFile.value!.path.split('/').last,
                              color: Colors.grey.shade600,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 16),
                CustomText(
                  text: "Adhaar card",
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
                SizedBox(height: 8),
                GestureDetector(
                  onTap: () => employeeFormController.pickFile(false),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: CRMColors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: CRMColors.black,
                                width: 1,
                              ),
                            ),
                          ),
                          padding: EdgeInsets.only(right: 16),
                          child: CustomText(
                            text: "Choose file",
                            color: Colors.grey.shade900,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Obx(
                            () => CustomText(
                              text: employeeFormController.aadhaarCardFile.value == null
                                  ? "No file chosen"
                                  : employeeFormController.aadhaarCardFile.value!.path.split('/').last,
                              color: Colors.grey.shade600,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomButton(
                      width: Get.width * 0.4,
                      text: 'Cancel',
                      onPressed: () {
                        Get.back();
                      },
                    ),
                    SizedBox(width: 10),
                    CustomButton(
                      width: Get.width * 0.4,
                      backgroundColor: CRMColors.crmMainCOlor,
                      text: 'Send Invite',
                      onPressed: () {
                        _validateAndSubmit();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Obx(
            () => employeeFormController.isLoading.value
                ? Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          CRMColors.crmMainCOlor,
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  void _validateAndSubmit() {
    if (employeeFormController.joinDate.value == null) {
      Get.snackbar(
        "Message",
        "Select Joining Date",
        backgroundColor: CRMColors.error,
        colorText: CRMColors.textWhite,
      );
    } else if (employeeFormController.nameController.text.isEmpty) {
      Get.snackbar(
        "Message",
        "Enter employee name",
        backgroundColor: CRMColors.error,
        colorText: CRMColors.textWhite,
      );
    } else if (employeeFormController.emailController.text.isEmpty) {
      Get.snackbar(
        "Message",
        "Enter email",
        backgroundColor: CRMColors.error,
        colorText: CRMColors.textWhite,
      );
    } else if (departmentlistController.selectedDepartment.value == null) {
      Get.snackbar(
        "Message",
        "Select Department",
        backgroundColor: CRMColors.error,
        colorText: CRMColors.textWhite,
      );
    } else if (designationListController.selectedDesignation.value == null) {
      Get.snackbar(
        "Message",
        "Select Designation",
        backgroundColor: CRMColors.error,
        colorText: CRMColors.textWhite,
      );
    } else if (employeeFormController.emergencyContactController.text.isEmpty) {
      Get.snackbar(
        "Message",
        "Enter Contact number",
        backgroundColor: CRMColors.error,
        colorText: CRMColors.textWhite,
      );
    } else if (employeeFormController.addressController.text.isEmpty) {
      Get.snackbar(
        "Message",
        "Enter Address",
        backgroundColor: CRMColors.error,
        colorText: CRMColors.textWhite,
      );
    } else if (employeeFormController.salaryController.text.isEmpty) {
      Get.snackbar(
        "Message",
        "Enter Salary",
        backgroundColor: CRMColors.error,
        colorText: CRMColors.textWhite,
      );
    } else if (employeeFormController.phoneController.text.isEmpty) {
      Get.snackbar(
        "Message",
        "Enter Phone Number",
        backgroundColor: CRMColors.error,
        colorText: CRMColors.textWhite,
      );
    } else if (employeeFormController.shiftStart.value == null) {
      Get.snackbar(
        "Message",
        "Enter Shift Start Time",
        backgroundColor: CRMColors.error,
        colorText: CRMColors.textWhite,
      );
    } else if (employeeFormController.shiftEnd.value == null) {
      Get.snackbar(
        "Message",
        "Enter Shift End Time",
        backgroundColor: CRMColors.error,
        colorText: CRMColors.textWhite,
      );
    } else if (employeeListcontroller.employeeList.length >= 5) {
      _showUpgradeDialog();
    } else {
      employeeFormController.inviteemployeeFunction();
    }
  }

  Widget _buildTextField(
    String label, {
    required TextEditingController controller,
    String? hint,
    IconData? suffixIcon,
    TextInputType? keyboardType,
    int? maxLength,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(text: label),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLength: maxLength,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
            border: const OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildTimePicker(
    String label,
    Rx<TimeOfDay?> time,
    VoidCallback onTap,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        Obx(
          () => TextField(
            readOnly: true,
            onTap: onTap,
            decoration: InputDecoration(
              hintText: time.value != null ? time.value!.format(Get.context!) : "hh:mm aa",
              suffixIcon: const Icon(Icons.access_time),
              border: const OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  void _showUpgradeDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.upgrade_rounded,
                size: 48,
                color: Colors.blueAccent,
              ),
              const SizedBox(height: 16),
              const Text(
                "Upgrade Plan",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                "You've reached the maximum number of employees. Upgrade your plan to continue adding more.",
                style: TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.grey[700], fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFEC32B1), Color(0xFF0C46CC)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          _openUpgradeBottomSheet();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Upgrade Now",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _openUpgradeBottomSheet() {
    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Add Employees',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              CustomTextFormField(
                label: 'Number of employees (1–9)',
                keyboardType: TextInputType.number,
                backgroundColor: CRMColors.background,
                controller: createOrderController.employeeCountController,
                onChanged: (val) {
                  createOrderController.employeeCount.value = val;
                },
              ),

              Obx(() {
                final count = int.tryParse(createOrderController.employeeCount.value) ?? 0;
                if (count > 0 && count <= 9) {
                  final base = count * 100;
                  final total = (base * 1.18).round();
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Total Amount: ₹${total.toStringAsFixed(2)} (₹$base + 18% GST)',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              }),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.grey[700], fontSize: 16),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Obx(() {
                      final isLoading = createOrderController.isLoading.value ||
                          verifyPaymentController.isLoading.value ||
                          upgradeController.isLoading.value;

                      return Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFEC32B1), Color(0xFF0C46CC)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () => _handleUpgradePayment(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text(
                                  "Add Employees",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      isDismissible: true,
      enableDrag: true,
    );
  }

  Future<void> _handleUpgradePayment() async {
    try {
      final count = int.tryParse(createOrderController.employeeCountController.text.trim()) ?? 0;

      if (count < 1 || count > 9) {
        Get.snackbar(
          "Error",
          "Please enter a number between 1 and 9",
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
        return;
      }

      // 1️⃣ Upgrade to get usageId
      final upgradeSuccess = await upgradeController.upgradeFunction(count);
      if (!upgradeSuccess || upgradeController.upgradeModel.value?.data?.usageId?.id == null) {
        throw Exception('Failed to upgrade or get usage ID');
      }
      final usageId = upgradeController.upgradeModel.value!.data!.usageId!.id;

      // 2️⃣ Create Razorpay order
      await createOrderController.createOrderFunction();
      if (createOrderController.orderId.value.isEmpty) {
        throw Exception('Failed to create order');
      }

      // 3️⃣ Calculate total amount (base + GST)
      final total = (count * 100 * 1.18).round();

      // Close bottom sheet before payment
      Get.back();

      // 4️⃣ Start Razorpay Payment
      RazorpayService.makePayment(
        amount: total,
        name: 'Employee Upgrade',
        email: employeeFormController.emailController.text.isNotEmpty 
            ? employeeFormController.emailController.text 
            : 'test@gmail.com',
        contact: employeeFormController.phoneController.text.isNotEmpty
            ? employeeFormController.phoneController.text
            : '9898989898',
        description: "Adding $count employees",
        orderId: createOrderController.orderId.value,
        onSuccess: (res) async {
          // 5️⃣ Verify payment with backend
          final verifySuccess = await verifyPaymentController.verifyPayment(
            razorpayOrderId: res.orderId ?? '',
            razorpayPaymentId: res.paymentId ?? '',
            razorpaySignature: res.signature ?? '',
            usageId: usageId,
          );

          if (verifySuccess) {
            // 6️⃣ Add employee
            await employeeFormController.inviteemployeeFunction();
            
            // Clear fields only after successful addition
            createOrderController.employeeCountController.clear();
            
            Get.snackbar(
              "Success",
              "Employee added successfully!",
              backgroundColor: Colors.green,
              colorText: CRMColors.textWhite,
            );
          }
        },
        onError: (err) {
          Get.snackbar(
            "Payment Failed",
            err.message ?? "Payment failed",
            backgroundColor: CRMColors.error,
            colorText: CRMColors.textWhite,
          );
        },
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: CRMColors.error,
        colorText: CRMColors.textWhite,
      );
    }
  }
}