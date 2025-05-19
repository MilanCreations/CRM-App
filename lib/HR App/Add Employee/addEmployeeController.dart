// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:crm_milan_creations/API%20Services/BaseURL_&_EndPoints.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddEmployeeController extends GetxController {
  // Form controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final salaryController = TextEditingController();
  final emergencyContactController = TextEditingController();
  final addressController = TextEditingController();

  final bankNameController = TextEditingController();
  final accountNumberController = TextEditingController();
  final ifscController = TextEditingController();
  final roleController = TextEditingController();

  // Time and date observables
  Rx<TimeOfDay?> shiftStart = Rx<TimeOfDay?>(null);
  Rx<TimeOfDay?> shiftEnd = Rx<TimeOfDay?>(null);
  Rx<DateTime?> joinDate = Rx<DateTime?>(null);

  // Employee details
  RxString department = ''.obs;
  RxString designation = ''.obs;

  // File handling
  Rx<File?> panCardFile = Rx<File?>(null);
  Rx<File?> aadhaarCardFile = Rx<File?>(null);
  Rx<File?> profileImage = Rx<File?>(null);

  // Loading state
  var isLoading = false.obs;

  // Allowed file extensions
  final allowedExtensions = {'png', 'jpg', 'jpeg', 'gif', 'pdf'};

  // Pick time
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

  // Validate file format
  bool _validateFileFormat(File file) {
    print('_validateFileFormat called for file: ${file.path}');
    final extension = file.path.split('.').last.toLowerCase();
    print('File extension: $extension');
    if (!allowedExtensions.contains(extension)) {
      print('Invalid file format: $extension');
      Get.snackbar(
        "Error",
        "Invalid file format: $extension. Only .png, .jpg, .gif, .pdf are allowed",
        backgroundColor: CRMColors.error,
        colorText: CRMColors.textWhite,
      );
      return false;
    }
    print('File format is valid');
    return true;
  }

  // Get media type for file
  MediaType? _getMediaType(File file) {
    print('_getMediaType called for file: ${file.path}');
    final extension = file.path.split('.').last.toLowerCase();
    print('File extension: $extension');
    final mediaType =
        {
          'jpg': MediaType('image', 'jpeg'),
          'jpeg': MediaType('image', 'jpeg'),
          'png': MediaType('image', 'png'),
          'gif': MediaType('image', 'gif'),
          'pdf': MediaType('application', 'pdf'),
        }[extension];
    print('Media type determined as: $mediaType');
    return mediaType;
  }

  // API submission with improved file handling
  Future<void> inviteemployeeFunction() async {
    print('inviteemployeeFunction called');
    try {
      isLoading.value = true;
      print('Loading state set to true');

      final prefs = await SharedPreferences.getInstance();
      print('SharedPreferences instance obtained');

      String? token = prefs.getString('token');
      print(
        'Token retrieved from SharedPreferences: ${token != null ? "[exists]" : "null"}',
      );

      if (token == null) {
        print('No token found - user not authenticated');
        showErrorMessage("User not authenticated");
        return;
      }

      print("role_id: 4");
      final uri = Uri.parse(ApiConstants.inviteEmployee);
      print('URI created in  add employee api controller:- $uri');

      // Format the joining date properly
   String formattedJoinDate = "";
    if (joinDate.value != null) {
      formattedJoinDate = DateFormat('yyyy-MM-dd').format(joinDate.value!);
      print('Formatted joining date: $formattedJoinDate');
    } else {
      print('No join date selected - this should not happen as validation requires it');
      showErrorMessage("Please select a joining date");
      return;
    }


      final request = http.MultipartRequest('POST', uri);
      print('joinDate set to1: ${joinDate.value.toString()}');

      request.headers['Authorization'] = 'Bearer $token';

      // Add text fields

      request.fields['name'] = nameController.text;

      request.fields['email'] = emailController.text;

      request.fields['department'] = department.value;

      request.fields['designation'] = designation.value;

      request.fields['salary'] = salaryController.text;

      request.fields['emergency_contact'] = emergencyContactController.text;

      request.fields['address'] = addressController.text;

      request.fields['account_number'] = accountNumberController.text;

      request.fields['bank_name'] = bankNameController.text;

      request.fields['ifsc_code'] = ifscController.text;

      request.fields['role_id'] = '4';

      request.fields['joining_date'] = formattedJoinDate;
      
      request.fields['shift_start'] = shiftStart.value != null 
          ? shiftStart.value!.format(Get.context!) 
          : "";

      request.fields['shift_end'] = shiftEnd.value != null 
          ? shiftEnd.value!.format(Get.context!) 
          : "";

      // Add profile image only if provided
      if (profileImage.value != null) {
        if (!_validateFileFormat(profileImage.value!)) {
          return;
        }
        final profileMediaType = _getMediaType(profileImage.value!);
        request.files.add(
          await http.MultipartFile.fromPath(
            'profile_pic',
            profileImage.value!.path,
            contentType: profileMediaType,
          ),
        );
        print('Profile image added to request');
      } else {
        print('No profile image provided - skipping');
      }
      print('Profile image added to request');

      // Add PAN card if provided
      if (panCardFile.value != null) {
        print("PAN card file exists - adding to request");
        if (!_validateFileFormat(panCardFile.value!)) {
          print('PAN card format validation failed');
          return;
        }
        final panMediaType = _getMediaType(panCardFile.value!);
        request.files.add(
          await http.MultipartFile.fromPath(
            'pan_card',
            panCardFile.value!.path,
            contentType: panMediaType,
          ),
        );
        print('PAN card added to request');
      } else {
        print('No PAN card file provided');
      }

      // Add Aadhaar card if provided
      if (aadhaarCardFile.value != null) {
        print("Aadhaar card file exists - adding to request");
        if (!_validateFileFormat(aadhaarCardFile.value!)) {
          print('Aadhaar card format validation failed');
          return;
        }
        final aadhaarMediaType = _getMediaType(aadhaarCardFile.value!);
        request.files.add(
          await http.MultipartFile.fromPath(
            'adhaar_card',
            aadhaarCardFile.value!.path,
            contentType: aadhaarMediaType,
          ),
        );
        print('Aadhaar card added to request');
      } else {
        print('No Aadhaar card file provided');
      }

      print('Sending request...');
      final response = await request.send();
      print('Request sent - status code: ${response.statusCode}');

      final resBody = await response.stream.bytesToString();
      print('Response body received: $resBody');

      if (response.statusCode == 201) {
        print('Request successful (201)');
        final jsonResponse = json.decode(resBody);
        print('JSON response decoded: $jsonResponse');

        if (jsonResponse['success'] == true) {
          print('API returned success: true');
          showSuccessMessage(
            jsonResponse['message'] ?? "Employee added successfully",
          );
          resetForm();
        } else {
          print('API returned success: false');
          showErrorMessage(jsonResponse['message'] ?? "Failed to add employee");
        }
      } else {
        print('Request failed with status ${response.statusCode}');
        showErrorMessage(
          "Failed with status ${response.statusCode}: ${parseErrorMessage(resBody)}",
        );
      }
    } catch (e) {
      print('Error in inviteemployeeFunction: $e');
      showErrorMessage("An error occurred: ${e.toString()}");
    } finally {
      print('Setting isLoading to false');
      isLoading.value = false;
    }
  }

  // Reset form
  void resetForm() {
    print('resetForm called');
    nameController.clear();
    print('nameController cleared');
    emailController.clear();
    print('emailController cleared');
    phoneController.clear();
    print('phoneController cleared');
    salaryController.clear();
    print('salaryController cleared');
    emergencyContactController.clear();
    print('emergencyContactController cleared');
    addressController.clear();
    print('addressController cleared');
    bankNameController.clear();
    print('bankNameController cleared');
    accountNumberController.clear();
    print('accountNumberController cleared');
    ifscController.clear();
    print('ifscController cleared');

    department.value = '';
    print('department reset');
    designation.value = '';
    print('designation reset');

    shiftStart.value = null;
    print('shiftStart reset');
    shiftEnd.value = null;
    print('shiftEnd reset');
    joinDate.value = null;
    print('joinDate reset');

    profileImage.value = null;
    print('profileImage reset');
    panCardFile.value = null;
    print('panCardFile reset');
    aadhaarCardFile.value = null;
    print('aadhaarCardFile reset');
  }

  // Validation before submission
  void submitAllData() {
    print('submitAllData called');
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        department.value.isEmpty ||
        designation.value.isEmpty ||
        salaryController.text.isEmpty ||
        joinDate.value == null) {
      print('Validation failed - missing required fields');
      Get.snackbar(
        "Error",
        "Please fill all required fields",
        backgroundColor: CRMColors.error,
        colorText: CRMColors.textWhite,
      );
      return;
    }

    if (!emailController.text.isEmail) {
      print('Validation failed - invalid email format');
      Get.snackbar(
        "Error",
        "Please enter a valid email address",
        backgroundColor: CRMColors.error,
        colorText: CRMColors.textWhite,
      );
      return;
    }

    print('All validations passed - calling inviteemployeeFunction');
    inviteemployeeFunction();
  }

  @override
  void onClose() {
    print('onClose called - disposing controllers');
    nameController.dispose();
    print('nameController disposed');
    emailController.dispose();
    print('emailController disposed');
    phoneController.dispose();
    print('phoneController disposed');
    salaryController.dispose();
    print('salaryController disposed');
    emergencyContactController.dispose();
    print('emergencyContactController disposed');
    addressController.dispose();
    print('addressController disposed');
    bankNameController.dispose();
    print('bankNameController disposed');
    accountNumberController.dispose();
    print('accountNumberController disposed');
    ifscController.dispose();
    print('ifscController disposed');
    super.onClose();
    print('Super onClose called');
  }

  // Helper method to show success messages
  void showSuccessMessage(String message) {
    print('showSuccessMessage called with message: $message');
    Get.snackbar(
      "Success",
      message,
      backgroundColor: Colors.green,
      colorText: CRMColors.textWhite,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 3),
    );
  }

  // Helper method to show error messages
  void showErrorMessage(String message) {
    print('showErrorMessage called with message: $message');
    Get.snackbar(
      "Error",
      message,
      backgroundColor: CRMColors.error,
      colorText: CRMColors.textWhite,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: 3),
    );
  }

  // Helper method to parse error message from response
  String parseErrorMessage(String responseBody) {
    print('parseErrorMessage called with responseBody: $responseBody');
    try {
      final jsonData = json.decode(responseBody);
      print('JSON decoded successfully');
      final message = jsonData['message'] ?? 'Unknown error';
      print('Parsed message: $message');
      return message;
    } catch (e) {
      print('Error parsing error message: $e');
      return 'Unable to parse error message';
    }
  }
}
