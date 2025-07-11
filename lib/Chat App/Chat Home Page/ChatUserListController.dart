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
  var chatUsers = [].obs;
  var currentPage = 1.obs;
  var hasMoreData = true.obs;
  var allUsers = <User>[].obs;

  Future<void> ChatUserListfunctions({
    bool isRefresh = false,
    String searchQuery = '',
  }) async {
    if (isLoading.value) return;
    if (!isRefresh && !hasMoreData.value) return;

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
        chatUsers.clear();
        allUsers.clear();
      }

      Map<String, dynamic> chatuserdata = {'company_id': companyID};

      final uri = Uri.parse(
        "${ApiConstants.chatUserList}?_page=${currentPage.value}&q=$searchQuery",
      );
      print("Final chat user list API URL: $uri");

      final response = await http.post(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
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
          allUsers.addAll(chatUserModel.user);
          chatUsers.value = allUsers.toList(); // initially unfiltered
          currentPage.value++;
        }
      } else if (response.statusCode == 401) {
        clearSharedPreferences();
      } else {
        Get.snackbar(
          "Error",
          "Failed to fetch data",
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
      }
    } catch (e) {
      print("Error: $e");
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

    void searchUserLocally(String query) {
  if (query.isEmpty) {
    chatUsers.value = allUsers;
  } else {
    final lower = query.toLowerCase();
    chatUsers.value = allUsers.where((user) {
      return user.name!.toLowerCase().contains(lower) ||
             user.username.toLowerCase().contains(lower);
    }).toList();
  }
}
}
