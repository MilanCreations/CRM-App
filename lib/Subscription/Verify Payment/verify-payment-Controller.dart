import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:crm_milan_creations/API Services/BaseURL_&_EndPoints.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/Auth/Login/loginScreen.dart';

class VerifyPaymentController extends GetxController {
  final isLoading = false.obs;
  final isVerified = false.obs;
  final errorMessage = ''.obs;

  Future<bool> verifyPayment({
    required String razorpayOrderId,
    required String razorpayPaymentId,
    required String razorpaySignature,
    required int usageId,
  }) async {
    try {
      isLoading.value = true;
      isVerified.value = false;
      errorMessage.value = '';

      final token = await _getToken();
      if (token == null) {
        await clearSharedPreferences();
        return false;
      }

      final response = await http.post(
        Uri.parse(ApiConstants.verifyPayment),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "razorpay_order_id": razorpayOrderId,
          "razorpay_payment_id": razorpayPaymentId,
          "razorpay_signature": razorpaySignature,
          "usage_id": usageId,
        }),
      );

      if (response.statusCode == 200) {
        isVerified.value = true;
        Get.snackbar(
          'Success',
          'Payment verified successfully',
          backgroundColor: CRMColors.success,
          colorText: CRMColors.white,
        );
        return true;
      } else {
        final error = jsonDecode(response.body);
        errorMessage.value = error['message'] ?? 'Verification failed';
        Get.snackbar(
          'Error',
          errorMessage.value,
          backgroundColor: CRMColors.error,
          colorText: CRMColors.white,
        );
        return false;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        errorMessage.value,
        backgroundColor: CRMColors.error,
        colorText: CRMColors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> clearSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAll(LoginScreen());
  }
}