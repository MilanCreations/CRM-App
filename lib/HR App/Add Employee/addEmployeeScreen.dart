import 'package:crm_milan_creations/HR%20App/Add%20Employee/addEmployeeController.dart';
import 'package:crm_milan_creations/HR%20App/Department%20List/departmentListController.dart';
import 'package:crm_milan_creations/HR%20App/Department%20List/departmentListModel.dart';
import 'package:crm_milan_creations/HR%20App/Employee%20Designation/empDesignationController.dart';
import 'package:crm_milan_creations/HR%20App/Employee%20Designation/empDesignationModel.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/utils/font-styles.dart';
import 'package:crm_milan_creations/widgets/appBar.dart';
import 'package:crm_milan_creations/widgets/button.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddemployeeScreen extends StatefulWidget {

  const AddemployeeScreen({super.key});

  @override
  State<AddemployeeScreen> createState() => _AddemployeeScreenState();
}

class _AddemployeeScreenState extends State<AddemployeeScreen> {
  final AddEmployeeController employeeFormController = Get.put(
    AddEmployeeController(),
  );
  final DepartmentlistController departmentlistController = Get.put(
    DepartmentlistController(),
  );

  final DesignationListController designationListController = Get.put(
    DesignationListController(),
  );

  @override
  void initState() {
    departmentlistController.departmentListFunction();
    designationListController.designationListFunction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
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
                    () =>
                        employeeFormController.profileImage.value != null
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
                          const Text("Joining Date"),
                          const SizedBox(height: 8),
                          TextField(
                            readOnly: true,
                            onTap: employeeFormController.selectJoinDate,
                            decoration: InputDecoration(
                              hintText:
                                  employeeFormController.joinDate.value != null
                                      ? DateFormat('MM/dd/yyyy').format(
                                        employeeFormController.joinDate.value!,
                                      )
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
                    child: Text(
                      "No departments available",
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Department", style: TextStyle(fontSize: 16)),
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
                            items:
                                departmentlistController.departmentList
                                    .map(
                                      (Department item) =>
                                          DropdownMenuItem<Department>(
                                            value: item,
                                            child: Text(
                                              item.name,
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                    )
                                    .toList(),
                            value:
                                departmentlistController.selectedDepartment.value,
                            onChanged: (Department? value) {
                              departmentlistController.selectedDepartment.value =
                                  value;
                              if (value != null) {
                                 employeeFormController.department.value = value.id.toString();
                              }
                            },
                            buttonStyleData: ButtonStyleData(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              height: 50,
                            ),
                            dropdownStyleData: DropdownStyleData(maxHeight: 200),
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
                    child: Text(
                      "No Designation available",
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Designation", style: TextStyle(fontSize: 16)),
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
                            hint: Text(
                              'Select Department',
                              style: TextStyle(color: Colors.grey),
                            ),
                            items:
                                designationListController.designationList
                                    .map(
                                      (Designation item) =>
                                          DropdownMenuItem<Designation>(
                                            value: item,
                                            child: Text(
                                              item.name,
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ),
                                    )
                                    .toList(),
                            value:
                                designationListController
                                    .selectedDesignation
                                    .value,
                            onChanged: (Designation? value) {
                              designationListController
                                  .selectedDesignation
                                  .value = value;
                              if (value != null) {
                                 employeeFormController.designation.value = value.id.toString();
                              }
                            },
                            buttonStyleData: ButtonStyleData(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              height: 50,
                            ),
                            dropdownStyleData: DropdownStyleData(maxHeight: 200),
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
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      "Phone Number",
                      controller: employeeFormController.phoneController,
                      hint: "Enter Phone...",
                      keyboardType: TextInputType.phone,
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
              Text(
                "Pan card",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
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
                            right: BorderSide(color: CRMColors.black, width: 1),
                          ),
                        ),
                        padding: EdgeInsets.only(right: 16),
                        child: Text(
                          "Choose file",
                          style: TextStyle(
                            color: Colors.grey.shade900,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Obx(
                          () => Text(
                            employeeFormController.panCardFile.value == null
                                ? "No file chosen"
                                : employeeFormController.panCardFile.value!.path
                                    .split('/')
                                    .last,
        
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              overflow: TextOverflow.ellipsis,
                            ),
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
                            right: BorderSide(color: CRMColors.black, width: 1),
                          ),
                        ),
                        padding: EdgeInsets.only(right: 16),
                        child: Text(
                          "Choose file",
                          style: TextStyle(
                            color: Colors.grey.shade900,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Obx(
                          () => Text(
                            // employeeFormController.aadhaarCardFile.value.isEmpty
                            //     ? "No file chosen"
                            //     : employeeFormController.aadhaarCardFile.value,
                            employeeFormController.aadhaarCardFile.value == null
                                ? "No file chosen"
                                : employeeFormController
                                    .aadhaarCardFile
                                    .value!
                                    .path
                                    .split('/')
                                    .last,
        
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              overflow: TextOverflow.ellipsis,
                            ),
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
                      // employeeFormController.addEmployeeFunction(
                      //   departmentlistController.selectedDepartment.value?.id ?? "",
                      //   designationListController.selectedDesignation.value?.id ?? "",
                      // );
                    },
                  ),
                  SizedBox(width: 10),
                  CustomButton(
                    width: Get.width * 0.4,
                    backgroundColor: CRMColors.crmMainCOlor,
                    text: 'Send Invite',
                    onPressed: () {
                      employeeFormController.inviteemployeeFunction();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
       // Loading overlay
        Obx(() => employeeFormController.isLoading.value
            ? Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(CRMColors.crmMainCOlor),
                  ),
                ),
              )
            : const SizedBox.shrink()),
        ]
      ),
   
    );
  }

  Widget _buildTextField(
    String label, {
    TextEditingController? controller,
    String? hint,
    IconData? suffixIcon,
    TextInputType? keyboardType, // <-- added here
    int? maxLength,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType, // <-- and used here
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

  Widget designation(
    String label, {
    required List<String> items,
    required RxString selected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        Obx(
          () => DropdownButtonFormField<String>(
            decoration: const InputDecoration(border: OutlineInputBorder()),
            value: selected.value.isEmpty ? null : selected.value,
            items:
                items
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
            onChanged: (value) {
              if (value != null) selected.value = value;
            },
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
              hintText:
                  time.value != null
                      ? time.value!.format(Get.context!)
                      : "hh:mm aa",
              suffixIcon: const Icon(Icons.access_time),
              border: const OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

}
