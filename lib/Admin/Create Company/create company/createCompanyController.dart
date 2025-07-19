// create_company_controller.dart
import 'dart:convert';
import 'dart:io';
import 'package:crm_milan_creations/API%20Services/BaseURL_&_EndPoints.dart';
import 'package:crm_milan_creations/Admin/Create%20Company/create%20company/createCompanyModel.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateCompanyController extends GetxController {
  var isLoading = false.obs;

  String _getMimeType(String filePath) {
    final extension = filePath.split('.').last.toLowerCase();
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'jpeg';
      case 'png':
        return 'png';
      case 'gif':
        return 'gif';
      case 'bmp':
        return 'bmp';
      case 'webp':
        return 'webp';
      default:
        return 'jpeg';
    }
  }

  Future<bool> createCompany({
    required String companyName,
    required String companyTypeId,
    required String countryId,
    required String stateId,
    required String cityId,
    required String address,
    required String adminName,
    required String adminEmail,
    required String gstId,
    required String branchName,
    File? companyLogo,
  }) async {
    isLoading.value = true;

    try {
      var uri = Uri.parse(ApiConstants.createNewCompany);
      print('📤 API Endpoint: $uri');

      var request = http.MultipartRequest('POST', uri);

      request.fields['companyName'] = companyName;
      request.fields['companyType'] = companyTypeId;
      request.fields['country'] = countryId;
      request.fields['state'] = stateId;
      request.fields['city'] = cityId;
      request.fields['address'] = address;
      request.fields['adminName'] = adminName;
      request.fields['adminEmail'] = adminEmail;
      request.fields['gstId'] = gstId;
      request.fields['branch_name'] = branchName;

      print('📝 Request Fields:');
      request.fields.forEach((key, value) {
        print('  ➤ $key: $value');
      });

      if (companyLogo != null) {
        print('📎 Adding file: ${companyLogo.path}');
        request.files.add(
          await http.MultipartFile.fromPath(
            'companyLogo',
            companyLogo.path,
            contentType: MediaType('image', _getMimeType(companyLogo.path)),
          ),
        );
      } else {
        print('⚠️ No file selected');
      }

      print('⏳ Sending request...');
      var response = await request.send();

      print('✅ Response Status Code: ${response.statusCode}');
      var responseBody = await response.stream.bytesToString();
      print('📦 Raw Response Body: $responseBody');

      var decoded = jsonDecode(responseBody);
      print('📑 Decoded Response: $decoded');

      if (response.statusCode == 201 && decoded['success'] == true) {
        final token = decoded["activationToken"];
        print('🔐 Activation Token: $token');
        var addcompanyModel = createNewCompanyModelFromJson(responseBody);
        print('success:- ${addcompanyModel.message}');
        print('success:- ${addcompanyModel.success}');

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("activationToken", token);

        Get.snackbar(
          "Success",
          addcompanyModel.message,
          backgroundColor: CRMColors.success,
          colorText: CRMColors.textWhite,
        );
        return true;
      }
      if (response.statusCode == 409) {
        var addcompanyModel = createNewCompanyModelFromJson(responseBody);
        Get.snackbar(
          "Message",
          addcompanyModel.message,
          backgroundColor: CRMColors.success,
          colorText: CRMColors.textWhite,
        );
        return true;
      }
      if (response.statusCode == 400) {
        var addcompanyModel = createNewCompanyModelFromJson(responseBody);
        Get.snackbar(
          "Message",
          addcompanyModel.message,
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
        return false;
      }
      if (response.statusCode == 500) {
        Get.snackbar(
          "Message",
          "Internal Server Error",
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
        return false;
      }
      if (response.statusCode == 403) {
        Get.snackbar(
          "Message",
          "Forbidden Access",
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
        return false;
      }
      if (response.statusCode == 401) {
        Get.snackbar(
          "Message",
          "Unauthorized Access",
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
        return false;
      } else {
        print('Error from server: ${decoded['message']}');

        Get.snackbar(
          "Message",
          decoded['message'] ?? 'Something went wrong',
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
        return false;
      }
    } catch (e) {
      print("Exception occurred: $e");

      Get.snackbar(
        "Exception",
        e.toString(),
        backgroundColor: CRMColors.error,
        colorText: CRMColors.textWhite,
      );
      return false;
    } finally {
      print('🔚 Request finished');
      isLoading.value = false;
    }
  }
}
