// ignore_for_file: deprecated_member_use, unused_local_variable, unrelated_type_equality_checks

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crm_milan_creations/Auth/noInternetScreen.dart';
import 'package:crm_milan_creations/HR%20App/Add%20Employee/addEmployeeScreen.dart';
import 'package:crm_milan_creations/HR%20App/Edit%20Employee%20Details/GetEmployeeDetailsScreen.dart';
import 'package:crm_milan_creations/utils/font-styles.dart';
import 'package:crm_milan_creations/widgets/connectivity_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/widgets/appBar.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'viewEmployeeDetailsController.dart';
import 'package:device_info_plus/device_info_plus.dart';

class ViewEmployeeDetailsScreen extends StatefulWidget {
  final String employeeId;

  const ViewEmployeeDetailsScreen({super.key, required this.employeeId});

  @override
  State<ViewEmployeeDetailsScreen> createState() =>
      _ViewEmployeeDetailsScreenState();
}

class _ViewEmployeeDetailsScreenState extends State<ViewEmployeeDetailsScreen> {
  late final ViewEmployeecontroller controller;
    NointernetScreen noInternetScreen = const NointernetScreen();
  final ConnectivityService _connectivityService = ConnectivityService();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  String userRole = "";
  // String profilePicPath = "";

  @override
  void initState() {
    super.initState();
    getUserData();
    controller = Get.put(ViewEmployeecontroller());
    controller.employeeDetailsFunction(widget.employeeId);
       _checkInitialConnection();
   _setupConnectivityListener();
  }

    @override
  void dispose() {
   _connectivitySubscription.cancel();
    super.dispose();
  }

      Future<void> _checkInitialConnection() async {
    if (!(await _connectivityService.isConnected())) {
      _connectivityService.showNoInternetScreen();
    }
  }

