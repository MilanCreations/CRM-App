import 'package:crm_milan_creations/API%20Services/BaseURL_&_EndPoints.dart';
import 'package:crm_milan_creations/Admin/Create%20Company/Get%20All%20Cities/getCitiesModel.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class GetAllCitiesListController extends GetxController {
  var isLoading = false.obs;
  var getCitiesListList = [].obs;

  //.............. Individual Function for Attendance History ................
  Future<void> allCitiesListfunctions(String stateId) async {
    print('get all countries function called');
    try {
      isLoading.value = true;

      // ✅ Build query params
      final uri = Uri.parse("${ApiConstants.getCitiesListList}/$stateId");

      print("Final all cities list API URL: $uri");

      final response = await http.get(uri);

      print("API Status Code of all cities: ${response.statusCode}");
      print("API Response of all cities: ${response.body}");
      if (response.statusCode == 200) {
        var getCitiesListModel = getAllCitiesModelFromJson(response.body);
        getCitiesListList.addAll(getCitiesListModel.data);
        print('get Cities List Model list:- $getCitiesListList');
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
