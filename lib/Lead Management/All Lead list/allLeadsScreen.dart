// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:crm_milan_creations/Employee/Get%20All%20Employees%20List/getAllEmployeeeListController.dart';
import 'package:crm_milan_creations/Employee/Get%20All%20Employees%20List/getAllEmployeeeListModel.dart';
import 'package:crm_milan_creations/Lead%20Management/All%20Lead%20list/allLeadListController.dart';
import 'package:crm_milan_creations/Lead%20Management/Assign%20Lead%20to%20Employees/assignLeadController.dart';
import 'package:crm_milan_creations/Lead%20Management/Get%20All%20Companies%20list/getAllCompaniesController.dart';
import 'package:crm_milan_creations/Lead%20Management/Get%20Lead%20Details%20for%20update%20lead/getLeadDetailsScreen.dart';
import 'package:crm_milan_creations/widgets/dropdown.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/utils/font-styles.dart';
import 'package:crm_milan_creations/widgets/appBar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AllLeadsScreen extends StatefulWidget {
  const AllLeadsScreen({super.key});

  @override
  State<AllLeadsScreen> createState() => _AllLeadsScreenState();
}

class _AllLeadsScreenState extends State<AllLeadsScreen> {
  final Getallemployeelistcontroller getallemployeelistcontroller = Get.put(
    Getallemployeelistcontroller(),
  );
  final GetallCompanieslistcontroller getallCompanieslistcontroller = Get.put(
    GetallCompanieslistcontroller(),
  );
  final AllLeadListcontroller allLeadListcontroller = Get.put(
    AllLeadListcontroller(),
  );

