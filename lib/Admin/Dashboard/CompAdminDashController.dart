import 'package:crm_milan_creations/API%20Services/BaseURL_&_EndPoints.dart';
import 'package:crm_milan_creations/Admin/Dashboard/CompanyAdminDashboardModel.dart';
import 'package:crm_milan_creations/Auth/Login/loginScreen.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
    companyAdminDashboardFunction();
  }

  Future<void> companyAdminDashboardFunction() async {
    print('Fetching company admin dashboard data...');
    if (isLoading.value) return;
    try {
      isLoading.value = true;
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
        var hrDashboardModel = companyAdminDashboardModelFromJson(
          response.body,
        );

        todayAttendanceCount.value =
            hrDashboardModel.data.todayAttendanceCount.toString();
        todayLeaves.value = hrDashboardModel.data.todayLeaves.toString();
        pendingLeaves.value = hrDashboardModel.data.pendingLeaves.toString();
        approvedLeaves.value = hrDashboardModel.data.approvedLeaves.toString();
        totalEmployees.value = hrDashboardModel.data.totalEmployees.toString();
      } else if (response.statusCode == 401) {
        Get.snackbar(
          'Session Expired',
          'Please login again.',
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
        clearSharedPreferences();
      }
      // } else {
      //   Get.snackbar(
      //     "Error",
      //     "Failed to fetch dashboard data",
      //     backgroundColor: CRMColors.error,
      //     colorText: CRMColors.textWhite,
      //   );
      // }
    } catch (error) {
      print("Dashboard error: $error");
    } finally {
      isLoading.value = false;
    }
  }

  static Future<void> clearSharedPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAll(LoginScreen());
  }
}
