import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/utils/font-styles.dart';
import 'package:crm_milan_creations/widgets/appBar.dart';
import 'package:crm_milan_creations/widgets/dropdown.dart';
import 'package:crm_milan_creations/widgets/textfiled.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CreateLeadsScreen extends StatefulWidget {
  const CreateLeadsScreen({super.key});

  @override
  State<CreateLeadsScreen> createState() => _CreateLeadsScreenState();
}

class _CreateLeadsScreenState extends State<CreateLeadsScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController branchNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController purposeController = TextEditingController();
  TextEditingController queryTypeController = TextEditingController();

  String? selectedSource;
  final List<String> sourceItems = ['WalkIn', 'Website', 'Referral', 'Advertisement','Social Media','Other'];

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      final now = DateTime.now();
      final selectedTime = DateTime(
        now.year,
        now.month,
        now.day,
        picked.hour,
        picked.minute,
      );
      setState(() {
        timeController.text = DateFormat('hh:mm a').format(selectedTime);
      });
    }
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
          text: 'Create Leads',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: CRMColors.whiteColor,
        ),
        backgroundColor: CRMColors.crmMainCOlor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTextFormField(
                label: 'Name',
                controller: nameController,
                backgroundColor: CRMColors.whiteColor,
              ),
              const SizedBox(height: 12),

              GestureDetector(
                onTap: _selectDate,
                child: AbsorbPointer(
                  child: CustomTextFormField(
                    backgroundColor: CRMColors.whiteColor,
                    label: 'Select Date',
                    controller: dateController,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              GestureDetector(
                onTap: _selectTime,
                child: AbsorbPointer(
                  child: CustomTextFormField(
                    backgroundColor: CRMColors.whiteColor,
                    label: 'Select Time',
                    controller: timeController,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              CustomTextFormField(
                label: 'Email',
                controller: emailController,
                backgroundColor: CRMColors.whiteColor,
              ),
              const SizedBox(height: 12),

              CustomTextFormField(
                label: 'Phone',
                controller: phoneController,
                keyboardType: TextInputType.phone,
                backgroundColor: CRMColors.whiteColor,
              ),
              const SizedBox(height: 12),

              CustomTextFormField(
                label: 'Branch Name',
                controller: branchNameController,
                backgroundColor: CRMColors.whiteColor,
              ),
              const SizedBox(height: 12),

              CustomDropdownButton2(
                hint: CustomText(text: 'Select Source'),
                value: selectedSource,
                dropdownItems: sourceItems,
                onChanged: (value) {
                  setState(() {
                    selectedSource = value;
                  });
                },
              ),
              const SizedBox(height: 12),

              CustomTextFormField(
                label: 'Address',
                controller: addressController,
                backgroundColor: CRMColors.whiteColor,
              ),


              const SizedBox(height: 12),

              CustomTextFormField(
                label: 'Purpose',
                controller: purposeController,
                backgroundColor: CRMColors.whiteColor,
              ),


              const SizedBox(height: 12),

              CustomTextFormField(
                label: 'Enter Query Type',
                controller: queryTypeController,
                backgroundColor: CRMColors.whiteColor,
              ),

               const SizedBox(height: 12),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(text: 'Assign Info',fontWeight: FontWeight.bold,fontSize: 20,),
                ],
              ),

              const SizedBox(height: 12),
              CustomDropdownButton2(
                hint: CustomText(text: 'Select Company'),
                value: selectedSource,
                dropdownItems: sourceItems,
                onChanged: (value) {
                  setState(() {
                    selectedSource = value;
                  });
                },
              ),


              const SizedBox(height: 12),
              CustomDropdownButton2(
                hint: CustomText(text: 'Asign To'),
                value: selectedSource,
                dropdownItems: sourceItems,
                onChanged: (value) {
                  setState(() {
                    selectedSource = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
