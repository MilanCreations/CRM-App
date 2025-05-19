// ignore_for_file: deprecated_member_use, constant_identifier_names

import 'package:flutter/material.dart';

class CRMColors {
  CRMColors._();

  // Primary & Secondary Colors
  static const Color primary = Color(0xFF4b68ff);
  static const Color primary1 = Color(0xFFFA6C12);
  static const Color secondary = Color(0xFFFFE248);
  static const Color accent = Color(0xFFb8c7ff);
  static const Color accent1 = Color(0xFFFF77D7);

  // Text Colors
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF6C7570);
  static const Color textSecondary1 = Color(0xFF757575);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFFFF8E1);
  static const Color snowWhite = Color(0xFFFFFAFA);
  static const Color textMain = Color(0xFF212121);

  // Background Colors
  static const Color background = Color(0xFFF9F9F9);
  static const Color backgroundDialogue = Color(0xFF0E2328);
  static const Color light = Color(0xFFF6F6F6);
  static const Color dark = Color(0xFF272727);
  static const Color primaryBackground = Color(0xFFF3F5FF);
  static Color darkContainer = CRMColors.textWhite.withOpacity(8.1);
  static const Color lightContainer = Color(0xFFF6F6F6);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Border Colors
  // static const Color border = Color(0xFFE0E0E0);
  // static const Color borderPrimary = Color(0xFF090909);
  // static const Color borderSecondary = Color(0xFFE6E6E6);
  // static const Color transactionBorder = Color(0xFF283C40);
  // static const Color dropdownBorderColor = Color(0xFF283C40);
  // static const Color dialogueBorder = Color(0xFF5B4132);

  static const Color dashboardClockInContainer = Color(0xFFF3F4F6);
  static const Color clockInDate_and_position = Color(0xFF6B7280);

  // Divider
  static const Color dividerCOlor = Color(0xFFD5A953);

  // Status Colors
  static const Color error = Color(0xFFD32F2F);
  static const Color error1 = Color(0xFFF44336);
  static const Color success = Color(0xFF388E3C);
  static const Color success1 = Color(0xFF4CAF50);
  static const Color info = Color(0xFF197602);
  static const Color info1 = Color(0xFF2196F3);
  static const Color warning = Color(0xFFF57C00);
  static const Color pending = Color(0xFFFFC107);
  static const Color running = Color(0xFF00B4D8);
  static const Color succeed = Color(0xFF0EAD69);

  // Dialogue & UI States
  static const Color proceed = Color(0xFF0EAD69);
  static const Color close = Color(0xFFD90429);

  // Text Field
  static const Color textFiledFocusBorder = Color(0xFFF70100);
  static const Color textfieldbackgroung = Color(0xFF0E0E3A);

  // Button Colors
  static const Color button = Color(0xFF073179);
  static const Color clockInButton = Color(0xFF12A58C);
  // static const Color buttonSecondary = Color(0xFF6C7570);
  // static const Color buttonDisabled = Color(0xFFC4C4C4);
  // static const Color transfermoneybutton = Color(0xFF0C67A3);

  // Miscellaneous Colors
  static const Color black = Color(0xFF232323);
  static const Color black1 = Color(0xFF020100);
  static const Color darkerGrey = Color(0xFF4F4F4F);
  static const Color darkGrey = Color(0xFF939393);
  static const Color grey = Color(0xFFE0E0E0);
  static const Color lightgrey = Color(0xFFDEDEDE);
  static const Color bottom = Color(0xFFEEEDED);
  static const Color welcomeContainer = Color(0xFF1EC756);
  static const Color onboarding1textcolor = Color(0xFF787878);

  // Gradient Colors
  static Gradient linerGradient = LinearGradient(
    begin: Alignment(0.0, 0.0),
    end: Alignment(0.707, -0.707),
    colors: [
      Color.fromARGB(255, 38, 71, 86),
      Color(0xFF203A43),
      Color(0xFF2C5364),
    ],
  );

  static Gradient buttonGradient = LinearGradient(
    begin: Alignment(0.0, 0.0),
    end: Alignment(0.707, -0.707),
    colors: [
      Color(0xFFF70100),
      Color(0xFF232323),
    ],
  );

    // 📊 Dashboard
  static const Color dashboardIconContainer = Color(0xFF0C67A3);
  static const Color planColor = Color(0xFFC5C5C5);
  static const Color referralURL = Color(0xFF152238);

  // Privacy Policy
  static const Color privacyPolicy = Color(0xFF9A9A9A);
  static const Color privacyPolicy1 = Color(0xFFF70100);

  // Password Reset Success
  static const Color passwordResetSuccess = Color(0xFFE1F8E9);
  static const Color passwordResetdone = Color(0xFF1EC756);
  
  // Text main color
  static const Color textMainCOlor = Color(0xFFF70100);
  static const Color crmMainCOlor = Color(0xFF397BFF);
  static const Color logoBackgroundColor = Color(0xFF271E49);
  static const Color whiteColor = Color(0xFFFFFFFF);


  // Salary list colours
   static const Color crmMain = Color(0xFF0C46CC);
  static const Color crmAccentColor = Color(0xFFEC32B1);
  static const Color white = Colors.white;
  static const Color blue = Color(0xFF0C46CC);
  static const Color red = Colors.redAccent;
  static const Color orange = Colors.orange;
  static const Color teal = Colors.teal;
  static const Color purple = Colors.purple;
  static const Color greenLight = Color(0xFFE6F4EA);
  static const Color greenDark = Color(0xFF1B873E);
  static const Color textblack = Colors.black87;
}
