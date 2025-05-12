import 'package:crm_milan_creations/Auth/Forgot%20Password/ForgotPasswordScreen.dart';
import 'package:crm_milan_creations/Auth/Login/loginController.dart';
import 'package:crm_milan_creations/utils/colors.dart';
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

                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                              onTap: () {
                                Get.to(const ForgotPasswordScreen());
                              },
                              child: Text(
                                "Forgot password?",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  decoration: TextDecoration.underline,
                                ),
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
}
