// ignore_for_file: avoid_print

import 'package:crm_milan_creations/API%20Services/BaseURL_&_EndPoints.dart';
import 'package:crm_milan_creations/Auth/Login/loginScreen.dart';
import 'package:crm_milan_creations/Employee/profile/My%20Profile/myProfileModel.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Myprofilecontroller extends GetxController{
  var isLoading = false.obs;
  var fullname = ''.obs;
  var email = ''.obs;
  var username = ''.obs;
  var rolename = ''.obs;
  var roleCode = ''.obs;
  var companyName = ''.obs;
  var name = ''.obs;
  var phone = ''.obs;
  var address = ''.obs;
  var emergencycontact = ''.obs;
  // var joindate = ''.obs;
  var salary = ''.obs;
  var bankaccount = ''.obs;
  var bankname = ''.obs;
  var ifsCode = ''.obs;
  var departmentName = ''.obs;
  var designation = ''.obs;
  Future<void> myProfileFunction() async {
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

    final url = Uri.parse(ApiConstants.profile);
    print("Final Profile API URL: $url");
    final response = await http.get(url,
    headers: {"Authorization": "Bearer $token"},
    );

    print("API Status Code in profile function: ${response.statusCode}");
    print("Body Response in profile function: ${response.body}");

        if (response.statusCode == 200) {
      var profileModel = profilwModelFromJson(response.body);
        print("vcvbncbvnc");
        print(phone.value);
        fullname = RxString(profileModel.fullname);
        email = RxString(profileModel.email);
        username = RxString(profileModel.username);
        rolename = RxString(profileModel.roleName);
        companyName = RxString(profileModel.companyName);
        name = RxString(profileModel.name);
        phone.value = (profileModel.phone);
        address = RxString(profileModel.address);
        emergencycontact = RxString(profileModel.emergencyContact);
        // joindate = RxString(profileModel.joinDate.toString());
        salary = RxString(profileModel.salary);
        bankaccount = RxString(profileModel.bankAccount);
        bankname = RxString(profileModel.bankName);
        ifsCode = RxString(profileModel.ifscCode);
        departmentName = RxString(profileModel.departmentName);
        designation = RxString(profileModel.designation);
        update();
        print(phone.value);
        isLoading.value = false;

    } else if (response.statusCode == 400) {
      Get.snackbar('Error', 'Bad Request',
          backgroundColor: CRMColors.error, colorText: CRMColors.textWhite);
    } else if (response.statusCode == 401) {
      Get.snackbar('Message', 'Login session expired',
          backgroundColor: CRMColors.error, colorText: CRMColors.textWhite);
    } else if (response.statusCode == 500 || response.statusCode == 404) {
      Get.snackbar('Error', 'No More Data',
          backgroundColor: CRMColors.error, colorText: CRMColors.textWhite);
    } else {
      Get.snackbar("Error", "Failed to fetch attendance history",
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
}