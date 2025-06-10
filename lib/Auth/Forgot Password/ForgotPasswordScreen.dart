import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crm_milan_creations/Auth/Login/loginScreen.dart';
import 'package:crm_milan_creations/Auth/noInternetScreen.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/widgets/button.dart';
import 'package:crm_milan_creations/widgets/connectivity_service.dart';
import 'package:crm_milan_creations/widgets/textfiled.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();
    NointernetScreen noInternetScreen = const NointernetScreen();
  final ConnectivityService _connectivityService = ConnectivityService();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

      @override
  void initState() {
    super.initState();

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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFEC32B1), Color(0xFF0C46CC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 36.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header Icon
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFFEC32B1), Color(0xFF0C46CC)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Icon(
                          Icons.lock_outline,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Title
                      const Text(
                        "Forgot Password?",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: CRMColors.black,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Subtitle
                      Text(
                        "Enter your email below to receive a reset link.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Email Input
                      CustomTextFormField(
                        label: 'Enter email',
                        showLabel: false,
                        controller: emailController,
                        prefixIcon: const Icon(Icons.email),
                        borderColor: Colors.transparent,
                        width: double.infinity,
                        backgroundColor: CRMColors.lightgrey,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          final emailRegex = RegExp(
                              r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
                          if (!emailRegex.hasMatch(value)) {
                            return 'Enter a valid email address';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 30),

                      // Reset Button
                      CustomButton(
                        text: 'Reset Password',
                        onPressed: () {
                          String email = emailController.text;

                          if (email.isEmpty) {
                            Get.snackbar(
                              "Message",
                              "Please enter your email",
                              backgroundColor: CRMColors.error,
                              colorText: CRMColors.whiteColor,
                            );
                          } else {
                            final emailRegex = RegExp(
                                r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
                            if (!emailRegex.hasMatch(email)) {
                              Get.snackbar(
                                "Invalid Email",
                                "Please enter a valid email address",
                                backgroundColor: CRMColors.error,
                                colorText: CRMColors.whiteColor,
                              );
                            } else {
                              // API call placeholder
                              Get.snackbar(
                                "Success",
                                "Password reset link sent to your email.",
                                backgroundColor: CRMColors.success,
                                colorText: CRMColors.whiteColor,
                              );
                              Get.off(() => const LoginScreen());
                            }
                          }
                        },
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 1.2,
                        ),
                        borderRadius: 12.0,
                        height: 50,
                        width: double.infinity,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00154F), Color(0xFF001B7D)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        elevation: 4,
                        fullWidth: true,
                        borderColor: Colors.transparent,
                        borderWidth: 0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
