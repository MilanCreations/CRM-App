import 'package:crm_milan_creations/HR%20App/Add%20Employee/addEmployeeScreen.dart';
import 'package:crm_milan_creations/HR%20App/Change%20Emp%20Status/ChangeEmpStatusController.dart';
import 'package:crm_milan_creations/HR%20App/Employee%20List/EmployeeListController.dart';
import 'package:crm_milan_creations/HR%20App/view%20employees/viewEmployeeDetailsScreen.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/utils/font-styles.dart';
import 'package:crm_milan_creations/widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// No changes to your imports

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  final EmployeeListcontroller employeeListcontroller = Get.put(
    EmployeeListcontroller(),
  );

  final ChangeEmployeeStatusController changeController = Get.put(
    ChangeEmployeeStatusController(),
  );

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = "";
  String userRole = "";

  @override
  void initState() {
    super.initState();
    getUserData();
    _scrollController.addListener(_onScroll);
    employeeListcontroller.employeeListFunction();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      Future.delayed(Duration(milliseconds: 300), () {
        employeeListcontroller.employeeListFunction();
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getString("role_code") ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        gradient: const LinearGradient(
          colors: [Color(0xFFEC32B1), Color(0xFF0C46CC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        title: CustomText(
          text: 'Employees',
          fontWeight: FontWeight.bold,
          fontFamily: 'Roboto',
          color: CRMColors.whiteColor,
        ),
        actions: [
          userRole != "EMPLOYEE"
              ? TextButton(
                onPressed: () {
                  Get.to(AddemployeeScreen());
                },
                child: CustomText(
                  text: 'Add Employee',
                  color: CRMColors.whiteColor,
                  fontWeight: FontWeight.w500,
                ),
              )
              : SizedBox(),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search by name...",
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    employeeListcontroller.setSearchQuery('');
                  },
                ),
                 border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
              onChanged: (value) {
                if (value.length >= 2 || value.isEmpty) {
                  employeeListcontroller.setSearchQuery(value);
                }
              },
            ),
          ),
          Expanded(
            child: Obx(() {
              final list = employeeListcontroller.employeeList;
              if (list.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                controller: _scrollController,
                itemCount: list.length,
                padding: const EdgeInsets.all(12),
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  if (index == list.length &&
                      employeeListcontroller.hasMoreData.value) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final employee = list[index];

                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _infoRow(
                            "Employee ID",
                            employee.id?.toString() ?? "-",
                          ),
                          _infoRow("Name", employee.name ?? "No Name"),
                          _infoRow("Email", employee.email ?? "No Email"),
                          _infoRow(
                            "Department",
                            employee.department.name ?? "No Department",
                          ),
                          _infoRow(
                            "Designation",
                            employee.designation.name ?? "No Designation",
                          ),
                          _infoRow(
                            "Salary",
                            employee.salary ?? "Not Available",
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // View Button
                              Container(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFEC32B1),
                                      Color(0xFF0C46CC),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(8),
                                    onTap:
                                        () => Get.to(
                                          ViewEmployeeDetailsScreen(
                                            employeeId: employee.id!,
                                          ),
                                        ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 10,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Icon(
                                            Icons.visibility_outlined,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                          SizedBox(width: 6),
                                          Text(
                                            "View",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // Status Badge
                              // Tappable Status Badge
                              InkWell(
                                onTap: () {
                                  _showStatusChangeDialog(
                                    employee.id!,
                                    employee.status == 'active'
                                        ? 'inactive'
                                        : 'active',
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        employee.status == 'active'
                                            ? Colors.green[100]
                                            : Colors.red[100],
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        size: 10,
                                        color:
                                            employee.status == 'active'
                                                ? CRMColors.success
                                                : CRMColors.error,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        employee.status == 'active'
                                            ? "Active"
                                            : "Inactive",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color:
                                              employee.status == 'active'
                                                  ? CRMColors.success
                                                  : CRMColors.error,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: CustomText(
              text: "$label:",
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: CRMColors.darkGrey,
            ),
          ),
          Expanded(
            flex: 5,
            child: CustomText(
              text: value,
              fontSize: 14,
              color: CRMColors.darkerGrey,
            ),
          ),
        ],
      ),
    );
  }

  void _showStatusChangeDialog(int employeeId, String newStatus) {
    Get.defaultDialog(
      title: "Change Status",
      middleText:
          "Do you want to change the status to ${newStatus.toUpperCase()}?",
      textCancel: "Cancel",
      textConfirm: "Yes",
      confirmTextColor: Colors.white,
      onConfirm: () {
        Navigator.of(context).pop(); // Close dialog
        _changeEmployeeStatus(employeeId);
      },
    );
  }

  void _changeEmployeeStatus(int employeeId) async {
    final ChangeEmployeeStatusController controller = Get.put(
      ChangeEmployeeStatusController(),
    );
    await controller.changeEmployeeFunction(
      employeeId,
    ); // Update this method to accept ID
    // Refresh employee list after change
    employeeListcontroller.refreshList();
  }
}
// Compare this snippet from lib/Employee/profile/profileScreen.dart: