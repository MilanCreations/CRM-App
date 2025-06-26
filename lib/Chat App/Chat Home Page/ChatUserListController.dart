// ignore_for_file: non_constant_identifier_names, prefer_interpolation_to_compose_strings

import 'dart:convert';

import 'package:crm_milan_creations/API%20Services/BaseURL_&_EndPoints.dart';
import 'package:crm_milan_creations/Auth/Login/loginScreen.dart';
import 'package:crm_milan_creations/Chat%20App/Chat%20Home%20Page/ChatUserListModel.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ChatUserListController extends GetxController {
  var isLoading = false.obs;
  var ChatUsers = [].obs;
  var currentPage = 1.obs;
  var hasMoreData = true.obs;


Future<void> ChatUserListfunctions({
  bool isRefresh = false,
}) async {
  if (isLoading.value || !hasMoreData.value) return;

  try {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? companyID = prefs.getString('company_id');

    if (token == null || companyID == null || companyID.isEmpty) {
      isLoading.value = false;
      clearSharedPreferences();
      return;
    }

    if (isRefresh) {
      currentPage.value = 1;
      hasMoreData.value = true;
      ChatUsers.clear();
    }

    Map<String, dynamic> chatuserdata = {
      'company_id': companyID,
    };

    final uri = Uri.parse("${ApiConstants.chatUserList}?_page=${currentPage.value}");

    print("📥 Logged-in user ID: $companyID");
    print("Final chat user list API URL: $uri");

    final response = await http.post(
      uri,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json", // Make sure backend supports this
      },
      body: jsonEncode(chatuserdata),
    );

    print("API Status Code of chat user list: ${response.statusCode}");
    print("API Response of chat user list: ${response.body}");

    if (response.statusCode == 200) {
      var chatUserModel = chatUserListModelFromJson(response.body);

      if (chatUserModel.user.isEmpty) {
        hasMoreData.value = false;
      } else {
        ChatUsers.addAll(chatUserModel.user);
        print("✅ Chat user list count: ${ChatUsers.length}");
        currentPage.value++;
      }
    } else if (response.statusCode == 401) {
      clearSharedPreferences();
    } else {
      Get.snackbar("Error", "Failed to fetch data",
          backgroundColor: CRMColors.error, colorText: CRMColors.textWhite);
    }
  } catch (e) {
    print("❌ Error: $e");
  } finally {
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
}
