import 'package:crm_milan_creations/Lead%20Management/Get%20All%20Companies%20list/getAllCompaniesController.dart';
import 'package:crm_milan_creations/Lead%20Management/Lead%20Status/leadStatusController.dart';
import 'package:crm_milan_creations/Lead%20Management/Lead%20Status/leadStatusModel.dart';
import 'package:crm_milan_creations/Lead%20Management/My%20Leads%20List/myLeadListController.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/utils/font-styles.dart';
import 'package:crm_milan_creations/widgets/appBar.dart';
import 'package:crm_milan_creations/widgets/button.dart';
import 'package:crm_milan_creations/widgets/dropdown.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class LeadListScreen extends StatefulWidget {
  const LeadListScreen({Key? key}) : super(key: key);

  @override
  State<LeadListScreen> createState() => _LeadListScreenState();
}

class _LeadListScreenState extends State<LeadListScreen> {
  final LeadListcontroller leadController = Get.put(LeadListcontroller());
  final TextEditingController searchController = TextEditingController();
  final LeadStatuscontroller leadStatuscontroller = Get.put(
    LeadStatuscontroller(),
  );
  final GetallCompanieslistcontroller getallCompanieslistcontroller = Get.put(
    GetallCompanieslistcontroller(),
  );

  DateTime? startDate;
  DateTime? endDate;
  Status? statusAssign;
  String? selectedCompany;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getallCompanieslistcontroller.getAllCompaniesListFunction();
    leadStatuscontroller.leadStatusFunction();
    leadController.leadListFunction(isRefresh: true);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !leadController.isLoading.value &&
        leadController.hasMoreData.value) {
      leadController.leadListFunction(
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
    if (picked != null) setState(() => startDate = picked);
  }

  Future<void> _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => endDate = picked);
  }

  String formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        showBackArrow: true,
        leadingIcon: Icons.arrow_back_ios_new_sharp,
        title: CustomText(
          text: 'My  Lead list',
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
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search bar
                Container(
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
                    decoration: InputDecoration(
                      hintText: 'Search leads...',
                      prefixIcon: const Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Date pickers
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
                          child: Text(
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
                          child: Text(
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
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Filter button
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: 'Search',
                    backgroundColor: CRMColors.dividerCOlor,
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      leadController.leadListFunction(
                        isRefresh: true,
                        search: searchController.text.trim(),
                        startDate: startDate,
                        endDate: endDate,
                      );
                    },
                    // style: ElevatedButton.styleFrom(
                    //   padding: const EdgeInsets.symmetric(vertical: 14),
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(10),
                    //   ),
                    //   backgroundColor: theme.primaryColor,
                    //   foregroundColor: Colors.white,
                    // ),

                    // icon: const Icon(Icons.filter_list),
                    // label: const CustomText(text:"Search",color: CRMColors.whiteColor,),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // List view
          Expanded(
            child: Obx(() {
              if (leadController.isLoading.value &&
                  leadController.leadList.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (leadController.leadList.isEmpty) {
                return const Center(child: Text('No leads found.'));
              }

              return ListView.builder(
                controller: _scrollController,
                itemCount:
                    leadController.leadList.length +
                    (leadController.hasMoreData.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < leadController.leadList.length) {
                    final lead = leadController.leadList[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        title: CustomText(
                          text: lead.name ?? 'No Name',
                          fontWeight: FontWeight.w600,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(text: 'Email: ${lead.email}'),
                            CustomText(text: 'Source: ${lead.source}'),
                            CustomText(text: 'Contact: ${lead.phone}'),
                            CustomText(text: 'Purpose: ${lead.remark}'),
                            CustomText(text: 'Current Status: ${lead.status}'),
                            CustomText(text: 'Created by: ${lead.leadCreator}'),
                            // Assign button
                            Align(
                              alignment: Alignment.topRight,
                              child: ElevatedButton(
                                onPressed:
                                    () => showAssignLeadDialog(
                                      lead.id.toString(),
                                    ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: CRMColors.dividerCOlor,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 10,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Update Status',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                        trailing: CustomText(
                          text:
                              lead.createdAt != null
                                  ? DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(lead.createdAt!)
                                  : '',
                          color: Colors.grey.shade700,
                        ),
                      ),
                    );
                  } else {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              );
            }),
          ),
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
                        "Update Lead",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Update Lead Status",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      const SizedBox(height: 20),

                      const SizedBox(height: 12),
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
                SizedBox(height: 10,),
                      // Assign to Employee
                      Obx(() {
                        return DropdownButtonHideUnderline(
                          child: DropdownButton2<Status?>(
                            buttonStyleData: ButtonStyleData(
                              height: 60,
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: CRMColors.black1),
                              ),
                              // elevation: widget.buttonElevation,
                            ),
                            isExpanded: true,
                            hint: Text(
                              'Select Status',
                              style: TextStyle(color: Colors.grey),
                            ),
                            items:
                                leadStatuscontroller.leadstatus
                                    .map<DropdownMenuItem<Status?>>(
                                      (employee) => DropdownMenuItem<Status?>(
                                        value: employee,
                                        child: Text(employee.name ?? ''),
                                      ),
                                    )
                                    .toList(),
                            value: statusAssign,
                            onChanged: (Status? value) {
                              setState(() {
                                statusAssign = value;
                              });
                            },

                            dropdownStyleData: DropdownStyleData(
                              maxHeight: 200,
                            ),
                          ),
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
                                // assignLeadController.assignLeadFunction(leadid,selectedCompany!,employeeID!);
                                leadStatuscontroller.leadStatusFunction();
                                setState(() {
                                  statusAssign = null;
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
                                "Save Changes",
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
}
