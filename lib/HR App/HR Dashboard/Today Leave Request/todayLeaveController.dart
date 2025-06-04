import 'package:crm_milan_creations/API%20Services/BaseURL_&_EndPoints.dart';
import 'package:crm_milan_creations/Auth/Login/loginScreen.dart';
import 'package:crm_milan_creations/HR%20App/HR%20Dashboard/Today%20Leave%20Request/todayLeaveModel.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HRLeaveRequestController extends GetxController {
  var isLoading = false.obs;
  var leaveRequestHistory = [].obs;
  var todayLeaves = [].obs;
  var pendingLeaves = [].obs;
  var approvedLeaves = [].obs;
  var currentPage = 1.obs;
  var hasMoreData = true.obs;
  var selectedFilter = "all".obs;

  @override
  void onInit() {
    super.onInit();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
  await fetchAllLeaves();
  await fetchTodayLeaves();
  await fetchTodayPendingLeaves(); // ✅ now this will work correctly
  await fetchTodayApprovedLeaves(); // ✅ now this too
  }

  Future<void> fetchAllLeaves({bool isRefresh = false}) async {
    await _fetchLeaves(
      isRefresh: isRefresh,
      status: null,
      isToday: false,
      targetList: leaveRequestHistory,
    );
  }

  Future<void> fetchTodayLeaves({bool isRefresh = false}) async {
    await _fetchLeaves(
      isRefresh: isRefresh,
      status: null,
      isToday: true,
      targetList: todayLeaves,
    );
  }

Future<void> fetchTodayPendingLeaves({bool isRefresh = false}) async {
  await _fetchLeaves(
    isRefresh: isRefresh,
    status: "pending",
    isToday: true,
    targetList: pendingLeaves,
  );
}

Future<void> fetchTodayApprovedLeaves({bool isRefresh = false}) async {
  await _fetchLeaves(
    isRefresh: isRefresh,
    status: "approved",
    isToday: true,
    targetList: approvedLeaves,
  );
}

  Future<void> _fetchLeaves({
    required bool isRefresh,
    required String? status,
    required bool isToday,
    required RxList targetList,
  }) async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');

      if (token == null) {
        isLoading.value = false;
        await clearSharedPreferences();
        return;
      }

      if (isRefresh) {
        currentPage.value = 1;
        hasMoreData.value = true;
        targetList.clear();
      }

      // Prepare date filters for today's leaves
      String? startDate;
      String? endDate;
        DateTime today = DateTime.now();
      String formattedDate = today.toIso8601String().substring(0, 10); // yyyy-MM-dd
      if (isToday) {
        startDate = formattedDate;
        endDate = formattedDate; // For today, both start and end date are the same
      } else {
        startDate = prefs.getString('startDate') ?? '';
        endDate = prefs.getString('endDate') ?? '';
      }

      final uri = Uri.parse(
        "${ApiConstants.leaveAction}?"
        "_page=${currentPage.value}"
        "&_limit=20"
        "&_sort=date"
        "&_order=desc"
        "&q="
        "&department="
        "&startDate=$startDate"
        "&endDate=$endDate"
        "&status=${status ?? ''}"
      );

      print("Fetching leaves from: $uri");
      final response = await http.get(uri, headers: {"Authorization": "Bearer $token"});

      if (response.statusCode == 200) {
        final model = todayLeaveModelFromJson(response.body);
        
        if (model.data.leaves.isEmpty) {
          hasMoreData.value = false;
        } else {
          targetList.addAll(model.data.leaves);
          print("Fetched ${model.data.leaves.length} leaves");
        }
      } else if (response.statusCode == 401) {
        Get.snackbar('Session Expired', 'Please login again.',
            backgroundColor: CRMColors.error, colorText: CRMColors.textWhite);
      } else {
        Get.snackbar("Error", "Failed to fetch data. Status: ${response.statusCode}",
            backgroundColor: CRMColors.error, colorText: CRMColors.textWhite);
      }
    } catch (e) {
      print("Error fetching leaves: $e");
      Get.snackbar("Error", "An error occurred while fetching data",
          backgroundColor: CRMColors.error, colorText: CRMColors.textWhite);
    } finally {
      isLoading.value = false;
    }
  }

  void changeFilter(String newFilter) {
    selectedFilter.value = newFilter;
    switch (newFilter) {
      case "today":
        fetchTodayLeaves(isRefresh: true);
        break;
      case "pending":
        fetchTodayPendingLeaves(isRefresh: true);
        break;
      case "approved":
        fetchTodayApprovedLeaves(isRefresh: true);
        break;
      default:
        fetchAllLeaves(isRefresh: true);
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