    void _setupConnectivityListener() {
    _connectivitySubscription = _connectivityService.listenToConnectivityChanges(
      onConnected: () {
        // Optional: You can automatically go back if connection is restored
        // Get.back();
      },
      onDisconnected: () {
        _connectivityService.showNoInternetScreen();
      },
    );
  }

  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getString("role_code") ?? "";
      // profilePicPath = prefs.getString('profile_pic') ?? "";
    });
  }

  Widget _getProfileImageWidget() {
    if (controller.profilePic.isEmpty) {
      return const CircleAvatar(
        radius: 50,
        backgroundColor: Colors.grey,
        child: Icon(Icons.person, size: 50, color: Colors.white),
      );
    }

    try {
      // Check if it's a file path
      final file = File(controller.profilePic.toString());
      if (file.existsSync()) {
        return CircleAvatar(radius: 50, backgroundImage: FileImage(file));
      }
      // Check if it's a network URL
      else if (controller.profilePic.startsWith('http')) {
        return CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(controller.profilePic.toString()),
        );
      }
      // Assume it's base64 if neither
      else {
        final imageBytes = base64Decode(controller.profilePic.toString());
        return CircleAvatar(
          radius: 50,
          backgroundImage: MemoryImage(imageBytes),
        );
      }
    } catch (e) {
      print('Error loading profile image: $e');
      return const CircleAvatar(
        radius: 50,
        backgroundColor: Colors.grey,
        child: Icon(Icons.person, size: 50, color: Colors.white),
      );
    }
  }

  Widget _buildProfileImage() {
    return GestureDetector(
      onTap: _showFullScreenImage,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: CRMColors.crmMainCOlor, width: 2),
        ),
        child: _getProfileImageWidget(),
      ),
    );
  }

  void _showFullScreenImage() {
    if (controller.profilePic.isEmpty) return;

    try {
      Widget imageWidget;

      // Check if it's a file path
      final file = File(controller.profilePic.toString());
      if (file.existsSync()) {
        imageWidget = Image.file(file);
      }
      // Check if it's a network URL
      else if (controller.profilePic.startsWith('http')) {
        imageWidget = Image.network(controller.profilePic.toString());
      }
      // Assume it's base64 if neither
      else {
        final imageBytes = base64Decode(controller.profilePic.toString());
        imageWidget = Image.memory(imageBytes);
      }

      Get.dialog(
        Dialog(
          child: InteractiveViewer(
            panEnabled: true,
            minScale: 0.5,
            maxScale: 3.0,
            child: imageWidget,
          ),
        ),
      );
    } catch (e) {
      print('Error showing full screen image: $e');
      Get.snackbar(
        "Error",
        "Could not display image",
        backgroundColor: CRMColors.error,
        colorText: CRMColors.textWhite,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F6),
      appBar: CustomAppBar(
        showBackArrow: true,
        leadingIcon: Icons.arrow_back_ios_new_sharp,
        gradient: const LinearGradient(
          colors: [Color(0xFFEC32B1), Color(0xFF0C46CC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        title: const CustomText(
          text: "Employee Details",
          color: CRMColors.whiteColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          userRole != "EMPLOYEE" && userRole != "COMPANY_ADMIN"
              ? TextButton(
                onPressed: () {
                  Get.to(AddemployeeScreen());
                },
                child: CustomText(
                  text: 'Edit Employee',
                  color: Colors.white,
                  fontSize: 16,
                  onTap: () {
                    Get.to(
                      EditEmployeeScreen(
                        editEmployeeDetails: widget.employeeId,
                      ),
                    );
                  },
                ),
              )
              : SizedBox(),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            children: [
              _buildProfileImage(),
              const SizedBox(height: 16),
              Text(
                controller.name.value,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                controller.designation.value,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              _infoBox(
                Icons.calendar_today,
                "Joined",
                formatDate(controller.joinDate.value),
              ),
              const SizedBox(height: 30),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Obx(
                  () => Row(
                    children: [
                      _tabButton(
                        "Contact Info",
                        controller.selectedTab.value == 0,
                        0,
                      ),
                      const SizedBox(width: 10),
                      _tabButton(
                        "Employment Details",
                        controller.selectedTab.value == 1,
                        1,
                      ),
                      const SizedBox(width: 10),
                      _tabButton(
                        "Bank Details",
                        controller.selectedTab.value == 2,
                        2,
                      ),
                      const SizedBox(width: 10),
                      _tabButton(
                        "Documents",
                        controller.selectedTab.value == 3,
                        3,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Obx(() {
                switch (controller.selectedTab.value) {
                  case 0:
                    return _sectionCard("Contact Information", [
                      _contactRow(Icons.email, "Email", controller.email.value),
                      _contactRow(Icons.phone, "Phone", controller.phone.value),
                      _contactRow(
                        Icons.phone_android,
                        "Emergency",
                        controller.emergencyContact.value,
                      ),
                    ]);
                  case 1:
                    return _sectionCard("Employment Details", [
                      _contactRow(
                        Icons.business,
                        "Department",
                        controller.department.value,
                      ),
                      _contactRow(
                        Icons.calendar_today,
                        "Join Date",
                        formatDate(controller.joinDate.value),
                      ),
                      _contactRow(
                        Icons.work,
                        "Designation",
                        controller.designation.value,
                      ),
                    ]);
                  case 2:
                    return _sectionCard("Bank Details", [
                       _contactRow(
                        Icons.confirmation_number,
                        "Account No",
                        controller.bankAccount.value,
                      ),
                      _contactRow(
                        Icons.account_balance,
                        "Bank Name",
                        controller.bankName.value,
                      ),
                       _contactRow(
                        Icons.confirmation_number,
                        "IFSC Code",
                        controller.ifscCode.value ,
                      ),
                     
                    ]);
                  case 3:
                    return Obx(
                      () => _sectionCard("Documents", [
                        // Show Aadhar card if available
                        if (controller.aadharCardPic.isNotEmpty)
                          _documentRow(
                            "Aadhar Card",
                            controller.aadharCardPic.value,
                          ),

                        // Show PAN card if available
                        if (controller.panCardPic.isNotEmpty)
                          _documentRow("PAN Card", controller.panCardPic.value),

                        // Show other documents
                        ...controller.documents
                            .where(
                              (doc) =>
                                  doc['document_type'] != 'adhaar_card' &&
                                  doc['document_type'] != 'aadhar_card' &&
                                  doc['document_type'] != 'pan_card',
                            )
                            .map(
                              (doc) => _documentRow(
                                doc['type']
                                        ?.replaceAll('_', ' ')
                                        .toUpperCase() ??
                                    'Document',
                                doc['url'] ?? '',
                              ),
                            ),
                      ]),
                    );
                  default:
                    return Container();
                }
              }),
            ],
          ),
        );
      }),
    );
  }

  // Add this new widget method for document rows
Widget _documentRow(String label, String imageUrl) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            if (imageUrl.isNotEmpty) ...[
              IconButton(
                icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
                onPressed: () => _showFullDocumentImage(imageUrl),
              ),
              IconButton(
                icon: const Icon(Icons.download, color: Colors.green),
                onPressed: () => _downloadDocument(imageUrl, label),
              ),
            ],
          ],
        ),
      ],
    ),
  );
}

