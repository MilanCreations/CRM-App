import 'package:crm_milan_creations/API%20Services/BaseURL_&_EndPoints.dart';
import 'package:crm_milan_creations/Auth/Login/loginScreen.dart';
import 'package:crm_milan_creations/Chat%20App/User%20Chat%20Details%20Model/userChatModel.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Chatinboxhistorycontroller extends GetxController{
  var isLoading = false.obs;
  var messageList = [].obs;
  var hasMoreData = true.obs;
  var currentPage = 1.obs;

  Future<void> messagesListFunction({bool isRefresh = false, required String peerId}) async{
    try{
        isLoading.value = true;
        final prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString('token');
        String? userId = prefs.getString("id") ?? "";
        print('user id of message:- $userId');
        if(token == null){
          isLoading.value = false;
          clearSharedPreferences();
          return;
        }

        if(isRefresh){
          currentPage.value = 1;
          hasMoreData.value = true;
          messageList.clear();
        }

        final url = Uri.parse("${ApiConstants.messageList}/$peerId");
        print('fial api url of message list:- $url');

        final response = await http.get(url,headers: {"Authorization": "Bearer $token"});
        print('message history list api response:- ${response.body}');
        print('Message history list status code:- ${response.statusCode}');

        if(response.statusCode == 200){
          var messageModel = messageModelFromJson(response.body);
          messageList.addAll(messageModel.data);
        }

    } catch(error){
      print('Catch error in message list function:- $error');
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