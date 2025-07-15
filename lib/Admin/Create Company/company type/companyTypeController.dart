import 'package:crm_milan_creations/API%20Services/BaseURL_&_EndPoints.dart';
import 'package:crm_milan_creations/Admin/Create%20Company/company%20type/companyTypeModel.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CompanyTypesController extends GetxController {
  var isLoading = false.obs;
  var companyTypesList = [].obs;

  //.............. Individual Function for Attendance History ................
  Future<void> getCompanyTypesfunctions() async {
    print('get company type function called');
    try {
      isLoading.value = true;

      // ✅ Build query params
      final uri = Uri.parse(ApiConstants.companyTyplesList);

      print("Final company types API URL: $uri");

      final response = await http.get(
        uri,
        // headers: {"Authorization": "Bearer $token"},
      );

      print("API Status Code of company types: ${response.statusCode}");
      print("API Response of company types: ${response.body}");
      if (response.statusCode == 200) {
        var getCompanyTypesModel = companytypeModelFromJson(response.body);
        companyTypesList.addAll(getCompanyTypesModel.data);
        print('company types list:- $companyTypesList');
      } else {
        Get.snackbar(
          "Error",
          "Failed to fetch data",
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