  final AssignLeadController assignLeadController = Get.put(
    AssignLeadController(),
  );

  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? selectedCompany;
  Resultemp? assignEmployee;
  String? employeeID;
  DateTime? startDate;
  DateTime? endDate;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    allLeadListcontroller.allLeadListFunction();
    getallemployeelistcontroller.getAllEmployeeListFunction();
    getallCompanieslistcontroller.getAllCompaniesListFunction();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !allLeadListcontroller.isLoading.value &&
        allLeadListcontroller.hasMoreData.value) {
      allLeadListcontroller.allLeadListFunction(
        loadMore: true, // This is the key change
        search: searchController.text.trim(),
        startDate: startDate,
        endDate: endDate,
      );
    }
  }

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => startDate = picked);
      _applyDateFilters();
    }
  }

  Future<void> _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => endDate = picked);
      // Trigger API call with new date filter
      _applyDateFilters();
    }
  }

  void _applyDateFilters() {
    if (startDate != null && endDate != null) {
      // Only apply filters if both dates are selected
      allLeadListcontroller.allLeadListFunction(
        isRefresh: true,
        startDate: startDate,
        endDate: endDate,
        search: searchController.text.trim(),
      );
    }
    // Don't filter if only one date is selected
  }

  // Add a clear filters button
  Widget _buildDateFilterUI() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: _selectStartDate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 18,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          startDate != null
                              ? 'From: ${formatDate(startDate)}'
                              : 'Select Start Date',
                          style: TextStyle(
                            color:
                                startDate != null
                                    ? Colors.black
                                    : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: _selectEndDate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 18,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          endDate != null
                              ? 'To: ${formatDate(endDate)}'
                              : 'Select End Date',
                          style: TextStyle(
                            color:
                                endDate != null
                                    ? Colors.black
                                    : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (startDate != null || endDate != null)
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFEC32B1), Color(0xFF0C46CC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    startDate = null;
                    endDate = null;
                  });
                  allLeadListcontroller.allLeadListFunction(
                    isRefresh: true,
                    search: searchController.text.trim(),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Clear Date Filters',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      allLeadListcontroller.allLeadListFunction(
        isRefresh: true,
        search: searchController.text.trim(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBackArrow: true,
        leadingIcon: Icons.arrow_back_ios_new_sharp,
        title: CustomText(
          text: 'All Lead List',
          color: CRMColors.whiteColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        elevation: 1,
        gradient: const LinearGradient(
          colors: [Color(0xFFEC32B1), Color(0xFF0C46CC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12.0, left: 8.0, right: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                onChanged: (value) => _onSearchChanged(),
                decoration: InputDecoration(
                  hintText: 'Search leads...',
                  prefixIcon: const Icon(Icons.search),
                  border: InputBorder.none,
                  suffixIcon:
                      searchController.text.isNotEmpty
                          ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              searchController.clear();
                              allLeadListcontroller.allLeadListFunction(
                                isRefresh: true,
                              );
                            },
                          )
                          : null,
                  // contentPadding: const EdgeInsets.symmetric(
                  //   horizontal: 16,
                  // ),
                ),
              ),
            ),
          ),
          // Update your date filter UI to include the clear button
          _buildDateFilterUI(),
          const SizedBox(height: 14),

          Obx(() {
            if (allLeadListcontroller.isLoading.value &&
                allLeadListcontroller.alleadList.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(color: CRMColors.black),
              );
            }
            if (allLeadListcontroller.alleadList.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: "No Leads Found",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: CRMColors.black,
                    ),
                  ],
                ),
              );
            }

            return Expanded(
              child: ListView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                padding: const EdgeInsets.all(12),
                itemCount:
                    allLeadListcontroller.alleadList.length +
                    (allLeadListcontroller.hasMoreData.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < allLeadListcontroller.alleadList.length) {
                    final lead = allLeadListcontroller.alleadList[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // First row with Date and Name
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: RichText(
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context).style,
                                      children: [
                                        TextSpan(
                                          text: 'Date: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: convertUtcToIst(
                                            lead.createdAt ?? '',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: RichText(
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context).style,
                                      children: [
                                        TextSpan(
                                          text: 'Name: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(text: lead.name),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            // Contact row
                            RichText(
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style,
                                children: [
                                  TextSpan(
                                    text: 'Contact: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(text: lead.phone),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Created by row
                            RichText(
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style,
                                children: [
                                  TextSpan(
                                    text: 'Created by: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // TextSpan(text: lead.leadCreator.name),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Email and Lead Count row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: RichText(
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context).style,
                                      children: [
                                        TextSpan(
                                          text: 'Email: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(text: lead.email),
                                      ],
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: RichText(
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context).style,
                                      children: [
                                        TextSpan(
                                          text: 'Lead Count: ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(text: lead.totalAssigned),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            // Purpose section
                            // Column(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     Text(
                            //       'Purpose:',
                            //       style: TextStyle(fontWeight: FontWeight.bold),
                            //     ),
                            //     const SizedBox(height: 4),
                            //     Text(
                            //       lead.remark ?? 'No purpose provided',
                            //       style: TextStyle(color: Colors.grey[700]),
                            //       maxLines: 3,
                            //       overflow: TextOverflow.ellipsis,
                            //     ),
                            //   ],
                            // ),
                            const SizedBox(height: 12),

                            // Assign button
                            Row(
                              children: [
                                Expanded(
                                  child: SizedBox(
                                    height: Get.height * 0.06,
                                    child: GestureDetector(
                                      onTap:
                                          () => Get.to(
                                            GetAndEditleadDetailsScreen(
                                              leadId: lead.id.toString(),
                                            ),
                                          ),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xFFEC32B1),
                                              Color(0xFF0C46CC),
                                            ], // Example gradient
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'Lead Detais',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: SizedBox(
                                    height: Get.height * 0.06,
                                    child: GestureDetector(
                                      onTap:
                                          () => showAssignLeadDialog(
                                            lead.id.toString(),
                                          ),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xFFEC32B1),
                                              Color(0xFF0C46CC),
                                            ], // Example gradient
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: const Text(
                                          'Assign',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
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
                    );
                  } else {
                    // Show loading indicator at the bottom when fetching more data
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: CRMColors.crmMainCOlor,
                        ),
                      ),
                    );
                  }
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  void showAssignLeadDialog(String leadid) {
    showDialog(
      context: context,
      builder:
          (_) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // header
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFFEC32B1), Color(0xFF0C46CC)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Icon(
                          Icons.assignment_ind_outlined,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Assign Lead",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Please select an employee and company to assign this lead.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      const SizedBox(height: 20),

                      // Assign to Employee
                      Obx(() {
                        return DropdownButtonHideUnderline(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: CRMColors.black1),
                            ),
                            child: DropdownButton2<Resultemp?>(
                              isExpanded: true,
                              hint: CustomText(text: 'Select Employee'),
                              items:
                                  getallemployeelistcontroller.employeeList
                                      .map<DropdownMenuItem<Resultemp?>>(
                                        (employee) =>
                                            DropdownMenuItem<Resultemp?>(
                                              value: employee,
                                              child: Text(employee.name),
                                            ),
                                      )
                                      .toList(),
                              value: assignEmployee,
                              onChanged: (Resultemp? value) {
                                setState(() {
                                  assignEmployee = value;
                                  employeeID = assignEmployee!.id.toString();
                                });
                              },
                              buttonStyleData: ButtonStyleData(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                height: 50,
                              ),

                              dropdownStyleData: DropdownStyleData(
                                maxHeight: 200,
                              ),
                            ),
                          ),
                        );
                      }),
                      const SizedBox(height: 12),

                      // Company Dropdown
                      Obx(() {
                        return CustomDropdownButton2(
                          hint: CustomText(text: 'Select Company'),
                          value: selectedCompany,
                          dropdownItems:
                              getallCompanieslistcontroller.companiesList
                                  .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCompany = value;
                            });
                          },
                        );
                      }),
                      const SizedBox(height: 25),

                      // Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Get.back(),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                side: const BorderSide(color: Colors.grey),
                              ),
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                assignLeadController.assignLeadFunction(
                                  leadid,
                                  selectedCompany!,
                                  employeeID!,
                                );
                                print(
                                  "Assigning to: $assignEmployee, Company: $selectedCompany",
                                );
                                setState(() {
                                  assignEmployee = null;
                                  selectedCompany = null;
                                });
                                Get.back();
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                backgroundColor: CRMColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "Assign",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
    );
  }

  String convertUtcToIst(DateTime utcTime) {
    try {
      DateTime istTime = utcTime.toUtc().add(
        const Duration(hours: 5, minutes: 30),
      );
      return DateFormat('dd-MM-yyyy').format(istTime);
    } catch (e) {
      return '-';
    }
  }
}
