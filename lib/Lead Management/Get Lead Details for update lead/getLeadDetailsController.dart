import 'package:crm_milan_creations/API%20Services/BaseURL_&_EndPoints.dart';
import 'package:crm_milan_creations/Auth/Login/loginScreen.dart';
import 'package:crm_milan_creations/Lead%20Management/Get%20Lead%20Details%20for%20update%20lead/getLeadDetailsModel.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class GetLeadDetails extends GetxController {
  var isLoading = false.obs;
  var id = 0.obs;
  var email = ''.obs;
  var name = ''.obs;
  var phone = ''.obs;
  var address = ''.obs;
  var visitTime = ''.obs;
  var remark = ''.obs;
  var branchName = ''.obs;
  var branchId = ''.obs;
  var phoneVerified = ''.obs;
  var source = ''.obs;
  var queryType = ''.obs;
  var conversionTypeId = ''.obs;
  var leadCreator = ''.obs;

  Future<void> fetchLeadDetails(String leadId) async {
    print("Get Lead Details Function called with ID: $leadId");
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      print("Token fetched in Get Lead details: $token");
      if (token == null) {
        isLoading.value = false;
      clearSharedPreferences();
        print("Token is null, cannot fetch lead details");
        return;
      }

      final url = Uri.parse("${ApiConstants.getLeadDetails}/$leadId");
      print("URL for fetching lead details: $url");

      final response = await http.get(url, headers: {"Authorization": "Bearer $token"});
      print("Response status code: ${response.statusCode}");
      print("Response body of get lead detaisl with ID: ${response.body}");

      if(response.statusCode == 200) {
        
        final data = getLeadDetailsModelFromJson(response.body);
        print("Data fetched successfully: $data");

        // Assuming the response is in JSON format and contains the necessary fields
        final leadDetails = data; // Parse the JSON data as needed

        // Update the controller variables with the fetched data
        id.value = int.parse(leadDetails.data.id.toString());
        email.value = leadDetails.data.email;
        name.value = leadDetails.data.name;
        phone.value = leadDetails.data.phone;
        address.value = leadDetails.data.address;
        visitTime.value = leadDetails.data.visitTime.toString();
        remark.value = leadDetails.data.remark;
        branchName.value = leadDetails.data.branchName;
        branchId.value = leadDetails.data.branchId.toString();
        phoneVerified.value = leadDetails.data.phoneVerified.toString();
        source.value = leadDetails.data.source;
        queryType.value = leadDetails.data.queryType;
        conversionTypeId.value = leadDetails.data.conversionTypeId.toString();
        leadCreator.value = leadDetails.data.leadCreator.toString();
        print("Lead details updated successfully");
        isLoading.value = false;
      } else if (response.statusCode == 400) {
      Get.snackbar('Error', 'Bad Request',
          backgroundColor: CRMColors.error, colorText: CRMColors.textWhite);
    } else if (response.statusCode == 401) {
      Get.snackbar('Message', 'Login session expired',
          backgroundColor: CRMColors.error, colorText: CRMColors.textWhite);
    } else if (response.statusCode == 500 || response.statusCode == 404) {
        Get.snackbar(
          'Error',
          'No More Data',
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
      }
      
      else {
        print("Failed to fetch lead details, status code: ${response.statusCode}");
      }

    } catch (e) {
      // Handle error
      print("catch Error fetching lead details: $e");
    } finally {
      print("finally block executed");
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
