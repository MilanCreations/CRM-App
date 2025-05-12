// ignore_for_file: avoid_print, non_constant_identifier_names

import 'dart:io';

import 'package:crm_milan_creations/API%20Services/BaseURL_&_EndPoints.dart';
import 'package:crm_milan_creations/Auth/Login/loginScreen.dart';
import 'package:crm_milan_creations/HR%20App/Edit%20Employee%20Details/GetEmployeeDetailsModel.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class GetEmployeeDetailsController extends GetxController{
  var isLoading = false.obs;
  var documentsList = [].obs;
  final allowedExtensions = {'png', 'jpg', 'jpeg', 'gif', 'pdf'};
   // Employee details
  RxString department = ''.obs;
  RxString designation = ''.obs;

    // Time and date observables
  Rx<TimeOfDay?> shiftStart = Rx<TimeOfDay?>(null);
  Rx<TimeOfDay?> shiftEnd = Rx<TimeOfDay?>(null);
  Rx<DateTime?> joinDate = Rx<DateTime?>(null);

  // File handling
  Rx<File?> panCardFile = Rx<File?>(null);
  Rx<File?> aadhaarCardFile = Rx<File?>(null);
  Rx<File?> profileImage = Rx<File?>(null);

   final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final salaryController = TextEditingController();
  final emergencyContactController = TextEditingController();
  final addressController = TextEditingController();
  final joinController = TextEditingController();

  final bankNameController = TextEditingController();
  final accountNumberController = TextEditingController();
  final ifscController = TextEditingController();
  final roleController = TextEditingController();
  


  var id = 0.obs;
  var user_id = 0.obs;
  var email = ''.obs;
  var name = ''.obs;
  var phone = ''.obs;
  var address = ''.obs; 
  var joindate = ''.obs;
  var salary = ''.obs;
  var bank_account = ''.obs;
  var bank_name = ''.obs; 
  var ifsc_code = ''.obs; 
  var company_id = ''.obs; 
  var department_id = ''.obs; 
  var designation_id = ''.obs; 
  var profile_pic = ''.obs; 
  var emergency_contact = ''.obs; 
  var role = ''.obs; 
  var shiftstart = ''.obs; 
  var shiftend = ''.obs; 
  var panCard = ''.obs; 
  var aadharCard = ''.obs; 


  Future<void> editEmployeeFunction(int editEmployeeDetails) async {
    print("Edit Employee Function called with ID: $editEmployeeDetails");
    try{
      isLoading.value = true;
        final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      isLoading.value = false;
      clearSharedPreferences();
      Get.snackbar("Error", "User is not authenticated. Login again!",
          backgroundColor: CRMColors.error, colorText: CRMColors.textWhite);
      return;
    }
      final url = Uri.parse(
        "${ApiConstants.employeeDetails}/$editEmployeeDetails");
  

        print("Sending request to URL in edit employee: $url");
        print("Employee ID: $editEmployeeDetails");
        print("Request headers: Authorization: Bearer $token");

    final response = await http.get(url,
    headers: {"Authorization": "Bearer $token"},
    );  
    print("API Status Code in Get Employee controller: ${response.statusCode}");
    print("Body Response in Get Employee controller: ${response.body}");

        if (response.statusCode == 200) {
      var editEmployeeDetailsModel = employeeDetailsModelFromJson(response.body);
       print("Get Employee details model called");
      documentsList.addAll(editEmployeeDetailsModel.data.documentType);
       id = RxInt(editEmployeeDetailsModel.data.id);
       user_id.value = (editEmployeeDetailsModel.data.userId);
        emailController.text = (editEmployeeDetailsModel.data.email);
       nameController.text = (editEmployeeDetailsModel.data.name);
       print("Name: ${nameController.text}");
       phoneController.text = (editEmployeeDetailsModel.data.phone);
      addressController.text = (editEmployeeDetailsModel.data.address);
       
      salaryController.text = editEmployeeDetailsModel.data.salary;
       accountNumberController.text = editEmployeeDetailsModel.data.bankAccount;
      bankNameController.text = editEmployeeDetailsModel.data.bankName;
      ifscController.text = editEmployeeDetailsModel.data.ifscCode;
        company_id = RxString(editEmployeeDetailsModel.data.companyId.toString());
        // Set department and designation
      department.value = editEmployeeDetailsModel.data.departmentId.toString();
      designation.value = editEmployeeDetailsModel.data.designationId.toString();
        profile_pic = RxString(editEmployeeDetailsModel.data.profilePic.toString());
        emergencyContactController.text = (editEmployeeDetailsModel.data.emergencyContact.toString());
        roleController.text = (editEmployeeDetailsModel.data.role.code.toString());
        joinController.text = (editEmployeeDetailsModel.data.joinDate.toString());

        panCard = RxString(editEmployeeDetailsModel.data.documentType[0].documentUrl.toString());
        aadharCard = RxString(editEmployeeDetailsModel.data.documentType[1].documentUrl.toString());

           // Parse and set shift times
      if (editEmployeeDetailsModel.data.employeeShift.shiftStart != null) {
        final startParts = editEmployeeDetailsModel.data.employeeShift.shiftStart.split(':');
        shiftStart.value = TimeOfDay(
          hour: int.parse(startParts[0]),
          minute: int.parse(startParts[1]),
        );
      }
      
      if (editEmployeeDetailsModel.data.employeeShift.shiftEnd != null) {
        final endParts = editEmployeeDetailsModel.data.employeeShift.shiftEnd.split(':');
        shiftEnd.value = TimeOfDay(
          hour: int.parse(endParts[0]),
          minute: int.parse(endParts[1]),
        );
      }


        isLoading.value = false;

    } else if (response.statusCode == 400) {
      Get.snackbar('Error', 'Bad Request',
          backgroundColor: CRMColors.error, colorText: CRMColors.textWhite);
    } else if (response.statusCode == 401) {
      Get.snackbar('Message', 'Login session expired',
          backgroundColor: CRMColors.error, colorText: CRMColors.textWhite);
    } else if (response.statusCode == 500 || response.statusCode == 404) {
        Get.snackbar(
          'Error',
          'No More Data',
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
      } else {
      Get.snackbar("Error", "Failed to Get Employee details",
          backgroundColor: CRMColors.error, colorText: CRMColors.textWhite);
    }

    } catch(error){
      isLoading.value = false;
    }
  }

      static Future<void> clearSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.snackbar(
      'Logout',
      'Login session expired',
      backgroundColor: CRMColors.error,
      colorText: CRMColors.textWhite,
    );
    Get.offAll(LoginScreen());
  }

    // Pick profile image with validation
  Future<void> pickFileImage({ImageSource source = ImageSource.gallery}) async {
    print('pickFileImage called - source: $source');
    try {
      final picker = ImagePicker();
      print('Creating ImagePicker instance');
      final picked = await picker.pickImage(source: source, imageQuality: 20);
      if (picked != null) {
        print('Image picked at path: ${picked.path}');
        final file = File(picked.path);
        print('File created from path');
        final extension = picked.path.split('.').last.toLowerCase();
        print('File extension: $extension');

        if (!allowedExtensions.contains(extension)) {
          print('Invalid file extension: $extension');
          Get.snackbar(
            "Error",
            "Only .png, .jpg, .gif formats are allowed for profile image",
            backgroundColor: CRMColors.error,
            colorText: CRMColors.textWhite,
          );
          return;
        }

        profileImage.value = file;
        print('profileImage set to: ${file.path}');
      } else {
        print('Image picking was cancelled');
      }
    } catch (e) {
      print('Error in pickFileImage: $e');
      Get.snackbar(
        "Error",
        "Failed to pick image: ${e.toString()}",
        backgroundColor: CRMColors.error,
        colorText: CRMColors.textWhite,
      );
    }
  }

    // Pick join date
  Future<void> selectJoinDate() async {
    print('selectJoinDate called');
    final picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      print('Date picked: $picked');
      joinDate.value = picked;
      print('joinDate set to: ${joinDate.value}');
    } else {
      print('Date picker was cancelled');
    }
  }

    Future<void> selectTime({required bool isStart}) async {
    print('selectTime called - isStart: $isStart');
    final picked = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      print('Time picked: ${picked.format(Get.context!)}');
      if (isStart) {
        shiftStart.value = picked;
        print('shiftStart set to: ${shiftStart.value}');
      } else {
        shiftEnd.value = picked;
        print('shiftEnd set to: ${shiftEnd.value}');
      }
    } else {
      print('Time picker was cancelled');
    }
  }

    // Pick documents with validation
  Future<void> pickFile(bool isPan) async {
    print('pickFile called - isPan: $isPan');
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        print('File picked: ${result.files.single.path}');
        final file = File(result.files.single.path!);
        print('File created from path');
        final extension =
            result.files.single.extension?.toLowerCase() ??
            result.files.single.path!.split('.').last.toLowerCase();
        print('File extension: $extension');

        if (!allowedExtensions.contains(extension)) {
          print('Invalid file extension: $extension');
          Get.snackbar(
            "Error",
            "Only .png, .jpg, .gif, .pdf formats are allowed",
            backgroundColor: CRMColors.error,
            colorText: CRMColors.textWhite,
          );
          return;
        }

        if (isPan) {
          panCardFile.value = file;
          print('panCardFile set to: ${file.path}');
        } else {
          aadhaarCardFile.value = file;
          print('aadhaarCardFile set to: ${file.path}');
        }
      } else {
        print('File picking was cancelled');
      }
    } catch (e) {
      print('Error in pickFile: $e');
      Get.snackbar(
        "Error",
        "Failed to pick file: ${e.toString()}",
        backgroundColor: CRMColors.error,
        colorText: CRMColors.textWhite,
      );
    }
  }

}