Future<void> _downloadDocument(String url, String fileName) async {
  try {
    // Clean up the filename
    fileName = fileName.replaceAll(RegExp(r'[^\w\s-]'), '').trim();
    
    // Request permissions based on platform and Android version
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 28) {
        // Android 9 and below
        var status = await Permission.storage.request();
        if (!status.isGranted) {
          await openAppSettings();
          throw Exception('Storage permission not granted');
        }
      } else {
        // Android 10 and above
        if (!await Permission.manageExternalStorage.isGranted) {
          final status = await Permission.manageExternalStorage.request();
          if (!status.isGranted) {
            throw Exception('Manage external storage permission not granted');
          }
        }
      }
    } else if (Platform.isIOS) {
      // iOS permission handling if needed
    }

    // Get download directory
    Directory? directory;
    try {
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }
    } catch (e) {
      directory = await getApplicationDownloadsDirectory();
    }

    if (directory == null) {
      throw Exception('Could not access download directory');
    }

    // Ensure directory exists
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }

    // Get file extension
    final extension = _getFileExtension(url);
    final safeFileName = '$fileName${DateTime.now().millisecondsSinceEpoch}$extension';
    final savePath = '${directory.path}/$safeFileName';

    // Show download starting message
    Get.snackbar(
      "Downloading",
      "Starting download of $fileName",
      backgroundColor: Colors.blue,
      colorText: CRMColors.textWhite,
    );

    // Start download
    final taskId = await FlutterDownloader.enqueue(
      url: url,
      savedDir: directory.path,
      fileName: safeFileName,
      showNotification: true,
      openFileFromNotification: true,
    );

    if (taskId == null) {
      throw Exception('Failed to start download');
    }

    // Listen for download progress
    FlutterDownloader.registerCallback((id, status, progress) {
      if (id == taskId) {
        if (status == DownloadTaskStatus.running) {
          // You could update a progress indicator here
          print('Download progress: $progress%');
        } else if (status == DownloadTaskStatus.complete) {
          Get.snackbar(
            "Download Complete",
            "File saved to Downloads folder",
            backgroundColor: Colors.green,
            colorText: CRMColors.textWhite,
            duration: Duration(seconds: 3),
          );
        } else if (status == DownloadTaskStatus.failed) {
          Get.snackbar(
            "Download Failed",
            "Please try again",
            backgroundColor: CRMColors.error,
            colorText: CRMColors.textWhite,
          );
        }
      }
    });
  } catch (e) {
    print('Download error: $e');
    Get.snackbar(
      "Download Error",
      e.toString(),
      backgroundColor: CRMColors.error,
      colorText: CRMColors.textWhite,
    );
  }
}

  // Helper function to get downloads directory
Future<Directory?> getApplicationDownloadsDirectory() async {
  if (Platform.isAndroid) {
    return Directory('/storage/emulated/0/Download');
  } else if (Platform.isIOS) {
    return await getApplicationDocumentsDirectory();
  }
  return null;
}



