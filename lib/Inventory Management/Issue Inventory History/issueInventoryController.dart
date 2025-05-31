import 'package:crm_milan_creations/Inventory%20Management/Issue%20Inventory%20History/issueInventoryModel.dart';
import 'package:get/get.dart';

class IssueInventoryController extends GetxController {
  var inventoryList = <IssueInventory>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Dummy data
    inventoryList.addAll([
      IssueInventory(
        employee: 'Ritesh Kumar',
        date: '15/05/2023',
        issuedBy: 'IT Department',
        items: [
          InventoryDetail(
            type: 'Laptop',
            model: 'Dell XPS',
            serialNumber: 'SN12345',
            accessories: ['Mouse', 'Charger'],
          ),
          InventoryDetail(
            type: 'Monitor',
            model: 'LG UltraWide',
            serialNumber: 'SN54321',
            accessories: ['HDMI Cable'],
          ),
        ],
      ),
      IssueInventory(
        employee: 'Deepak Sharma',
        date: '20/06/2023',
        issuedBy: 'HR Department',
        items: [
          InventoryDetail(
            type: 'Desktop',
            model: 'HP EliteDesk',
            serialNumber: 'SN23456',
            accessories: ['Keyboard', 'Mouse'],
          ),
        ],
      ),
    ]);
  }

  void toggleExpanded(int index) {
    inventoryList[index].isExpanded = !inventoryList[index].isExpanded;
    inventoryList.refresh();
  }
}
