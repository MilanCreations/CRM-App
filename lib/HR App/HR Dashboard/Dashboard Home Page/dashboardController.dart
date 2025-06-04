import 'package:crm_milan_creations/API%20Services/BaseURL_&_EndPoints.dart';
import 'package:crm_milan_creations/Auth/Login/loginScreen.dart';
import 'package:crm_milan_creations/HR%20App/HR%20Dashboard/Dashboard%20Home%20Page/dashboardModel.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Dashboardcontroller extends GetxController{
  var isLoading = false.obs;
  var myLeads = ''.obs;
  var todayAttendanceCount = ''.obs;
  var todayLeaves = ''.obs;
  var pendingLeaves = ''.obs;
  var approvedLeaves = ''.obs;

  Future<void> dashboardFunction() async {
    try{
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
    print("token in HR Dashboard:- $token");

       if (token == null) {
      isLoading.value = false;
      clearSharedPreferences();
      return;
    }


    final url = Uri.parse(ApiConstants.hrDashboard);
    final response = await http.get(url,headers: {"Authorization": "Bearer $token"});

    print("API Status Code in HR Dashbaord: ${response.statusCode}");
    print("Body Response of HR Dashbaord: $response");
  
  if(response.statusCode == 200){
      var hrDashboardModel = dashboardFromJson(response.body);
      print("Data fetched from HR dashboard model");
      myLeads.value = hrDashboardModel.data.myLeads.toString();
      todayAttendanceCount.value = hrDashboardModel.data.todayAttendanceCount.toString();
      todayLeaves.value = hrDashboardModel.data.todayLeaves.toString();
      pendingLeaves.value = hrDashboardModel.data.pendingLeaves.toString();
      approvedLeaves.value = hrDashboardModel.data.approvedLeaves.toString();
      print('My Leads:- ${myLeads.value}');
      print('Today Attendance Count:- ${todayAttendanceCount.value}');
      print('Leads:- ${pendingLeaves.value}');
      print('Approved Leaves:- ${approvedLeaves.value}');
      print('Today Leaves:- ${todayLeaves.value}');
  } else if (response.statusCode == 400) {
      isLoading.value = false;
      Get.snackbar('Error', 'Bad Request',
          backgroundColor: CRMColors.error, colorText: CRMColors.textWhite);
    } else if (response.statusCode == 401) {
      isLoading.value = false;
      Get.snackbar('Message', 'Login session expired',
          backgroundColor: CRMColors.error, colorText: CRMColors.textWhite);
    } else if (response.statusCode == 500 || response.statusCode == 404) {
      isLoading.value = false;
      Get.snackbar('Error', 'No More Data',
          backgroundColor: CRMColors.error, colorText: CRMColors.textWhite);
    } else {
      isLoading.value = false;
      Get.snackbar("Error", "Failed to fetch attendance history",
          backgroundColor: CRMColors.error, colorText: CRMColors.textWhite);
    }




    } catch(error){
      print("Catch erro in dashboard controller:- $error");
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