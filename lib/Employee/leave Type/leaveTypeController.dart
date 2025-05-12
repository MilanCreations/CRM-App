// ignore_for_file: non_constant_identifier_names

import 'package:crm_milan_creations/API%20Services/BaseURL_&_EndPoints.dart';
import 'package:crm_milan_creations/Auth/Login/loginScreen.dart';
import 'package:crm_milan_creations/Employee/leave%20Type/leaveTypeModel.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LeaveTypeController extends GetxController {
  var isLoading = false.obs;
  List<Datum> leavtypeList = <Datum>[].obs;
  Rxn<Datum> selectedLeaveType = Rxn<Datum>();

  @override
  void onInit() {
    super.onInit();
   leavetypelistfun();
  }

Future<void> leavetypelistfun({
  bool isRefresh = false,
  // String? start_date,
  // String? end_date,
}) async {
  try {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      isLoading.value = false;
      Get.snackbar("Error", "User is not authenticated login again!",
          backgroundColor: CRMColors.error, colorText: CRMColors.textWhite);
      return;
    }


    final uri = Uri.parse(ApiConstants.leaveType);
      print("Final Leave type API URL: $uri");
    final response = await http.get(
      uri,
      headers: {"Authorization": "Bearer $token"},
    );

    print("API Status Code Leave type: ${response.statusCode}");
    print("API body Response in Leave type: ${response.body}");
    print("API status code in Leave type: ${response.statusCode}");

    if (response.statusCode == 200) {
      var leavetypeModel = leaveTypeModelFromJson(response.body);
       leavtypeList.addAll(leavetypeModel.data);
      isLoading.value = false;
      return;
    }

    if (response.statusCode == 400) {
      isLoading.value = false;
      Get.snackbar('Error', 'Bad Request',
          backgroundColor: CRMColors.error, colorText: CRMColors.textWhite);
      return;
    }  if (response.statusCode == 401) {
      isLoading.value = false;
      Get.snackbar('Message', 'Login session expired',
          backgroundColor: CRMColors.error, colorText: CRMColors.textWhite);
      return;
    }

    if (response.statusCode == 500) {
      isLoading.value = false;
      Get.snackbar('Error', 'No More Data',
          backgroundColor: CRMColors.error, colorText: CRMColors.textWhite);
      return;
    }

    if (response.statusCode == 404) {
      isLoading.value = false;
      Get.snackbar('Error 404', 'Not found',
          backgroundColor: CRMColors.error, colorText: CRMColors.textWhite);
      return;
    }

    isLoading.value = false;
    Get.snackbar("Error", "Failed to fetch Invest history",
        backgroundColor: CRMColors.error, colorText: CRMColors.textWhite);

    print("Retrieved Token in Invest History Controller: $token");
  } catch (error) {
    isLoading.value = false;
    print("Error: $error");
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
