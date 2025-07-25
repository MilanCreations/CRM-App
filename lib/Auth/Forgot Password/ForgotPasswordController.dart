import 'dart:convert';

import 'package:crm_milan_creations/API%20Services/BaseURL_&_EndPoints.dart';
import 'package:crm_milan_creations/Auth/Forgot%20Password/ForgotPasswordModel.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class Forgotpasswordcontroller extends GetxController {
  var isLoading = false.obs;
  var isMailSent = false.obs;
  TextEditingController emailController = TextEditingController();

  Future<void> sendResetLinkFunction() async {
    String email = emailController.text.trim();

    // ✅ Validate email before calling API
    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        'Invalid Email',
        'Please enter a valid email address',
        snackPosition: SnackPosition.TOP,
        backgroundColor: CRMColors.error,
        colorText: CRMColors.whiteColor,
      );
      return;
    }

    isLoading.value = true;

    try {
      Map<String, dynamic> forgotPasswordEmail = {'email': email};

      String fullUrl = ApiConstants.forgotPassword;
      print('Forgot password Full URL: $fullUrl');

      var response = await http.post(
        Uri.parse(fullUrl),
        body: jsonEncode(forgotPasswordEmail), // ✅ Fixed here
        headers: {'Content-Type': 'application/json'},
      );

      var data = jsonDecode(response.body);
      print('Forgot password API response: $data');

      if (response.statusCode == 200) {
        var model = forgotPasswordModelFromJson(response.body);
        isMailSent.value = true;
        Get.snackbar(
          'Success',
          model.message,
          snackPosition: SnackPosition.TOP,
          backgroundColor: CRMColors.success,
          colorText: CRMColors.whiteColor,
        );
        emailController.clear();
      } else {
        var errorModel = forgotPasswordModelFromJson(response.body);
        Get.snackbar(
          'Error',
          errorModel.message,
          snackPosition: SnackPosition.TOP,
          backgroundColor: CRMColors.error,
          colorText: CRMColors.whiteColor,
        );
      }
    } catch (error) {
      print('Catch error in sendResetLinkFunction: $error');
      Get.snackbar(
        'Error',
        'Something went wrong: $error',
        snackPosition: SnackPosition.TOP,
        backgroundColor: CRMColors.error,
        colorText: CRMColors.whiteColor,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
