import 'dart:convert';
import 'dart:io';

import 'package:crm_milan_creations/API%20Services/BaseURL_&_EndPoints.dart';
import 'package:crm_milan_creations/Auth/Login/loginScreen.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Editemployeedetailscontroller extends GetxController {
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
  RxString profileImageUrl = ''.obs;
  RxString panCardUrl = ''.obs;
  RxString aadhaarCardUrl = ''.obs;


    // Employee details
  RxInt departmentId = 0.obs;
  RxInt designationId = 0.obs;
  RxString departmentName = ''.obs;
  RxString designationName = ''.obs;

  // Loading state
  var isLoading = false.obs;

  // Allowed file extensions
  final allowedExtensions = {'png', 'jpg', 'jpeg', 'gif', 'pdf'};

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

  // Load employee data for editing
  Future<void> loadEmployeeData(int employeeId) async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        isLoading.value = false;
        clearSharedPreferences();
        return;
      }

      final url = Uri.parse("${ApiConstants.employeeDetails}/$employeeId");
      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == "success") {
          final employee = data['data'];
          
          // Set text fields
          nameController.text = employee['name'] ?? '';
          emailController.text = employee['email'] ?? '';
          phoneController.text = employee['phone'] ?? '';
          salaryController.text = employee['salary']?.toString() ?? '';
          emergencyContactController.text = employee['emergency_contact'] ?? '';
          addressController.text = employee['address'] ?? '';
          bankNameController.text = employee['bank_name'] ?? '';
          accountNumberController.text = employee['bank_account'] ?? '';
          ifscController.text = employee['ifsc_code'] ?? '';
          
          // Set department and designation
          departmentId.value = employee['department_id'] ?? 0;
          designationId.value = employee['designation_id'] ?? 0;
          departmentName.value = employee['department']?['name'] ?? '';
          designationName.value = employee['designation']?['name'] ?? '';
          
          // Set dates
          if (employee['join_date'] != null) {
            joinDate.value = DateTime.parse(employee['join_date']);
          }
          
          // Set file URLs
          profileImageUrl.value = employee['profile_pic'] ?? '';
          
          // Handle document URLs from document_type array
          if (employee['document_type'] != null) {
            for (var doc in employee['document_type']) {
              if (doc['document_type'] == 'pan_card') {
                panCardUrl.value = doc['document_url'] ?? '';
              } else if (doc['document_type'] == 'adhaar_card') {
                aadhaarCardUrl.value = doc['document_url'] ?? '';
              }
            }
          }
        }
      } else {
        showErrorMessage("Failed to load employee data: ${response.statusCode}");
      }
    } catch (error) {
      showErrorMessage("Failed to load employee data: ${error.toString()}");
    } finally {
      isLoading.value = false;
    }
  }
  // Pick time
  Future<void> selectTime({required bool isStart}) async {
    final picked = await showTimePicker(
      context: Get.context!,
      initialTime: isStart ? shiftStart.value ?? TimeOfDay.now() : shiftEnd.value ?? TimeOfDay.now(),
    );
    if (picked != null) {
      if (isStart) {
        shiftStart.value = picked;
      } else {
        shiftEnd.value = picked;
      }
    }
  }

  // Pick join date
  Future<void> selectJoinDate() async {
    final picked = await showDatePicker(
      context: Get.context!,
      initialDate: joinDate.value ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      joinDate.value = picked;
    }
  }

  // Pick profile image with validation
  Future<void> pickFileImage({ImageSource source = ImageSource.gallery}) async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: source, imageQuality: 20);
      if (picked != null) {
        final file = File(picked.path);
        final extension = picked.path.split('.').last.toLowerCase();

        if (!allowedExtensions.contains(extension)) {
          showErrorMessage("Only .png, .jpg, .gif formats are allowed for profile image");
          return;
        }

        profileImage.value = file;
        profileImageUrl.value = ''; // Clear URL when new image is picked
      }
    } catch (e) {
      showErrorMessage("Failed to pick image: ${e.toString()}");
    }
  }

  // Pick documents with validation
  Future<void> pickFile(bool isPan) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        final file = File(result.files.single.path!);
        final extension = result.files.single.extension?.toLowerCase() ?? 
                        result.files.single.path!.split('.').last.toLowerCase();

        if (!allowedExtensions.contains(extension)) {
          showErrorMessage("Only .png, .jpg, .gif, .pdf formats are allowed");
          return;
        }

        if (isPan) {
          panCardFile.value = file;
          panCardUrl.value = ''; // Clear URL when new file is picked
        } else {
          aadhaarCardFile.value = file;
          aadhaarCardUrl.value = ''; // Clear URL when new file is picked
        }
      }
    } catch (e) {
      showErrorMessage("Failed to pick file: ${e.toString()}");
    }
  }

  // Validate file format
  bool _validateFileFormat(File file) {
    final extension = file.path.split('.').last.toLowerCase();
    if (!allowedExtensions.contains(extension)) {
      showErrorMessage("Invalid file format: $extension. Only .png, .jpg, .gif, .pdf are allowed");
      return false;
    }
    return true;
  }

  // Get media type for file
  MediaType? _getMediaType(File file) {
    final extension = file.path.split('.').last.toLowerCase();
    return {
      'jpg': MediaType('image', 'jpeg'),
      'jpeg': MediaType('image', 'jpeg'),
      'png': MediaType('image', 'png'),
      'gif': MediaType('image', 'gif'),
      'pdf': MediaType('application', 'pdf'),
    }[extension];
  }

 // API submission for editing employee
  Future<void> editEmployeeFunction(int employeeId) async {
    try {
      // Validate required fields
      // if (nameController.text.isEmpty ||
      //     emailController.text.isEmpty ||
      //     departmentId.value == 0 ||
      //     designationId.value == 0 ||
      //     salaryController.text.isEmpty) {
      //   showErrorMessage("Please fill all required fields");
      //   return;
      // }

      // if (!emailController.text.isEmail) {
      //   showErrorMessage("Please enter a valid email address");
      //   return;
      // }

      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        clearSharedPreferences();
        return;
      }

      final uri = Uri.parse("${ApiConstants.employeeDetails}/$employeeId");
      final request = http.MultipartRequest('PUT', uri);
      request.headers['Authorization'] = 'Bearer $token';

      // Add text fields
      request.fields['name'] = nameController.text;
      request.fields['email'] = emailController.text;
      request.fields['phone'] = phoneController.text;
      request.fields['department_id'] = departmentId.value.toString();
      request.fields['designation_id'] = designationId.value.toString();
      request.fields['salary'] = salaryController.text;
      request.fields['emergency_contact'] = emergencyContactController.text;
      request.fields['address'] = addressController.text;
      request.fields['bank_account'] = accountNumberController.text;
      request.fields['bank_name'] = bankNameController.text;
      request.fields['ifsc_code'] = ifscController.text;

      // Add dates if they exist
      if (joinDate.value != null) {
        request.fields['join_date'] = joinDate.value!.toIso8601String();
      }

      // Add profile image only if a new one was provided
      if (profileImage.value != null) {
        if (!_validateFileFormat(profileImage.value!)) return;
        final profileMediaType = _getMediaType(profileImage.value!);
        request.files.add(
          await http.MultipartFile.fromPath(
            'profile_pic',
            profileImage.value!.path,
            contentType: profileMediaType,
          ),
        );
      } else if (profileImageUrl.value.isNotEmpty) {
        // If no new image but URL exists, keep the existing one
        request.fields['profile_pic_url'] = profileImageUrl.value;
      }

      // Add PAN card if provided
      if (panCardFile.value != null) {
        if (!_validateFileFormat(panCardFile.value!)) return;
        final panMediaType = _getMediaType(panCardFile.value!);
        request.files.add(
          await http.MultipartFile.fromPath(
            'pan_card',
            panCardFile.value!.path,
            contentType: panMediaType,
          ),
        );
      } else if (panCardUrl.value.isNotEmpty) {
        // If no new file but URL exists, keep the existing one
        request.fields['pan_card_url'] = panCardUrl.value;
      }

      // Add Aadhaar card if provided
      if (aadhaarCardFile.value != null) {
        if (!_validateFileFormat(aadhaarCardFile.value!)) return;
        final aadhaarMediaType = _getMediaType(aadhaarCardFile.value!);
        request.files.add(
          await http.MultipartFile.fromPath(
            'adhaar_card',
            aadhaarCardFile.value!.path,
            contentType: aadhaarMediaType,
          ),
        );
      } else if (aadhaarCardUrl.value.isNotEmpty) {
        // If no new file but URL exists, keep the existing one
        request.fields['adhaar_card_url'] = aadhaarCardUrl.value;
      }

      final response = await request.send();
      final resBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(resBody);
        if (jsonResponse['status'] == "success") {
          showSuccessMessage("Employee updated successfully");
          Get.back(result: true); // Return success to previous screen
          
          // Update the local data with the new values from response
          final updatedEmployee = jsonResponse['data'];
          profileImageUrl.value = updatedEmployee['profile_pic'] ?? '';
          
          // Update document URLs
          if (updatedEmployee['document_type'] != null) {
            for (var doc in updatedEmployee['document_type']) {
              if (doc['document_type'] == 'pan_card') {
                panCardUrl.value = doc['document_url'] ?? '';
              } else if (doc['document_type'] == 'adhaar_card') {
                aadhaarCardUrl.value = doc['document_url'] ?? '';
              }
            }
          }
        } else {
          showErrorMessage(jsonResponse['message'] ?? "Failed to update employee");
        }
      } else {
        showErrorMessage(
          "Failed with status ${response.statusCode}: ${parseErrorMessage(resBody)}",
        );
      }
    } catch (e) {
      showErrorMessage("An error occurred: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  // Reset form
  void resetForm() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    salaryController.clear();
    emergencyContactController.clear();
    addressController.clear();
    bankNameController.clear();
    accountNumberController.clear();
    ifscController.clear();

    department.value = '';
    designation.value = '';

    shiftStart.value = null;
    shiftEnd.value = null;
    joinDate.value = null;

    profileImage.value = null;
    panCardFile.value = null;
    aadhaarCardFile.value = null;
    
    profileImageUrl.value = '';
    panCardUrl.value = '';
    aadhaarCardUrl.value = '';
  }

  // Validation before submission
  void submitAllData(int employeeId) {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        department.value.isEmpty ||
        designation.value.isEmpty ||
        salaryController.text.isEmpty) {
      showErrorMessage("Please fill all required fields");
      return;
    }

    if (!emailController.text.isEmail) {
      showErrorMessage("Please enter a valid email address");
      return;
    }

    editEmployeeFunction(employeeId);
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    salaryController.dispose();
    emergencyContactController.dispose();
    addressController.dispose();
    bankNameController.dispose();
    accountNumberController.dispose();
    ifscController.dispose();
    super.onClose();
  }

  // Helper method to show success messages
  void showSuccessMessage(String message) {
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
    try {
      final jsonData = json.decode(responseBody);
      return jsonData['message'] ?? 'Unknown error';
    } catch (e) {
      return 'Unable to parse error message';
    }
  }
}