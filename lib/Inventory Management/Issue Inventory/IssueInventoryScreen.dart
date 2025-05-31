import 'dart:io';

import 'package:crm_milan_creations/widgets/button.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:crm_milan_creations/Employee/Get%20All%20Employees%20List/getAllEmployeeeListController.dart';
import 'package:crm_milan_creations/Employee/Get%20All%20Employees%20List/getAllEmployeeeListModel.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/utils/font-styles.dart';
import 'package:crm_milan_creations/widgets/appBar.dart';
import 'package:crm_milan_creations/widgets/textfiled.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class Accessory {
  TextEditingController nameController = TextEditingController();
  TextEditingController serialNumberController = TextEditingController();
}

class InventoryItem {
  String? type;
  TextEditingController modelNameController = TextEditingController();
  TextEditingController serialNumberController = TextEditingController();
  TextEditingController ssdController = TextEditingController();
  TextEditingController ramController = TextEditingController();
  TextEditingController processorController = TextEditingController();
  List<Accessory> accessories = [];
}

class IssueInventoryScreen extends StatefulWidget {
  const IssueInventoryScreen({super.key});

  @override
  State<IssueInventoryScreen> createState() => _IssueInventoryScreenState();
}

class _IssueInventoryScreenState extends State<IssueInventoryScreen> {
  final TextEditingController dateTimeController = TextEditingController();
  final TextEditingController issuedByController = TextEditingController();
  final Getallemployeelistcontroller getallemployeelistcontroller = Get.put(
    Getallemployeelistcontroller(),
  );
  final TextEditingController modelNameController = TextEditingController();
  final TextEditingController serialNumberController = TextEditingController();
  final TextEditingController ssdController = TextEditingController();
  final TextEditingController ramController = TextEditingController();
  final TextEditingController processorController = TextEditingController();
  // List to store accessories
  List<String> accessories = [];
  File? _selectedImage;
  bool showItemForm = false;
  String? selectedType;

  // List to store inventory items
  List<InventoryItem> inventoryItems = [];

