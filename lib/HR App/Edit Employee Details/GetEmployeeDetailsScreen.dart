// ignore_for_file: deprecated_member_use

import 'package:crm_milan_creations/HR%20App/Department%20List/departmentListController.dart';
import 'package:crm_milan_creations/HR%20App/Department%20List/departmentListModel.dart';
import 'package:crm_milan_creations/HR%20App/Edit%20Employee%20Details/Edit%20Employee%20Details/editEmployeeDetailsController.dart';
import 'package:crm_milan_creations/HR%20App/Edit%20Employee%20Details/GetEmployeeDetailsController.dart';
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

class EditEmployeeScreen extends StatefulWidget {
  final String editEmployeeDetails;
 const EditEmployeeScreen({super.key, required this.editEmployeeDetails});

  @override
  State<EditEmployeeScreen> createState() => _EditEmployeeScreenState();
}

class _EditEmployeeScreenState extends State<EditEmployeeScreen> {

  GetEmployeeDetailsController getEmployeeDetailsController = Get.put(
    GetEmployeeDetailsController(),
  );
  final DepartmentlistController departmentlistController = Get.put(
    DepartmentlistController(),
  );

  final DesignationListController designationListController = Get.put(
    DesignationListController(),
  );

  final Editemployeedetailscontroller editEmployeeDetailsController =
      Get.put(Editemployeedetailscontroller());
      
