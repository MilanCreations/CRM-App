import 'dart:io';

import 'package:crm_milan_creations/Admin/Create%20Company/Get%20All%20Cities/getCitiesController.dart';
import 'package:crm_milan_creations/Admin/Create%20Company/State/stateController.dart';
import 'package:crm_milan_creations/Admin/Create%20Company/company%20type/companyTypeController.dart';
import 'package:crm_milan_creations/Admin/Create%20Company/country/getCountriesController.dart';
import 'package:crm_milan_creations/Admin/Create%20Company/create%20company/createCompanyController.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/utils/font-styles.dart';
import 'package:crm_milan_creations/widgets/appBar.dart';
import 'package:crm_milan_creations/widgets/button.dart';
import 'package:crm_milan_creations/widgets/dropdown.dart';
import 'package:crm_milan_creations/widgets/textfiled.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateCompanyScreen extends StatefulWidget {
  const CreateCompanyScreen({super.key});

  @override
  State<CreateCompanyScreen> createState() => _CreateCompanyScreenState();
}

class _CreateCompanyScreenState extends State<CreateCompanyScreen> {
  TextEditingController companyNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController branchNameController = TextEditingController();
  TextEditingController gstController = TextEditingController();
  TextEditingController companyAdminNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  RxList<String> country = <String>['India', 'Canada', 'America'].obs;
  RxList<String> state = <String>['Punjab', '', ''].obs;
  RxList<String> city = <String>['Ludhiana', '', ''].obs;
  // Upload file from gallery vaiables
  File? selectedFile;
  String? selectedFileName;

  // C0ntrollers
  CompanyTypesController companyTypesController = Get.put(
    CompanyTypesController(),
  );

  GetAllCountriesController getAllCountriesController = Get.put(
    GetAllCountriesController(),
  );

  GetAllStatesController getAllStatesController = Get.put(
    GetAllStatesController(),
  );

  final GetAllCitiesListController getAllCitiesListController = Get.put(
    GetAllCitiesListController(),
  );

  final CreateCompanyController createCompanyController = Get.put(
    CreateCompanyController(),
  );

