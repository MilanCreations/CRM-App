import 'dart:async';
import 'package:crm_milan_creations/HR%20App/Salary/salaryController.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/utils/font-styles.dart';
import 'package:crm_milan_creations/widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Salaryscreen extends StatefulWidget {
  const Salaryscreen({super.key});

  @override
  State<Salaryscreen> createState() => _SalaryscreenState();
}

class _SalaryscreenState extends State<Salaryscreen> {
  final SalaryController salarycontroller = Get.put(SalaryController());
  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  Timer? _debounceTimer;
  String userRole = "";

  late List<String> months = [
    '',
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12',
  ];

  late final List<String> years;
  String selectedMonth = '';
  String selectedYear = '';

  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getString("role_code") ?? "";
    });
  }

  @override
  void initState() {
    super.initState();
    salarycontroller.salaryReportFunction();
    scrollController.addListener(_onScroll);
    getUserData();

    int currentYear = DateTime.now().year;
    years = List.generate(10, (index) => (currentYear - index).toString());
    years.insert(0, '');
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      salarycontroller.salaryReportFunction(
        name: searchController.text.trim(),
        month: selectedMonth.isEmpty ? null : selectedMonth,
        year: selectedYear.isEmpty ? null : selectedYear,
      );
    }
  }

  void _onSearchChanged(String value) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      salarycontroller.salaryReportFunction(
        name: value.trim(),
        isNewSearch: true,
        month: selectedMonth.isEmpty ? null : selectedMonth,
        year: selectedYear.isEmpty ? null : selectedYear,
      );
    });
  }

  void _onMonthChanged(String? value) {
    setState(() {
      selectedMonth = value ?? '';
    });
    salarycontroller.salaryReportFunction(
      isNewSearch: true,
      name: searchController.text.trim(),
      month: selectedMonth.isEmpty ? null : selectedMonth,
      year: selectedYear.isEmpty ? null : selectedYear,
    );
  }

  void _onYearChanged(String? value) {
    setState(() {
      selectedYear = value ?? '';
    });
    salarycontroller.salaryReportFunction(
      isNewSearch: true,
      name: searchController.text.trim(),
      month: selectedMonth.isEmpty ? null : selectedMonth,
      year: selectedYear.isEmpty ? null : selectedYear,
    );
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBackArrow: true,
        leadingIcon: Icons.arrow_back_ios_new_rounded,
        gradient: const LinearGradient(
          colors: [Color(0xFFEC32B1), Color(0xFF0C46CC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        title: CustomText(
          text: 'Salary',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: CRMColors.whiteColor,
        ),
        backgroundColor: CRMColors.crmMainCOlor,
      ),
      body: Column(
        children: [
          if (userRole != "EMPLOYEE")
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // 🔍 Search
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Search by name...",
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          searchController.clear();
                          setState(() {
                            selectedMonth = '';
                            selectedYear = '';
                          });
                          salarycontroller.salaryReportFunction(
                            name: '',
                            isNewSearch: true,
                            month: null,
                            year: null,
                          );
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                    ),
                    onChanged: _onSearchChanged,
                  ),
                  const SizedBox(height: 12),

                  // 📆 Filters
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedMonth.isEmpty ? null : selectedMonth,
                          decoration: InputDecoration(
                            labelText: 'Month',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                          ),
                          items:
                              months.map((month) {
                                String label =
                                    month.isEmpty ? 'All Months' : month;
                                return DropdownMenuItem(
                                  value: month,
                                  child: Text(label),
                                );
                              }).toList(),
                          onChanged: _onMonthChanged,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedYear.isEmpty ? null : selectedYear,
                          decoration: InputDecoration(
                            labelText: 'Year',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.grey.shade100,
                          ),
                          items:
                              years.map((year) {
                                String label =
                                    year.isEmpty ? 'All Years' : year;
                                return DropdownMenuItem(
                                  value: year,
                                  child: Text(label),
                                );
                              }).toList(),
                          onChanged: _onYearChanged,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          // 📋 Salary List
          Expanded(
            child: Obx(() {
              if (salarycontroller.isLoading.value &&
                  salarycontroller.salaryList.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              } else if (salarycontroller.salaryList.isEmpty) {
                return const Center(child: Text("No salary data found"));
              } else {
                return ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.all(12),
                  itemCount:
                      salarycontroller.salaryList.length +
                      (salarycontroller.hasMoreData.value ? 1 : 0),
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
               itemBuilder: (context, index) {
  if (index < salarycontroller.salaryList.length) {
    final item = salarycontroller.salaryList[index];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: CRMColors.whiteColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: CRMColors.crmMainCOlor.withOpacity(0.05),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 👤 Header Row with Avatar and Name
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: CRMColors.crmMainCOlor,
                  radius: 20,
                  child: Text(
                    item.name.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      color: CRMColors.whiteColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: CRMColors.textPrimary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: CRMColors.greenLight, // Define in `CRMColors`
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "₹${item.baseSalary}",
                    style: TextStyle(
                      color: CRMColors.greenDark, // Define in `CRMColors`
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 📊 Attendance Grid
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _statBox("Present", "${item.presentDays}", Icons.check_circle, CRMColors.blue),
                _statBox("Unpaid", "${item.unpaidLeaves}", Icons.cancel, CRMColors.red),
                _statBox("Late", "${item.lateArrivals}", Icons.schedule, CRMColors.orange),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _statBox("Early Leave", "${item.earlyLeaves}", Icons.exit_to_app, CRMColors.purple),
                _statBox("Hours", "${item.workingHours.toStringAsFixed(1)}", Icons.work_outline, CRMColors.teal),
                _statBox("Deduction", "₹${item.deduction}", Icons.currency_rupee_sharp, CRMColors.crmMainCOlor),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top:8.0,left: 5.0),
              child: CustomText(text: 'Total Payable',fontWeight: FontWeight.bold,),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: CustomText(text: "${item.payableSalary}/-",fontWeight: FontWeight.bold,color: CRMColors.greenDark,fontSize: 20,),
            )
          ],
        ),
      ),
    );
  } else {
    return const Center(child: CircularProgressIndicator());
  }
},

                );
              }
            }),
          ),
        ],
      ),
    );
  }

Widget _statBox(String label, String value, IconData icon, Color color) {
  return Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
        ],
      ),
    ),
  );
}

}
