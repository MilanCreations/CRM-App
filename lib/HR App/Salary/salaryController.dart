import 'package:crm_milan_creations/API%20Services/BaseURL_&_EndPoints.dart';
import 'package:crm_milan_creations/Auth/Login/loginScreen.dart';
import 'package:crm_milan_creations/HR%20App/Salary/salaryModel.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SalaryController extends GetxController {
  var isLoading = false.obs;
  var salaryList = [].obs;
  var currentPage = 1.obs;
  var hasMoreData = true.obs;
  var searchText = ''.obs;
  var selectedMonth = Rx<String?>(null);
  var selectedYear = Rx<String?>(null);

  Future<void> salaryReportFunction({
    String name = "",
    bool isNewSearch = false,
    String? month,
    String? year,
  }) async {
    try {
      if (isNewSearch) {
        salaryList.clear();
        currentPage.value = 1;
        hasMoreData.value = true;
        searchText.value = name;
        selectedMonth.value = month;
        selectedYear.value = year;
      }

      if (!hasMoreData.value) return;

      isLoading.value = true;

      // Validate dates (optional)
      if (month != null && year != null && month.isNotEmpty && year.isNotEmpty) {
        // Not doing DateTime parse because month is like '01', year like '2023'
        // Just ensure month and year are valid, you can extend here if needed
      }

      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        clearSharedPreferences();
        Get.snackbar(
          "Error",
          "User is not authenticated. Login again!",
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
        return;
      }

      final url = Uri.parse(ApiConstants.salaryList).replace(
        queryParameters: {
          '_page': currentPage.value.toString(),
          '_limit': '10',
          '_sort': 'name',
          '_order': 'asc',
          'q': name,
          'month': month ?? '',
          'year': year ?? '',
        },
      );

      print("Final salary list API URL: $url");

      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        var salaryModel = salaryReportModelFromJson(response.body);
        print("Salary list data fetched successfully");

        if (salaryModel.result.isEmpty) {
          hasMoreData.value = false;
        } else {
          salaryList.addAll(salaryModel.result);
          currentPage.value++;
        }
      } else if (response.statusCode == 400) {
        hasMoreData.value = false;
        Get.snackbar(
          'Error',
          'Bad Request',
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
      } else if (response.statusCode == 401) {
        hasMoreData.value = false;
        clearSharedPreferences();
      } else if (response.statusCode == 500 || response.statusCode == 404) {
        hasMoreData.value = false;
        Get.snackbar(
          'Error',
          'No More Data',
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
      } else {
        hasMoreData.value = false;
        Get.snackbar(
          "Error",
          "Failed to fetch salary data",
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
      }
    } catch (error) {
      print("Error fetching salary list: $error");
      Get.snackbar(
        "Error",
        error.toString(),
        backgroundColor: CRMColors.error,
        colorText: CRMColors.textWhite,
      );
    } finally {
      isLoading.value = false;
      update();
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

  void searchQuery(String name) {
    salaryReportFunction(
      name: name,
      isNewSearch: true,
      month: selectedMonth.value,
      year: selectedYear.value,
    );
  }

  void updateFilters({String? month, String? year}) {
    salaryReportFunction(
      isNewSearch: true,
      name: searchText.value,
      month: month,
      year: year,
    );
  }
}
