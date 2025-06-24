import 'dart:convert';

import 'package:crm_milan_creations/API%20Services/BaseURL_&_EndPoints.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserLogout extends GetxController{
  var isLoading = false.obs;
  Future<void> logoutFunction() async {
    try{
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String fcmToken = prefs.getString('fcm_token') ?? "";
    String devicePlatform = prefs.getString('platform') ?? "";
    print('logount token:- $token');

    print('Device Token: $fcmToken');
    print('Platform: $devicePlatform');



      Map<String, String> data = {
      'device_token': fcmToken,
      'platform': devicePlatform,
    };

      final response = await http.delete(
        Uri.parse('${ApiConstants.logout}/$devicePlatform/$fcmToken'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json', "Authorization": "Bearer $token"},
      );

      if(response.statusCode == 200){
        isLoading.value = false;
      } if(response.statusCode == 500){
        Get.snackbar(
          "Message",
           "Logout failed" ,
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
      }

    } catch(error){
      isLoading.value = false;
      print('Catch error in logout function:- $error');
    }
  }
}