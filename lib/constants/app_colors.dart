import 'package:flutter/material.dart';

class AppColors {
  // From logo
  static const Color navyDark = Color(0xFF1A2980);
  static const Color navyMid = Color(0xFF1E3A8A);
  static const Color navyLight = Color(0xFF2563EB);
  static const Color skyBlue = Color(0xFF38BDF8);
  static const Color orange = Color(0xFFF97316);
  static const Color orangeLight = Color(0xFFFB923C);
  static const Color white = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFF8FAFF);
  static const Color cardBg = Color(0xFF0F1C4D);
  static const Color cardBg2 = Color(0xFF162255);
  static const Color surfaceDark = Color(0xFF0A1535);
  static const Color textSecondary = Color(0xFF8BA3CC);

  static LinearGradient get navyGradient => const LinearGradient(
        colors: [navyDark, Color(0xFF26C6DA)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get orangeGradient => const LinearGradient(
        colors: [orange, Color(0xFFFF6B35)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get bgGradient => const LinearGradient(
        colors: [surfaceDark, navyDark, Color(0xFF0D2137)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
}

class AppTextStyles {
  static const TextStyle displayLarge = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w800,
    color: AppColors.white,
    letterSpacing: -1,
  );

  static const TextStyle headingLarge = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
    letterSpacing: -0.5,
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.white,
  );

  static const TextStyle bodySecondary = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle label = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    letterSpacing: 1.2,
  );
}
