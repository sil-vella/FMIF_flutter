import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF0A0E21);
  static const Color accentColor = Color(0xFFEB1555);
  static const Color scaffoldBackgroundColor = Color(0xFF0A0E21);
  static const Color white = Colors.white;
  static const Color lightGray = Color(0xFFD3D3D3);
}

class AppTextStyles {
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 16,
    color: AppColors.white,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.accentColor,
  );
}

class AppPadding {
  static const EdgeInsets defaultPadding = EdgeInsets.all(16.0);
  static const EdgeInsets cardPadding =
      EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0);
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      primaryColor: AppColors.primaryColor,
      hintColor: AppColors.accentColor,
      scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        bodyMedium: AppTextStyles.bodyMedium,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: AppTextStyles.buttonText,
          backgroundColor: AppColors.accentColor,
        ),
      ),
    );
  }
}
