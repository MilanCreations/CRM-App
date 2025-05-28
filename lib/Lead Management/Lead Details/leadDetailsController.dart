import 'package:crm_milan_creations/API%20Services/BaseURL_&_EndPoints.dart';
import 'package:crm_milan_creations/Lead%20Management/Lead%20Details/leadDetailsModel.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Leaddetailscontroller extends GetxController {
  var isLoading = false.obs;
  var leadDetailsList = [].obs;
  var currentPage = 1.obs;
  var hasMoreData = true.obs;
  var searchQuery = "".obs;

Future<void> leadDetailsFunction({bool isRefresh = false, required String assignId,String search = '',}) async {
  try {
    if (isLoading.value) return;
    isLoading.value = true;
    
    if (isRefresh) {
      currentPage.value = 1;
      leadDetailsList.clear();
      hasMoreData.value = true;
    }

    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      isLoading.value = false;
      Get.snackbar(
        "Error",
        "User is not authenticated. Login again!",
        backgroundColor: CRMColors.error,
        colorText: CRMColors.textWhite,
      );
      return;
    }
    
    String baseUrl = ApiConstants.leadDetails;
    String queryParams = '?assign_id=$assignId&_page=${currentPage.value}&_limit=10&q=$search';
    final url = Uri.parse('$baseUrl$queryParams');
    print('Fetching URL in lead details: $url');

    
    final response = await http.get(
      url,
      headers: {'Authorization': "Bearer $token"},
    );
    
    print("Response Status: ${response.statusCode}"); // Add this
    print("Response Body: ${response.body}"); // Add this
    
    if (response.statusCode == 200) {
      try {
        var leadsDetailsModel = leadDetailsModelFromJson(response.body);
        print("Parsed Model: $leadsDetailsModel"); // Add this
        
        leadDetailsList.addAll(leadsDetailsModel.result);
        print("Lead details fetched successfully: ${leadsDetailsModel.result}");
        
        // Check if there's more data
        if (leadsDetailsModel.result.isEmpty || leadsDetailsModel.result.length < 10) {
          hasMoreData.value = false;
        } else {
          currentPage.value++;
        }
            } catch (e) {
        print("Error parsing response: $e");
        Get.snackbar(
          "Error",
          "Failed to parse lead details",
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
      }
    } else {
      Get.snackbar(
        "Error",
        "Failed to load lead details: ${response.statusCode}",
        backgroundColor: CRMColors.error,
        colorText: CRMColors.textWhite,
      );
    }
  } catch (e) {
    print("Error in leadListFunction: $e");
    isLoading.value = false;
    Get.snackbar(
      "Error",
      "Failed to load lead details: $e",
      backgroundColor: CRMColors.error,
      colorText: CRMColors.white,
    );
  } finally {
    isLoading.value = false;
  }
}
}