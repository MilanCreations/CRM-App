import 'package:crm_milan_creations/API%20Services/BaseURL_&_EndPoints.dart';
import 'package:crm_milan_creations/Admin/Create%20Company/country/getCountriesModel.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class GetAllCountriesController extends GetxController {
  var isLoading = false.obs;
  var getAllCountriesList = [].obs;

  //.............. Individual Function for Attendance History ................
  Future<void> allCountriesfunctions() async {
    print('get all countries function called');
    try {
      isLoading.value = true;

      // ✅ Build query params
      final uri = Uri.parse(ApiConstants.getAllCountriesList);

      print("Final all countries API URL: $uri");

      final response = await http.get(uri);

      print("API Status Code of all countries: ${response.statusCode}");
      print("API Response of all countries: ${response.body}");
      if (response.statusCode == 200) {
        var getCompanyTypesModel = getAllCountriesModelFromJson(response.body);
        getAllCountriesList.addAll(getCompanyTypesModel.data);
        print('all countries list:- $getAllCountriesList');
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
