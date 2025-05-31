class InventoryDetail {
  final String type;
  final String model;
  final String serialNumber;
  final List<String> accessories;

  InventoryDetail({
    required this.type,
    required this.model,
    required this.serialNumber,
    required this.accessories,
  });
}

class IssueInventory {
  final String employee;
  final String date;
  final String issuedBy;
  final List<InventoryDetail> items;
  bool isExpanded;

  IssueInventory({
    required this.employee,
    required this.date,
    required this.issuedBy,
    required this.items,
    this.isExpanded = false,
  });
}
