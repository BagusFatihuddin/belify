import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFF156651);
  static const Color background = Color(0xFFF5F5F5);
  static const Color white = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF404040);
  static const Color textLight = Color(0xFF757575);
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFC2C2C2);
  static const Color black = Color(0xFF000000);
  static const Color eyeIcon = Color(0xFF9E9E9E);
}

class AppTextStyles {
  static TextStyle heading = GoogleFonts.manrope(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: AppColors.textDark,
    height: 1.2,
  );

  static TextStyle subheading = GoogleFonts.manrope(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textLight,
    height: 1.2,
  );

  static TextStyle inputLabel = GoogleFonts.manrope(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textDark,
    height: 1.2,
  );

  static TextStyle inputText = GoogleFonts.manrope(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textDark,
    height: 1.2,
  );

  static TextStyle linkText = GoogleFonts.manrope(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.primary,
    height: 1.2,
  );

  static TextStyle buttonText = GoogleFonts.manrope(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
    height: 1.2,
  );

  static TextStyle socialButtonText = GoogleFonts.manrope(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
    height: 1.2,
  );

  static TextStyle dividerText = GoogleFonts.manrope(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textDark,
    height: 1.2,
  );

  static TextStyle registerText = GoogleFonts.manrope(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textDark,
    height: 1.2,
  );

  static TextStyle registerLinkText = GoogleFonts.manrope(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.primary,
    height: 1.2,
  );

  static TextStyle statusBarTime = TextStyle(
    fontFamily: 'SF Pro Text',
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    color: AppColors.black,
  );
}
