import 'package:crm_milan_creations/Employee/Get%20All%20Employees%20List/getAllEmployeeeListController.dart';
import 'package:crm_milan_creations/Employee/Get%20All%20Employees%20List/getAllEmployeeeListModel.dart';
import 'package:crm_milan_creations/Lead%20Management/All%20Lead%20list/allLeadListController.dart';
import 'package:crm_milan_creations/Lead%20Management/All%20Lead%20list/allLeadsModel.dart';
import 'package:crm_milan_creations/Lead%20Management/Assign%20Lead%20to%20Employees/assignLeadController.dart';
import 'package:crm_milan_creations/Lead%20Management/Get%20All%20Companies%20list/getAllCompaniesController.dart';
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

  final AssignLeadController assignLeadController =Get.put(AssignLeadController());
  String? selectedCompany;
  Resultemp? assignEmployee;
  String? employeeID;

  @override
  void initState() {
    super.initState();
    allLeadListcontroller.allLeadListFunction();
    getallemployeelistcontroller.getAllEmployeeListFunction();
    getallCompanieslistcontroller.getAllCompaniesListFunction();
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
      body: Obx(() {
        if(allLeadListcontroller.isLoading.value){
          return const Center(
                child: CircularProgressIndicator(color: CRMColors.black),
              );
        } if(allLeadListcontroller.leadList.isEmpty){
           return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    
                    CustomText(
                      text: "No Leave Records Found",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: CRMColors.black,
                    ),
                  ],
                ),
              );
        }
        
         
        return  ListView.builder(
  padding: const EdgeInsets.all(12),
  itemCount: allLeadListcontroller.leadList.length,
  itemBuilder: (context, index) {
    final lead = allLeadListcontroller.leadList[index];
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
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: convertUtcToIst(lead.createdAt ?? '')),
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
                          style: TextStyle(fontWeight: FontWeight.bold),
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
                    style: TextStyle(fontWeight: FontWeight.bold),
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
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: lead.leadCreator.name),
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
                          style: TextStyle(fontWeight: FontWeight.bold),
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
                          style: TextStyle(fontWeight: FontWeight.bold),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Purpose:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  lead.remark ?? 'No purpose provided',
                  style: TextStyle(color: Colors.grey[700]),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Assign button
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => showAssignLeadDialog(lead.id.toString()),
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
                  'Assign',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  },
);
      }
      ),
    );
  }

void showAssignLeadDialog(String leadid) {
  showDialog(
    context: context,
    builder: (_) => Dialog(
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
                          child: DropdownButton2<Resultemp?>(
                            isExpanded: true,
                            hint: Text(
                              'Select Employee',
                              style: TextStyle(color: Colors.grey),
                            ),
                            items: getallemployeelistcontroller.employeeList
                                .map<DropdownMenuItem<Resultemp?>>(
                                  (employee) => DropdownMenuItem<Resultemp?>(
                                    value: employee,
                                    child: Text(employee.name ?? ''),
                                  ),
                                ).toList(),
                            value: assignEmployee,
                                onChanged: (Resultemp? value) {
                                setState(() {
                                  assignEmployee = value;
                                  employeeID = assignEmployee!.id.toString();
                                });},
                            buttonStyleData: ButtonStyleData(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              height: 50,
                            ),
                            dropdownStyleData: DropdownStyleData(maxHeight: 200),
                          ),
                        );
                }),
                const SizedBox(height: 12),

                // Company Dropdown
                Obx(() {
                  return CustomDropdownButton2(
                    hint: CustomText(text: 'Select Company'),
                    value: selectedCompany,
                    dropdownItems: getallCompanieslistcontroller.companiesList.toList(),
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
                          padding: const EdgeInsets.symmetric(vertical: 14),
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
                          assignLeadController.assignLeadFunction(leadid,selectedCompany!,employeeID!);
                          print("Assigning to: $assignEmployee, Company: $selectedCompany");
                          setState((){
                              assignEmployee = null;
                              selectedCompany = null;
                          });
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
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
    DateTime istTime = utcTime.toUtc().add(const Duration(hours: 5, minutes: 30));
    return DateFormat('dd-MM-yyyy').format(istTime);
  } catch (e) {
    return '-';
  }
}

}
