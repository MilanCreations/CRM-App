import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:crm_milan_creations/API%20Services/BaseURL_&_EndPoints.dart';
import 'package:crm_milan_creations/Admin/Dashboard/CompanyAdminDashboardModel.dart';
import 'package:crm_milan_creations/Auth/Login/loginScreen.dart';
import 'package:crm_milan_creations/utils/colors.dart';

class CompanyAdminDashboardController extends GetxController {
  var isLoading = false.obs;
  var todayAttendanceCount = ''.obs;
  var todayLeaves = ''.obs;
  var pendingLeaves = ''.obs;
  var approvedLeaves = ''.obs;
  var totalEmployees = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      if (token == null) {
        isLoading.value = false;
        clearSharedPreferences();
        return;
      }

      final url = Uri.parse(ApiConstants.companyAdminDashboard);
      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        var model = companyAdminDashboardModelFromJson(response.body);
        print("Admin dashboard dataResponse: ${response.body}");
        todayAttendanceCount.value = model.data.todayAttendanceCount.toString();
        todayLeaves.value = model.data.todayLeaves.toString();
        pendingLeaves.value = model.data.pendingLeaves.toString();
        approvedLeaves.value = model.data.approvedLeaves.toString();
        totalEmployees.value = model.data.totalEmployees.toString();
      } else if (response.statusCode == 401) {
        Get.snackbar(
          'Session Expired',
          'Please login again.',
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
        clearSharedPreferences();
      }
    } catch (e) {
      print("Dashboard error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  static Future<void> clearSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAll(LoginScreen());
  }
}
