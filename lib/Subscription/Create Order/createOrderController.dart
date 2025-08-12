import 'dart:convert';
import 'package:crm_milan_creations/Subscription/Create%20Order/createOrderModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:crm_milan_creations/API Services/BaseURL_&_EndPoints.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/Auth/Login/loginScreen.dart';

class Createordercontroller extends GetxController {
  final TextEditingController employeeCountController = TextEditingController();
  final isLoading = false.obs;
  final orderId = ''.obs;
  final keyId = ''.obs;
  final amount = 0.obs;
  final currency = ''.obs;
  final employeeCount = ''.obs;

  @override
  void onInit() {
    print('[CreateOrderController] Initializing controller...');
    employeeCountController.addListener(() {
      employeeCount.value = employeeCountController.text;
      print(
        '[CreateOrderController] Employee count updated to: ${employeeCount.value}',
      );
    });
    super.onInit();
  }

  Future<void> createOrderFunction() async {
    print('[CreateOrderController] Starting createOrderFunction...');
    try {
      isLoading.value = true;
      print('[CreateOrderController] Loading state set to true');

      final token = await _getToken();
      print(
        '[CreateOrderController] Retrieved token: ${token != null ? "exists" : "null"}',
      );

      if (token == null) {
        print('[CreateOrderController] Token is null, clearing preferences');
        clearSharedPreferences();
        return;
      }

      final count = int.tryParse(employeeCountController.text.trim()) ?? 0;
      print('[CreateOrderController] Parsed employee count: $count');

      if (count < 1 || count > 9) {
        print('[CreateOrderController] Invalid employee count: $count');
        throw Exception('Invalid employee count (must be 1-9)');
      }

      // Calculate amount with GST (100 per employee + 18% GST)
      final totalAmount = (count * 118).round(); // 100 + 18% = 118
      print(
        '[CreateOrderController] Calculated total amount: $totalAmount paise (₹${totalAmount / 100})',
      );

      print(
        '[CreateOrderController] Making API request to: ${ApiConstants.createOrder}',
      );
      final response = await http.post(
        Uri.parse(ApiConstants.createOrder),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'amount': totalAmount}),
      );

      print(
        '[CreateOrderController] API response status: ${response.statusCode}',
      );
      print('[CreateOrderController] API response body: ${response.body}');

      if (response.statusCode == 200) {
        final model = createOrderFromJson(response.body);
        print('[CreateOrderController] Order created successfully:');
        print(' - Order ID: ${model.orderId}');
        print(' - Key ID: ${model.keyId}');
        print(' - Amount: ${model.amount}');
        print(' - Currency: ${model.currency}');

        orderId.value = model.orderId;
        keyId.value = model.keyId;
        amount.value = model.amount;
        currency.value = model.currency;
      } else {
        print(
          '[CreateOrderController] Failed to create order: ${response.statusCode}',
        );
        throw Exception('Failed to create order: ${response.statusCode}');
      }
    } catch (e) {
      print('[CreateOrderController] Error in createOrderFunction: $e');
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: CRMColors.error,
        colorText: CRMColors.textWhite,
      );
      rethrow;
    } finally {
      isLoading.value = false;
      print('[CreateOrderController] Loading state set to false');
    }
  }

  Future<String?> _getToken() async {
    print('[CreateOrderController] Getting token from SharedPreferences...');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print(
      '[CreateOrderController] Token retrieved: ${token != null ? "exists" : "null"}',
    );
    return token;
  }

  static Future<void> clearSharedPreferences() async {
    print('[CreateOrderController] Clearing SharedPreferences...');
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    print('[CreateOrderController] SharedPreferences cleared');
    Get.snackbar(
      'Logout',
      'Login session expired',
      backgroundColor: CRMColors.error,
      colorText: CRMColors.textWhite,
    );
    Get.offAll(LoginScreen());
  }
}
