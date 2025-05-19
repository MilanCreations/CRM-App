// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crm_milan_creations/API%20Services/BaseURL_&_EndPoints.dart';
import 'package:crm_milan_creations/Auth/Login/loginScreen.dart';
import 'package:crm_milan_creations/Employee/check%20clockin%20status/check-In-StatusModel.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckClockInController extends GetxController {
 final String checkpagestatus;
   CheckClockInController({required this.checkpagestatus});
 
 var isLoading = false.obs;
  var checkInTime = ''.obs;
  var checkOutTime = ''.obs;
  var breackinTime = ''.obs;
  var breackOutTime = ''.obs;
  var pictureuser = ''.obs;
   

  @override
  void onInit() {
    print("Check in API controller initialized");
    print("Check in API controller checkpagestatus: $checkpagestatus");
    super.onInit();
     getlocaldata();
    //checkClockInController();
  }


 

 
  getlocaldata() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

   checkInTime =RxString( sharedPreferences.getString("check_in") ?? "");

   
    if(checkInTime.isNotEmpty){
       print("Check in time in getlocaldata: ${checkpagestatus}");
      if (checkpagestatus == "login") {
         print("Login");
      checkClockInController();
    
    }else if(checkInTime.toString() == "checkin"){
       print("checking");
      checkClockInController();
   
    }else if(checkpagestatus.toString() == "splash"){
       print("splash");
      checkClockInController();

    }

  }else{
     print("not condition");
     checkClockInController();

  }
  }



  Future<void> openInternetSettings() async {
    const url = 'app-settings:';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      Get.snackbar(
        "Error",
        "Cannot open settings",
        backgroundColor: CRMColors.error,
        colorText: CRMColors.textWhite,
      );
    }
  }

  Future<void> checkClockInController() async {
    print("Check in API controller called");
    try {
      isLoading.value = true;
      // ✅ Check for internet connection
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        isLoading.value = false;
        Get.snackbar(
          "No Internet",
          "Please connect to the internet",
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );

        // ✅ Open device's internet settings
        await openInternetSettings();
        return;
      }
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        isLoading.value = false;
        clearSharedPreferences();
        // Get.snackbar(
        //   "Error",
        //   "User is not authenticated login again!",
        //   backgroundColor: CRMColors.error,
        //   colorText: CRMColors.textWhite,
        // );
        return;
      }

      final uri = Uri.parse(ApiConstants.checkInStatus);
      print("Check clock in API URL: $uri");
      final response = await http.get(
        uri,
        headers: {"Authorization": "Bearer $token"},
      );

      print("API Status Code check clock in api: ${response.statusCode}");
      print("API Response in check clock in api: ${response.body}");

      if (response.statusCode == 200) {
        var dataEncode = json.decode(response.body);
        if (dataEncode['data']['attendance'] == null) {
          await prefs.setString('check_in', 'checkin');
          prefs.setString('check_out', 'checkout');
          prefs.setString('breakin', '');
          prefs.setString('breakout', '');
          checkInTime.value = "checkin";
          print("nextday");
        } else {
          print("sdfdsfdsg");
          var checkLoginModel = checkinStatusFromJson(response.body);
           checkInTime.value = checkLoginModel.data.attendance.checkIn.toString();
           checkOutTime.value = checkLoginModel.data.attendance.checkOut.toString();
           breackinTime.value = checkLoginModel.data.attendance.breakStart.toString();
           breackOutTime.value = checkLoginModel.data.attendance.breakEnd.toString();
          print('Check in time in check API in controller :- $checkInTime');
          await prefs.setString(
            'picture',
            checkLoginModel.data.attendance.picture.toString(),
          );
          await prefs.setString(
            'check_in',
            checkLoginModel.data.attendance.checkIn.toString(),
          );
          await prefs.setString(
            'check_out',
            checkLoginModel.data.attendance.checkOut.toString(),
          );
          pictureuser.value = prefs.getString("picture") ?? "";
          update();
          isLoading.value = false;
          return;
        }
      }

      if (response.statusCode == 400) {
        isLoading.value = false;
        Get.snackbar(
          'Error',
          'Bad Request',
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
        return;
      }
      if (response.statusCode == 401) {
        isLoading.value = false;
        clearSharedPreferences();
        // Get.snackbar(
        //   'Message',
        //   'Login session expired',
        //   backgroundColor: CRMColors.error,
        //   colorText: CRMColors.textWhite,
        // );
        return;
      }

      if (response.statusCode == 500) {
        isLoading.value = false;
        Get.snackbar(
          'Error',
          'No More Data',
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
        return;
      }

      if (response.statusCode == 404) {
        isLoading.value = false;
        Get.snackbar(
          'Error 404',
          'Not found',
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
        return;
      }

      // isLoading.value = false;
      // Get.snackbar(
      //   "Error",
      //   "Failed to check clock In status",
      //   backgroundColor: CRMColors.error,
      //   colorText: CRMColors.textWhite,
      // );

      print("Retrieved Token in check clock in api Controller: $token");
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
    // Get.snackbar(
    //   'Logout',
    //   'Login session expired',
    //   backgroundColor: CRMColors.error,
    //   colorText: CRMColors.textWhite,
    // );
    Get.offAll(LoginScreen());
  }
}
