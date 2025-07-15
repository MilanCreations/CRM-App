import 'package:crm_milan_creations/API%20Services/BaseURL_&_EndPoints.dart';
import 'package:crm_milan_creations/Admin/Create%20Company/State/stateModel.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class GetAllStatesController extends GetxController {
  var isLoading = false.obs;
  var getAllStatesList = [].obs;

  //.............. Individual Function for Attendance History ................
  Future<void> getStatesByCountryId(String countryId) async {
    print('get all states function called');
    try {
      isLoading.value = true;
      getAllStatesList.clear();
      // ✅ Build query params
      final uri = Uri.parse("${ApiConstants.getAllStatesList}/$countryId");

      print("Final all states API URL: $uri");

      final response = await http.get(uri);

      print("API Status Code of all states: ${response.statusCode}");
      print("API Response of all states: ${response.body}");
      if (response.statusCode == 200) {
        var getAllStatesModel = getAllStatesModelFromJson(response.body);
        getAllStatesList.addAll(getAllStatesModel.data);
        print('all states list:- $getAllStatesList');
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
