import 'dart:convert';
import 'package:crm_milan_creations/API%20Services/BaseURL_&_EndPoints.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class EditLeadController extends GetxController {
  var isLoading = false.obs;

  // You can make these dynamic if you want to populate from a form

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController remark = TextEditingController();
  TextEditingController branchName = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController source = TextEditingController();
  TextEditingController queryType = TextEditingController();
  TextEditingController leadCreator = TextEditingController();

  // Endpoint (replace with actual)
  final String apiUrl = ApiConstants.updateLead; // Replace

  Future<void> editLeadDetailsFunction(String leadId) async {
    isLoading.value = true;

    final body = {
      "name": name,
      "email": email,
      "phone": phone,
      "remark": remark,
      "branch_name": branchName,
      "address": address,
      "source": source,
      "query_type": queryType,
      "lead_creator": leadCreator, // Can be null
    };

    try {
      final response = await http.post(
        Uri.parse('$apiUrl/$leadId'), // Assuming you're passing ID in URL
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData["status"] == "success") {
          Get.snackbar("Success", "Lead updated successfully");
        } else {
          Get.snackbar(
            "Failed",
            "Something went wrong: ${jsonData["message"]}",
          );
        }
      } else {
        Get.snackbar("Error", "Failed with status ${response.statusCode}");
      }
    } catch (e) {
      print("Catch Error in editLeadDetailsFunction: $e");
      Get.snackbar("Exception", "Something went wrong");
    } finally {
      isLoading.value = false;
    }
  }
}