// Improved file extension detection
String _getFileExtension(String url) {
  try {
    final uri = Uri.parse(url);
    final path = uri.path.toLowerCase();
    
    // Check common image extensions
    if (path.endsWith('.jpg') || path.endsWith('.jpeg')) return '.jpg';
    if (path.endsWith('.png')) return '.png';
    if (path.endsWith('.gif')) return '.gif';
    if (path.endsWith('.webp')) return '.webp';
    
    // Check document extensions
    if (path.endsWith('.pdf')) return '.pdf';
    if (path.endsWith('.doc')) return '.doc';
    if (path.endsWith('.docx')) return '.docx';
    if (path.endsWith('.xls')) return '.xls';
    if (path.endsWith('.xlsx')) return '.xlsx';
    if (path.endsWith('.ppt')) return '.ppt';
    if (path.endsWith('.pptx')) return '.pptx';
    if (path.endsWith('.txt')) return '.txt';
    
    // Check content type if available in URL parameters
    final contentType = uri.queryParameters['contentType']?.toLowerCase() ?? '';
    if (contentType.contains('jpeg') || contentType.contains('jpg')) return '.jpg';
    if (contentType.contains('png')) return '.png';
    if (contentType.contains('pdf')) return '.pdf';
    
    // Default to .jpg if we can't determine (common for images served without extension)
    return '.jpg';
  } catch (e) {
    return '.jpg';
  }
}

  Widget _getDocumentImageWidget(String imageUrl, {bool isFullScreen = false}) {
    try {
      if (imageUrl.startsWith('http')) {
        return Image.network(
          imageUrl,
          fit: isFullScreen ? BoxFit.contain : BoxFit.cover,
          width: isFullScreen ? null : double.infinity,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value:
                    loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                        color: CRMColors.white,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return _buildErrorWidget(isFullScreen);
          },
        );
      } else if (File(imageUrl).existsSync()) {
        return Image.file(
          File(imageUrl),
          fit: isFullScreen ? BoxFit.contain : BoxFit.cover,
          width: isFullScreen ? null : double.infinity,
        );
      } else {
        try {
          final imageBytes = base64Decode(imageUrl);
          return Image.memory(
            imageBytes,
            fit: isFullScreen ? BoxFit.contain : BoxFit.cover,
            width: isFullScreen ? null : double.infinity,
          );
        } catch (e) {
          return _buildErrorWidget(isFullScreen);
        }
      }
    } catch (e) {
      return _buildErrorWidget(isFullScreen);
    }
  }

  Widget _buildErrorWidget(bool isFullScreen) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 40),
          const SizedBox(height: 10),
          Text(
            'Failed to load document',
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: isFullScreen ? 18 : 14,
            ),
          ),
        ],
      ),
    );
  }

void _showFullDocumentImage(String imageUrl) {
  if (imageUrl.isEmpty) return;

  Get.dialog(
    Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(10),
      child: Stack(
        children: [
          Center(
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 3.0,
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                ),
                child: _getDocumentImageWidget(imageUrl, isFullScreen: true),
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Row(
              children: [
                 FloatingActionButton(
                mini: true,
                backgroundColor: Colors.green,
                child: const Icon(Icons.download, color: Colors.white),
                onPressed: () {
                  Get.back();
                  _downloadDocument(imageUrl, 'document_${DateTime.now().millisecondsSinceEpoch}');
                },
              ),
              const SizedBox(width: 10),
              FloatingActionButton(
                mini: true,
                backgroundColor: Colors.red,
                child: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Get.back(),
              ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
 
  Widget _infoBox(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: CRMColors.crmMainCOlor, size: 20),
          const SizedBox(width: 8),
          Text(
            "$label: ",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _tabButton(String label, bool selected, int index) {
    return GestureDetector(
      onTap: () => controller.selectedTab.value = index,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? CRMColors.crmMainCOlor : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: CRMColors.crmMainCOlor.withOpacity(0.2)),
          boxShadow:
              selected
                  ? [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.3),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ]
                  : [],
        ),
        child: Row(
          children: [
            Icon(
              label.contains("Contact")
                  ? Icons.person
                  : label.contains("Employment")
                  ? Icons.work
                  : label.contains("Bank")
                  ? Icons.account_balance
                  : Icons.insert_drive_file,
              size: 18,
              color: selected ? Colors.white : CRMColors.crmMainCOlor,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: selected ? Colors.white : CRMColors.crmMainCOlor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: CRMColors.crmMainCOlor),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _contactRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 22, color: CRMColors.crmMainCOlor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String formatDate(String apiDate) {
    try {
      DateTime parsedDate = DateTime.parse(apiDate).toLocal();
      return DateFormat('dd MMM yyyy').format(parsedDate);
    } catch (e) {
      return apiDate;
    }
  }
}