  String? selectedCompany;
  String? selectedCountry;
  String? selectedState;
  String? selectedCity;
  bool isStateEnabled = false;
  bool isCityEnabled = false;
  bool isCountryEnabled = false;

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'png',
        'jpg',
        'jpeg',
        'gif',
      ], // ✅ Only allowed formats
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      String path = result.files.single.path!;
      String extension = path.split('.').last.toLowerCase();

      if (['png', 'jpg', 'jpeg', 'gif'].contains(extension)) {
        setState(() {
          selectedFile = File(path);
          selectedFileName = result.files.single.name;
        });
      } else {
        Get.snackbar(
          "Invalid File",
          "Only .png, .jpg, .jpeg, or .gif files are allowed.",
          backgroundColor: CRMColors.error,
          colorText: CRMColors.textWhite,
        );
      }
    } else {
      // ❌ User canceled picker
      print("⚠️ File picking cancelled.");
    }
  }

  @override
  void initState() {
    companyTypesController.getCompanyTypesfunctions();
    getAllCountriesController.allCountriesfunctions();
    // getAllStatesController.getStatesByCountryId();
    // getAllCitiesListController.allCitiesListfunctions();
    super.initState();
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
          text: 'Register Company',
          color: CRMColors.whiteColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: CRMColors.crmMainCOlor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              CustomText(text: 'Company Name'),
              CustomTextFormField(
                label: 'Enter Company Name....',
                controller: companyNameController,
                backgroundColor: CRMColors.textWhite,
                borderColor: CRMColors.textWhite,
                showLabel: false,
              ),

              ///////////////////////////////////////////// Company Type /////////////////////////////////////////////
              SizedBox(height: 20),

              Obx(() {
                if (companyTypesController.isLoading.value) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(text: 'Company Type'),
                      // SizedBox(height: 8),
                      Container(
                        height: 55,
                        decoration: BoxDecoration(
                          color: CRMColors.dashboardClockInContainer,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: CRMColors.textWhite),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FadeShimmer(
                              height: 16,
                              width: double.infinity,
                              radius: 8,
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }

                // Dropdown when data is loaded
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(text: 'Company Type'),
                    // SizedBox(height: 8),
                    CustomDropdownButton2(
                      hint: CustomText(text: 'Select'),
                      value: selectedCompany,
                      dropdownItems:
                          companyTypesController.companyTypesList
                              .map<String>((type) => type.name)
                              .toList(),
                      borderColor: CRMColors.textWhite,
                      onChanged: (value) {
                        setState(() {
                          selectedCompany = value;
                        });
                        print('Selected company: $selectedCompany');
                      },
                    ),
                  ],
                );
              }),

              ///////////////////////////////////////////// Country /////////////////////////////////////////////
              SizedBox(height: 20),
              Obx(() {
                if (companyTypesController.isLoading.value) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(text: 'Country'),
                      Container(
                        height: 55,
                        decoration: BoxDecoration(
                          color: CRMColors.dashboardClockInContainer,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: CRMColors.textWhite),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FadeShimmer(
                              height: 16,
                              width: double.infinity,
                              radius: 8,
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }

                // 🔍 Dropdown With Search (handled inside the custom widget)
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(text: 'Country'),
                    CustomDropdownButton2(
                      enableSearch: true,
                      hint: CustomText(text: 'Select Country'),
                      value: selectedCountry,
                      dropdownItems:
                          getAllCountriesController.getAllCountriesList
                              .map<String>((type) => type.name)
                              .toList(),
                      borderColor: CRMColors.textWhite,
                      onChanged: (value) {
                        setState(() {
                          selectedCountry = value;
                          selectedState = null;
                          selectedCity = null;
                          isStateEnabled = true;
                          isCityEnabled = false;
                        });

                        final selectedCountryModel = getAllCountriesController
                            .getAllCountriesList
                            .firstWhere((e) => e.name == value);

                        getAllStatesController.getStatesByCountryId(
                          selectedCountryModel.id.toString(),
                        );
                      },
                    ),
                  ],
                );
              }),

              ///////////////////////////////////////////// State /////////////////////////////////////////////
              SizedBox(height: 20),
              Obx(() {
                if (getAllStatesController.isLoading.value) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(text: 'State'),
                      // SizedBox(height: 8),
                      Container(
                        height: 55,
                        decoration: BoxDecoration(
                          color: CRMColors.dashboardClockInContainer,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: CRMColors.textWhite),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FadeShimmer(
                              height: 16,
                              width: double.infinity,
                              radius: 8,
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }

                // Dropdown when data is loaded
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(text: 'State'),
                    // SizedBox(height: 8),
                    CustomDropdownButton2(
                      enableSearch: true,
                      hint: CustomText(text: 'Select state'),
                      value: selectedState,
                      borderColor: CRMColors.textWhite,

                      dropdownItems:
                          getAllStatesController.getAllStatesList
                              .map<String>((state) => state.name)
                              .toList(),

                      onChanged:
                          isStateEnabled
                              ? (value) {
                                setState(() {
                                  selectedState = value;
                                  selectedCity = null;
                                  isCityEnabled = true;
                                });

                                final selectedStateModel =
                                    getAllStatesController.getAllStatesList
                                        .firstWhere((e) => e.name == value);

                                getAllCitiesListController
                                    .allCitiesListfunctions(
                                      selectedStateModel.id.toString(),
                                    );
                              }
                              : null,
                    ),
                  ],
                );
              }),

              ///////////////////////////////////////////// City /////////////////////////////////////////////
              SizedBox(height: 20),
              Obx(() {
                if (getAllStatesController.isLoading.value) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(text: 'City'),
                      // SizedBox(height: 8),
                      Container(
                        height: 55,
                        decoration: BoxDecoration(
                          color: CRMColors.dashboardClockInContainer,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: CRMColors.textWhite),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FadeShimmer(
                              height: 16,
                              width: double.infinity,
                              radius: 8,
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }

                // Dropdown when data is loaded
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(text: 'City'),
                    // SizedBox(height: 8),
                    CustomDropdownButton2(
                      borderColor: CRMColors.textWhite,
                      hint: CustomText(text: 'Select City'),
                      enableSearch: true,
                      value: selectedCity,
                      dropdownItems:
                          getAllCitiesListController.getCitiesListList
                              .map<String>((city) => city.name)
                              .toList(),
                      onChanged:
                          isCityEnabled
                              ? (value) {
                                setState(() {
                                  selectedCity = value;
                                });
                              }
                              : null,
                    ),
                  ],
                );
              }),

              ///////////////////////////////////////////// Address /////////////////////////////////////////////
              SizedBox(height: 20),
              CustomText(text: 'Address'),
              CustomTextFormField(
                label: 'Enter Address',
                controller: addressController,
                backgroundColor: CRMColors.textWhite,
                borderColor: CRMColors.textWhite,
                showLabel: false,
                prefixIcon: Icon(Icons.location_on),
              ),
              ///////////////////////////////////////////// Branch Name /////////////////////////////////////////////
              SizedBox(height: 20),
              CustomText(text: 'Branch Name'),
              CustomTextFormField(
                label: 'Enter Branch Name',
                controller: branchNameController,
                backgroundColor: CRMColors.textWhite,
                borderColor: CRMColors.textWhite,
                showLabel: false,
                prefixIcon: Icon(Icons.location_on),
              ),
              ///////////////////////////////////////////// Upload File /////////////////////////////////////////////
              SizedBox(height: 20),
              CustomText(text: 'Upload Image'),
              // SizedBox(height: 8),
              selectedFile == null
                  ? InkWell(
                    onTap: pickFile,
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: CRMColors.textWhite,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: CRMColors.textWhite),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_outlined,
                              size: 40,
                              color: CRMColors.textMainCOlor,
                            ),
                            SizedBox(height: 10),
                            CustomText(
                              text: 'Tap to select an image',
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  : Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          selectedFile!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedFile = null;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(5),
                            child: Icon(
                              Icons.close,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

              ///////////////////////////////////////////// Admin Details /////////////////////////////////////////////
              SizedBox(height: 20),
              CustomText(text: 'Company Admin Name'),
              CustomTextFormField(
                label: 'Company Admin Name',
                controller: companyAdminNameController,
                backgroundColor: CRMColors.textWhite,
                borderColor: CRMColors.textWhite,
                showLabel: false,
                prefixIcon: Icon(Icons.person_2_outlined),
              ),
              ///////////////////////////////////////////// Email /////////////////////////////////////////////
              SizedBox(height: 20),
              CustomText(text: 'Email'),
              CustomTextFormField(
                label: 'Enter email',
                controller: emailController,
                backgroundColor: CRMColors.textWhite,
                borderColor: CRMColors.textWhite,
                showLabel: false,
                prefixIcon: Icon(Icons.email_outlined),
              ),
              ///////////////////////////////////////////// Submit Button /////////////////////////////////////////////
              SizedBox(height: 20),
              Obx(() {
                return createCompanyController.isLoading.value
                    ? Center(
                      child: CircularProgressIndicator(
                        color: CRMColors.crmMainCOlor,
                      ),
                    )
                    : CustomButton(
                      text: 'Submit',
                      onPressed: () async {
                        // FIELD VALIDATIONS
                        if (companyNameController.text.trim().isEmpty) {
                          Get.snackbar(
                            "Validation Error",
                            "Company Name is required",
                            backgroundColor: CRMColors.error,
                            colorText: CRMColors.textWhite,
                          );
                          return;
                        }

                        if (selectedCompany == null) {
                          Get.snackbar(
                            "Validation Error",
                            "Please select a Company Type",
                            backgroundColor: CRMColors.error,
                            colorText: CRMColors.textWhite,
                          );
                          return;
                        }

                        if (selectedCountry == null) {
                          Get.snackbar(
                            "Validation Error",
                            "Please select a Country",
                            backgroundColor: CRMColors.error,
                            colorText: CRMColors.textWhite,
                          );
                          return;
                        }

                        if (selectedState == null) {
                          Get.snackbar(
                            "Validation Error",
                            "Please select a State",
                            backgroundColor: CRMColors.error,
                            colorText: CRMColors.textWhite,
                          );
                          return;
                        }

                        if (selectedCity == null) {
                          Get.snackbar(
                            "Validation Error",
                            "Please select a City",
                            backgroundColor: CRMColors.error,
                            colorText: CRMColors.textWhite,
                          );
                          return;
                        }

                        if (addressController.text.trim().isEmpty) {
                          Get.snackbar(
                            "Validation Error",
                            "Address is required",
                            backgroundColor: CRMColors.error,
                            colorText: CRMColors.textWhite,
                          );
                          return;
                        }

                        if (branchNameController.text.trim().isEmpty) {
                          Get.snackbar(
                            "Validation Error",
                            "Branch Name is required",
                            backgroundColor: CRMColors.error,
                            colorText: CRMColors.textWhite,
                          );
                          return;
                        }

                        if (companyAdminNameController.text.trim().isEmpty) {
                          Get.snackbar(
                            "Validation Error",
                            "Company Admin Name is required",
                            backgroundColor: CRMColors.error,
                            colorText: CRMColors.textWhite,
                          );
                          return;
                        }

                        if (emailController.text.trim().isEmpty) {
                          Get.snackbar(
                            "Validation Error",
                            "Email is required",
                            backgroundColor: CRMColors.error,
                            colorText: CRMColors.textWhite,
                          );
                          return;
                        }

                        // ✅ GET SELECTED MODELS
                        final selectedCompanyModel = companyTypesController
                            .companyTypesList
                            .firstWhere((e) => e.name == selectedCompany);
                        final selectedCountryModel = getAllCountriesController
                            .getAllCountriesList
                            .firstWhere((e) => e.name == selectedCountry);
                        final selectedStateModel = getAllStatesController
                            .getAllStatesList
                            .firstWhere((e) => e.name == selectedState);
                        final selectedCityModel = getAllCitiesListController
                            .getCitiesListList
                            .firstWhere((e) => e.name == selectedCity);

                        // ✅ CALL API
                        bool isSuccess = await createCompanyController
                            .createCompany(
                              companyName: companyNameController.text,
                              companyTypeId: selectedCompanyModel.id.toString(),
                              countryId: selectedCountryModel.id.toString(),
                              stateId: selectedStateModel.id.toString(),
                              cityId: selectedCityModel.id.toString(),
                              address: addressController.text,
                              adminName: companyAdminNameController.text,
                              adminEmail: emailController.text,
                              gstId: gstController.text,
                              branchName: branchNameController.text,
                              companyLogo: selectedFile,
                            );

                        if (isSuccess) {
                          clearFields();
                        }
                      },

                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 1.2,
                      ),
                      borderRadius: 16.0,
                      height: 50,
                      width: double.infinity,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFEC32B1), Color(0xFF0C46CC)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    );
              }),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void clearFields() {
    setState(() {
      companyNameController.clear();
      addressController.clear();
      branchNameController.clear();
      gstController.clear();
      companyAdminNameController.clear();
      emailController.clear();
      selectedCompany = null;
      selectedCountry = null;
      selectedState = null;
      selectedCity = null;

      isStateEnabled = false;
      isCityEnabled = false;
      selectedFile = null;
      selectedFileName = null;
    });

    print('🔄 Fields cleared');
  }
}