  @override
  void initState() {
    getEmployeeDetailsController.editEmployeeFunction(
      widget.editEmployeeDetails,
    );
    departmentlistController.departmentListFunction();
    designationListController.designationListFunction();
    super.initState();
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
          text: 'Edit Employee',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: CRMColors.whiteColor,
        ),
        backgroundColor: CRMColors.crmMainCOlor,
      ),
      body: Obx(
        () {
          if (getEmployeeDetailsController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
          return Stack(
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
                  // getEmployeeDetailsController.profile_pic.value.isEmpty?
                  Center(
                    child: GestureDetector(
                      onTap: () => getEmployeeDetailsController.pickFileImage(),
                      child: Obx(() {
                        final pickedImage =
                            getEmployeeDetailsController.profileImage.value;
                        final networkImage =
                            getEmployeeDetailsController.profile_pic.value;
        
                        if (pickedImage != null) {
                          return CircleAvatar(
                            radius: 50,
                            backgroundImage: FileImage(pickedImage),
                          );
                        } else if (networkImage.isNotEmpty) {
                          return CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(networkImage),
                          );
                        } else {
                          return const CircleAvatar(
                            radius: 50,
                            child: Icon(Icons.camera_alt),
                          );
                        }
                      }),
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
                                controller:
                                    getEmployeeDetailsController.joinController,
                                readOnly: true,
                                onTap:
                                    getEmployeeDetailsController.selectJoinDate,
                                decoration: InputDecoration(
                                  hintText:
                                      getEmployeeDetailsController
                                                  .joinDate
                                                  .value !=
                                              null
                                          ? DateFormat('MM/dd/yyyy').format(
                                            getEmployeeDetailsController
                                                .joinDate
                                                .value!,
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
                          controller:
                              getEmployeeDetailsController.nameController,
                          hint: "Enter Name...",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
        
                  // Email and Department
                  _buildTextField(
                    "Email",
                    controller: getEmployeeDetailsController.emailController,
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
                                    departmentlistController
                                        .selectedDepartment
                                        .value,
                                onChanged: (Department? value) {
                                  departmentlistController
                                      .selectedDepartment
                                      .value = value;
                                  if (value != null) {
                                    getEmployeeDetailsController
                                        .department
                                        .value = value.id.toString();
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
                    } else if (designationListController
                        .designationList
                        .isEmpty) {
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
                                    getEmployeeDetailsController
                                        .designation
                                        .value = value.id.toString();
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
                    controller:
                        getEmployeeDetailsController.emergencyContactController,
                    hint: "Enter emergency contact...",
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                  ),
                  const SizedBox(height: 16),
        
                  _buildTextField(
                    "Address",
                    controller: getEmployeeDetailsController.addressController,
                    hint: "Enter address...",
                  ),
                  const SizedBox(height: 16),
        
                  // Salary and Phone
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          "Salary",
                          controller:
                              getEmployeeDetailsController.salaryController,
                          hint: "Enter Salary...",
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          "Phone Number",
                          controller:
                              getEmployeeDetailsController.phoneController,
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
                          getEmployeeDetailsController.shiftStart,
                          () => getEmployeeDetailsController.selectTime(
                            isStart: true,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTimePicker(
                          "Shift End",
                          getEmployeeDetailsController.shiftEnd,
                          () => getEmployeeDetailsController.selectTime(
                            isStart: false,
                          ),
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
                    controller: getEmployeeDetailsController.bankNameController,
                    hint: "Enter Bank Name...",
                  ),
        
                  const SizedBox(height: 16),
                  _buildTextField(
                    "Account Number",
                    controller:
                        getEmployeeDetailsController.accountNumberController,
                    hint: "Enter Account Number...",
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    "IFSC Code",
                    controller: getEmployeeDetailsController.ifscController,
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
                    onTap: () => getEmployeeDetailsController.pickFile(true),
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
                                getEmployeeDetailsController.panCardFile.value ==
                                        null
                                    ? "No file chosen"
                                    : getEmployeeDetailsController
                                        .panCardFile
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
                  SizedBox(height: 8),
        
                  Obx(
                    () => CustomText(
                      text:
                          getEmployeeDetailsController.panCard.value.isEmpty
                              ? "No file chosen"
                              : getEmployeeDetailsController.panCard.value
                                  ,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: CRMColors.crmMainCOlor,
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
                    onTap: () => getEmployeeDetailsController.pickFile(false),
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
                                getEmployeeDetailsController
                                            .aadhaarCardFile
                                            .value ==
                                        null
                                    ? "No file chosen"
                                    : getEmployeeDetailsController
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
                   SizedBox(height: 8),
        
                  Obx(
                    () => CustomText(
                      text:
                          getEmployeeDetailsController.aadharCard.value.isEmpty
                              ? "No file chosen"
                              : getEmployeeDetailsController.aadharCard.value
                                  ,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: CRMColors.crmMainCOlor,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButton(
                        backgroundColor: CRMColors.crmMainCOlor,
                        width: Get.width * 0.4,
                        text: 'Cancel',
                        onPressed: () {},
                      ),
                      SizedBox(width: 10),
                      CustomButton(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFEC32B1), Color(0xFF0C46CC)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        width: Get.width * 0.4,
                        // backgroundColor: CRMColors.crmMainCOlor,
                        text: 'Save Changes',
                        onPressed: () {
                        //  getEmployeeDetailsController.editEmployeeFunction(
                        //     widget.editEmployeeDetails,
                        //   );
                          editEmployeeDetailsController.editEmployeeFunction(
                         
                            widget.editEmployeeDetails,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Loading overlay
            Obx(
              () =>
                  getEmployeeDetailsController.isLoading.value
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
        );
      
        },
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

//    Widget _buildProfileImage() {
//   return GestureDetector(
//     onTap: _showFullScreenImage,
//     child: Container(
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         border: Border.all(
//           color: CRMColors.crmMainCOlor,
//           width: 2,
//         ),
//       ),
//       child: _getProfileImageWidget(),
//     ),
//   );
// }



// void _showFullScreenImage() {
//   if (getEmployeeDetailsController.profile_pic.isEmpty) return;
  
//   try {
//     Widget imageWidget;
    
//     // Check if it's a file path
//     final file = File(getEmployeeDetailsController.profile_pic.toString());
//     if (file.existsSync()) {
//       imageWidget = Image.file(file);
//     } 
//     // Check if it's a network URL
//     else if (getEmployeeDetailsController.profile_pic.startsWith('http')) {
//       imageWidget = Image.network(getEmployeeDetailsController.profile_pic.toString());
//     }
//     // Assume it's base64 if neither
//     else {
//       final imageBytes = base64Decode(getEmployeeDetailsController.profile_pic.toString());
//       imageWidget = Image.memory(imageBytes);
//     }

//     Get.dialog(
//       Dialog(
//         child: InteractiveViewer(
//           panEnabled: true,
//           minScale: 0.5,
//           maxScale: 3.0,
//           child: imageWidget,
//         ),
//       ),
//     );
//   } catch (e) {
//     print('Error showing full screen image: $e');
//     Get.snackbar(
//       "Error",
//       "Could not display image",
//       backgroundColor: CRMColors.error,
//       colorText: CRMColors.textWhite,
//     );
//   }
// }


// Widget _getProfileImageWidget() {
//   if (getEmployeeDetailsController.profile_pic.value.isEmpty) {
//     return const CircleAvatar(
//       radius: 50,
//       backgroundColor: Colors.grey,
//       child: Icon(Icons.person, size: 50, color: Colors.white),
//     );
//   }

//   try {
//     // Check if it's a file path
//     final file = File(getEmployeeDetailsController.profile_pic.toString());
//     if (file.existsSync()) {
//       return CircleAvatar(
//         radius: 50,
//         backgroundImage: FileImage(file),
//       );
//     }
//     // Check if it's a network URL
//     else if (getEmployeeDetailsController.profile_pic.startsWith('http')) {
//       return CircleAvatar(
//         radius: 50,
//         backgroundImage: NetworkImage(getEmployeeDetailsController.profile_pic.toString()),
//       );
//     }
//     // Assume it's base64 if neither
//     else {
//       final imageBytes = base64Decode(getEmployeeDetailsController.profile_pic.toString());
//       return CircleAvatar(
//         radius: 50,
//         backgroundImage: MemoryImage(imageBytes),
//       );
//     }
//   } catch (e) {
//     print('Error loading profile image: $e');
//     return const CircleAvatar(
//       radius: 50,
//       backgroundColor: Colors.grey,
//       child: Icon(Icons.person, size: 50, color: Colors.white),
//     );
//   }
// }


}
