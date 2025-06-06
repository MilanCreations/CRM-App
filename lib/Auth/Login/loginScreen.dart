// ignore_for_file: deprecated_member_use

import 'package:crm_milan_creations/Auth/Login/loginController.dart';
import 'package:crm_milan_creations/utils/colors.dart';
import 'package:crm_milan_creations/utils/font-styles.dart';
import 'package:crm_milan_creations/widgets/button.dart';
import 'package:crm_milan_creations/widgets/loader.dart';
import 'package:crm_milan_creations/widgets/textfiled.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController objLoginController = Get.put(LoginController());
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // 🟣 Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00154F), Color(0xFF001B7D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 30.0),
              child: Center(
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.05),
                    Image.asset(
                      'assets/mainlogo.png',
                      height: screenHeight * 0.22,
                    ),
                    SizedBox(height: screenHeight * 0.05),

                    // 🧊 Glass Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // ✉️ Email
                          CustomTextFormField(
                            label: 'Email',
                            showLabel: false,
                            controller: objLoginController.emailController,
                            prefixIcon: const Icon(Icons.email_outlined, color: Colors.white),
                            borderColor: Colors.transparent,
                            width: double.infinity,
                            backgroundColor: Colors.white.withOpacity(0.15),
                            textColor: Colors.white,
                            keyboardType: TextInputType.emailAddress,
                          ),

                          const SizedBox(height: 16),

                          // 🔐 Password
                          CustomTextFormField(
                            label: 'Password',
                            showLabel: false,
                            controller: objLoginController.passwordController,
                            prefixIcon: const Icon(Icons.lock_outline, color: Colors.white),
                            obscureText: _obscurePassword,
                            borderColor: Colors.transparent,
                            backgroundColor: Colors.white.withOpacity(0.15),
                            textColor: Colors.white,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                color: Colors.white70,
                              ),
                            ),
                          ),

                         

                          const SizedBox(height: 30),

                          // 🚪 Sign In Button
                          CustomButton(
                            text: 'Sign In',
                            onPressed: () {
                              String email = objLoginController.emailController.text;
                              String password = objLoginController.passwordController.text;

                              if (email.isEmpty) {
                                Get.snackbar("Message", "Please enter your email",
                                  backgroundColor: CRMColors.error,
                                  colorText: CRMColors.whiteColor,
                                );
                              } else if (password.isEmpty) {
                                Get.snackbar("Message", "Please enter your password",
                                  backgroundColor: CRMColors.error,
                                  colorText: CRMColors.whiteColor,
                                );
                              } else {
                                final emailRegex = RegExp(
                                    r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
                                if (!emailRegex.hasMatch(email)) {
                                  Get.snackbar("Invalid Email", "Please enter a valid email address",
                                    backgroundColor: CRMColors.error,
                                    colorText: CRMColors.whiteColor,
                                  );
                                } else {
                                  objLoginController.loginAPI();
                                }
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
                          ),
                           const SizedBox(height: 20),
                          Align(
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: () {
                                showAdminContactDialog();
                              },
                              child: Text(
                                "Employee Sign Up",
                                style: TextStyle(
                                  color: CRMColors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Loader
          LoaderOverlay(isLoading: objLoginController.isLoading),
        ],
      ),
    );
  }

   void showAdminContactDialog() {
  showDialog(
    context: context,
    builder: (_) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
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
            // Info icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.shade100,
              ),
              child: Icon(
                Icons.info_outline,
                size: 40,
                color: Colors.blue.shade800,
              ),
            ),
            const SizedBox(height: 20),

            // Title
            const CustomText(
             text:  "Admin Assistance Required",
              fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
            ),
            const SizedBox(height: 15),

            // Message
            const Text(
              "Please contact your administrator for further assistance.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
           
            const SizedBox(height: 25),

            // OK Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.blue.shade800,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                onPressed: () => Get.back(),
                child: const Text(
                  "OK",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

}
