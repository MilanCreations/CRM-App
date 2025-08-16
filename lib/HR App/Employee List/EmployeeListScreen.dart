import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crm_milan_creations/HR App/Add Employee/addEmployeeScreen.dart';
import 'package:crm_milan_creations/HR App/Change Emp Status/ChangeEmpStatusController.dart';
import 'package:crm_milan_creations/HR App/Employee List/EmployeeListController.dart';
import 'package:crm_milan_creations/HR App/view personal employees details/viewEmployeePersonalDetailsScreen.dart';
import 'package:crm_milan_creations/HR%20App/Add%20Employee/addEmployeeController.dart';
import 'package:crm_milan_creations/Razorpay%20Services/razorpay_services.dart';
import 'package:crm_milan_creations/Subscription/Check%20Subscripion/checkSubscriptionController.dart';
import 'package:crm_milan_creations/Subscription/Create%20Order/createOrderController.dart';
import 'package:crm_milan_creations/Subscription/Upgrade/upgradeController.dart';
import 'package:crm_milan_creations/Subscription/Verify%20Payment/verify-payment-Controller.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/utils/font-styles.dart';
import 'package:crm_milan_creations/widgets/appBar.dart';
import 'package:crm_milan_creations/widgets/connectivity_service.dart';
import 'package:crm_milan_creations/widgets/textfiled.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final CheckSubscriptioncontroller checkSubscription = Get.put(
    CheckSubscriptioncontroller(),
  );
  final Createordercontroller createOrderController = Get.put(
    Createordercontroller(),
  );
  final VerifyPaymentController verifyPaymentController = Get.put(
    VerifyPaymentController(),
  );
  final AddEmployeeController employeeFormController = Get.put(
    AddEmployeeController(),
  );
  final UpgradeController upgradeController = Get.put(UpgradeController());
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final ConnectivityService _connectivityService = ConnectivityService();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  String userRole = "";

  @override
  void initState() {
    super.initState();
    getUserData();
    _scrollController.addListener(_onScroll);
    employeeListcontroller.employeeListFunction();
    checkSubscription.checkSubscriptionFunction();
    _checkInitialConnection();
    _setupConnectivityListener();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      if (!employeeListcontroller.isLoading.value &&
          employeeListcontroller.hasMoreData.value) {
        employeeListcontroller.employeeListFunction();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getString("role_code") ?? "";
    });
  }

  Future<void> _checkInitialConnection() async {
    if (!(await _connectivityService.isConnected())) {
      _connectivityService.showNoInternetScreen();
    }
  }

  void _setupConnectivityListener() {
    _connectivitySubscription = _connectivityService
        .listenToConnectivityChanges(
          onConnected: () {},
          onDisconnected: () {
            _connectivityService.showNoInternetScreen();
          },
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
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        title: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.red),
            const SizedBox(width: 8),
            const Text(
              "Change Status",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          "Are you sure you want to change the status to '${newStatus.toUpperCase()}'?",
          style: const TextStyle(fontSize: 16),
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(foregroundColor: Colors.grey[700]),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _changeEmployeeStatus(employeeId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text("Yes", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _changeEmployeeStatus(int employeeId) async {
    await changeController.changeEmployeeFunction(employeeId);
    employeeListcontroller.refreshList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBackArrow: true,
        leadingIcon: Icons.arrow_back_ios_new_sharp,
        gradient: const LinearGradient(
          colors: [Color(0xFFEC32B1), Color(0xFF0C46CC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        title: CustomText(
          text: 'All Employees',
          color: CRMColors.whiteColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          userRole != "EMPLOYEE"
              ? TextButton(
                onPressed: () async {
                  bool isActive =
                      await checkSubscription.checkSubscriptionFunction();
                  if (isActive) {
                    Get.to(AddemployeeScreen());
                  } else {
                    _showUpgradeDialog();
                  }
                },
                child: CustomText(
                  text: 'Add Employee',
                  color: CRMColors.whiteColor,
                  fontWeight: FontWeight.w500,
                ),
              )
              : const SizedBox(),
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
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
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
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
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
              final hasMore = employeeListcontroller.hasMoreData.value;
              final loading = employeeListcontroller.isLoading.value;

              if (list.isEmpty && loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (list.isEmpty) {
                return const Center(
                  child: CustomText(text: "No Employees Found"),
                );
              }

              return ListView.builder(
                controller: _scrollController,
                itemCount: list.length + (hasMore ? 1 : 0),
                padding: const EdgeInsets.all(12),
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  if (index == list.length) {
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
                              _buildViewButton(employee.id.toString()),
                              Obx(() {
                                final isUpdating =
                                    changeController.currentUpdatingId.value ==
                                    employee.id;
                                final isLoadingStatus =
                                    changeController.isLoading.value &&
                                    isUpdating;
                                return InkWell(
                                  onTap:
                                      isLoadingStatus
                                          ? null
                                          : () => _showStatusChangeDialog(
                                            employee.id!,
                                            employee.status == 'active'
                                                ? 'inactive'
                                                : 'active',
                                          ),
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
                                        if (isLoadingStatus)
                                          SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color:
                                                  employee.status == 'active'
                                                      ? CRMColors.success
                                                      : CRMColors.error,
                                            ),
                                          )
                                        else
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
                                          isLoadingStatus
                                              ? "Updating..."
                                              : (employee.status == 'active'
                                                  ? "Active"
                                                  : "Inactive"),
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
                                );
                              }),
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

  Widget _buildViewButton(String id) => Container(
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFFEC32B1), Color(0xFF0C46CC)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          Get.to(ViewEmployeePersonalDetailsScreen(employeeId: id));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.visibility_outlined, color: Colors.white, size: 18),
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
  );

  void _showUpgradeDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.upgrade_rounded,
                size: 48,
                color: Colors.blueAccent,
              ),
              const SizedBox(height: 16),
              const Text(
                "Upgrade Plan",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                "You've reached the maximum number of employees. Upgrade your plan to continue adding more.",
                style: TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.grey[700], fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFEC32B1), Color(0xFF0C46CC)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          _openUpgradeBottomSheet();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Upgrade Now",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _openUpgradeBottomSheet() {
    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Add Employees',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              CustomTextFormField(
                label: 'Number of employees (1–9)',
                keyboardType: TextInputType.number,
                backgroundColor: CRMColors.background,
                controller: createOrderController.employeeCountController,
                onChanged: (val) {
                  createOrderController.employeeCount.value = val;
                },
              ),

              Obx(() {
                final count =
                    int.tryParse(createOrderController.employeeCount.value) ??
                    0;
                if (count > 0 && count <= 9) {
                  final base = count * 100;
                  final total = (base * 1.18).round();
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Total Amount: ₹${total.toStringAsFixed(2)} (₹$base + 18% GST)',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
                return const SizedBox();
              }),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.grey[700], fontSize: 16),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: Obx(() {
                      final isLoading =
                          createOrderController.isLoading.value ||
                          verifyPaymentController.isLoading.value ||
                          upgradeController.isLoading.value;

                      return Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFEC32B1), Color(0xFF0C46CC)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ElevatedButton(
                          onPressed:
                              isLoading ? null : () => _handleUpgradePayment(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child:
                              isLoading
                                  ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                  : const Text(
                                    "Add Employees",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      isDismissible: true,
      enableDrag: true,
    );
  }

  Future<void> _handleUpgradePayment() async {
    try {
      final count =
          int.tryParse(
            createOrderController.employeeCountController.text.trim(),
          ) ??
          0;

      if (count < 1 || count > 9) {
        Get.snackbar(
          "Error",
          "Please enter a number between 1 and 9",
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
        return;
      }

      // 1️⃣ Upgrade to get usageId
      final upgradeSuccess = await upgradeController.upgradeFunction(count);
      if (!upgradeSuccess ||
          upgradeController.upgradeModel.value?.data?.usageId?.id == null) {
        throw Exception('Failed to upgrade or get usage ID');
      }
      final usageId = upgradeController.upgradeModel.value!.data!.usageId!.id;

      // 2️⃣ Create Razorpay order
      await createOrderController.createOrderFunction();
      if (createOrderController.orderId.value.isEmpty) {
        throw Exception('Failed to create order');
      }

      // 3️⃣ Calculate total amount (base + GST)
      final total = (count * 100 * 1.18).round();

      // Close bottom sheet before payment
      Get.back();

      // 4️⃣ Start Razorpay Payment
      RazorpayService.makePayment(
        amount: total,
        name: 'Employee Upgrade',
        email:
            employeeFormController.emailController.text.isNotEmpty
                ? employeeFormController.emailController.text
                : 'test@gmail.com',
        contact:
            employeeFormController.phoneController.text.isNotEmpty
                ? employeeFormController.phoneController.text
                : '7986204508',
        description: "Adding $count employees",
        orderId: createOrderController.orderId.value,
        onSuccess: (res) async {
          // 5️⃣ Verify payment with backend
          final verifySuccess = await verifyPaymentController.verifyPayment(
            razorpayOrderId: res.orderId ?? '',
            razorpayPaymentId: res.paymentId ?? '',
            razorpaySignature: res.signature ?? '',
            usageId: usageId,
          );

          if (verifySuccess) {
            // 6️⃣ Add employee
            await employeeFormController.inviteemployeeFunction();

            // Clear fields only after successful addition
            createOrderController.employeeCountController.clear();

            Get.snackbar(
              "Success",
              "Employee added successfully!",
              backgroundColor: Colors.green,
              colorText: CRMColors.textWhite,
            );
          }
        },
        onError: (err) {
          Get.snackbar(
            "Payment Failed",
            err.message ?? "Payment failed",
            backgroundColor: CRMColors.error,
            colorText: CRMColors.textWhite,
          );
        },
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: CRMColors.error,
        colorText: CRMColors.textWhite,
      );
    }
  }
}