  @override
  void initState() {
    super.initState();
    getallemployeelistcontroller.getAllEmployeeListFunction();
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
          text: 'Inventory Management',
          color: CRMColors.whiteColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: CRMColors.crmMainCOlor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(text: 'Select Date',color: CRMColors.darkGrey,fontSize: 15),
            GestureDetector(
              onTap: _selectDateTime,
              child: AbsorbPointer(
                child: CustomTextFormField(
                  borderColor: CRMColors.grey,
                  showLabel: false,
                  backgroundColor: CRMColors.whiteColor,
                  label: 'Date',
                  controller: dateTimeController,
                ),
              ),
            ),
            const SizedBox(height: 12),
CustomText(text: 'Select Employee',color: CRMColors.darkGrey,fontSize: 15),
            /// Employee Dropdown
            Obx(() {
              if (getallemployeelistcontroller.isLoading.value) {
                return Column(
                  children: List.generate(1, (index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      height: 55,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: CRMColors.grey),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        child: Row(
                          children: [
                            FadeShimmer(
                              height: 15,
                              width: 150,
                              radius: 4,
                              millisecondsDelay: 300,
                              fadeTheme: FadeTheme.light,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                );
              }

              if (getallemployeelistcontroller.employeeList.isEmpty) {
                return const Center(
                  child: CustomText(text: 'No employee found'),
                );
              }

              return Container(
                height: 55,
                padding: const EdgeInsets.symmetric(horizontal: 0),
                decoration: BoxDecoration(
                  color: CRMColors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: CRMColors.grey),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<Resultemp>(
                    isExpanded: true,
                    hint: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(left: 0.0),
                          child: Text(
                            'Employee',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),

                    items:
                        getallemployeelistcontroller.employeeList
                            .map<DropdownMenuItem<Resultemp>>((Resultemp emp) {
                              return DropdownMenuItem<Resultemp>(
                                value: emp,
                                child: Text(
                                  emp.name,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              );
                            })
                            .toList(),
                    value: getallemployeelistcontroller.selectedEmployee.value,
                    onChanged: (Resultemp? newValue) {
                      if (newValue != null) {
                        getallemployeelistcontroller.selectedEmployee.value =
                            newValue;
                      }
                    },
                    buttonStyleData: const ButtonStyleData(height: 50),
                    dropdownStyleData: const DropdownStyleData(maxHeight: 200),
                  ),
                ),
              );
            }),

            const SizedBox(height: 12),
          CustomText(text: 'Issued By',color: CRMColors.darkGrey,fontSize: 15),
            /// Issued By
            CustomTextFormField(
              borderColor: CRMColors.grey,
              showLabel: false,
              backgroundColor: CRMColors.whiteColor,
              label: 'Enter Name',
              controller: issuedByController,
            ),
            const SizedBox(height: 12),

            /// Image Picker
            GestureDetector(
              onTap: pickImageFromGallery,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: CRMColors.whiteColor,
                  border: Border.all(color: CRMColors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child:
                    _selectedImage != null
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            _selectedImage!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        )
                        : const Center(
                          child: Text(
                            'Tap to select image',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
              ),
            ),
            const SizedBox(height: 20),

            // Add item button
            CustomButton(
              gradient: const LinearGradient(
                colors: [Color(0xFFEC32B1), Color(0xFF0C46CC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              text: 'Add Item',
              onPressed: () {
                setState(() {
                  inventoryItems.add(InventoryItem());
                });
              },
            ),
            const SizedBox(height: 20),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: inventoryItems.length,
              itemBuilder: (context, index) {
                return _buildItemForm(index);
              },
            ),

            if (inventoryItems.isNotEmpty)
              CustomButton(
                gradient: const LinearGradient(
                  colors: [Color(0xFFEC32B1), Color(0xFF0C46CC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                onPressed: _submitInventory,
                text: 'Submit Inventory',
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDateTime() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      String formattedDate =
          "${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.year}";
      setState(() {
        dateTimeController.text = formattedDate;
      });
    }
  }

  Future<void> pickImageFromGallery() async {
    final pickFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickFile != null) {
      setState(() {
        _selectedImage = File(pickFile.path);
      });
    }
  }

  Widget _buildItemForm(int index) {
    final item = inventoryItems[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Item ${index + 1}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: CRMColors.black1),
                onPressed: () {
                  setState(() {
                    inventoryItems.removeAt(index);
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Fields
          _dropdownField('Type *', item.type, (val) {
            setState(() => item.type = val);
          }),
          const SizedBox(height: 16),

          _textField('Model/Name *', item.modelNameController),
          const SizedBox(height: 16),

          _textField('Serial Number *', item.serialNumberController),
          const SizedBox(height: 16),

          _textField('SSD', item.ssdController),
          const SizedBox(height: 16),

          _textField('RAM', item.ramController),
          const SizedBox(height: 16),

          _textField('Processor', item.processorController),
          const SizedBox(height: 24),

          // Accessories
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Accessories',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle, color: Colors.blue),
                onPressed: () {
                  setState(() {
                    item.accessories.add(Accessory());
                  });
                },
              ),
            ],
          ),

          ...item.accessories.asMap().entries.map((entry) {
            int accIndex = entry.key;
            Accessory accessory = entry.value;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  _textField('Accessory Name', accessory.nameController),
                  const SizedBox(height: 8),
                  _textField(
                    'Accessory Serial Number',
                    accessory.serialNumberController,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        setState(() {
                          item.accessories.removeAt(accIndex);
                        });
                      },
                      icon: const Icon(
                        Icons.delete_forever,
                        color: CRMColors.black1,
                      ),
                    ),
                  ),
                  const Divider(),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _dropdownField(
    String hint,
    String? value,
    Function(String?) onChanged,
  ) {
    final List<String> types = ['Laptop', 'Desktop', 'Monitor', 'Other'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: CRMColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: CRMColors.grey),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          hint: Text(hint),
          items:
              types.map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _textField(String label, TextEditingController controller) {
    return CustomTextFormField(
      label: label,
      controller: controller,
      showLabel: false,
      backgroundColor: CRMColors.whiteColor,
      borderColor: CRMColors.grey,
    );
  }

  void _submitInventory() {
    debugPrint("Submitting inventory:");
    for (var item in inventoryItems) {
      debugPrint("Type: ${item.type}");
      debugPrint("Model: ${item.modelNameController.text}");
      debugPrint("Serial: ${item.serialNumberController.text}");
      debugPrint("Accessories: ${item.accessories.length}");
    }

    Get.snackbar("Success", "Inventory submitted!");
  }
}
