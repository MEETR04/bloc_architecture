import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';
import 'app_text_style.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.white,
      secondary: AppColors.secondary,
      onSecondary: AppColors.white,
      error: AppColors.error,
      onError: AppColors.white,
      surface: AppColors.surfaceLight,
      onSurface: AppColors.grey900,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyle.headingLarge.copyWith(
        color: AppColors.grey900,
      ),
      iconTheme: const IconThemeData(color: AppColors.grey900),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: AppColors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    ),
    textTheme: TextTheme(
      displayLarge: AppTextStyle.displayLarge.copyWith(
        color: AppColors.grey900,
      ),
      displayMedium: AppTextStyle.displayMedium.copyWith(
        color: AppColors.grey900,
      ),
      displaySmall: AppTextStyle.displaySmall.copyWith(
        color: AppColors.grey900,
      ),
      titleLarge: AppTextStyle.headingLarge.copyWith(color: AppColors.grey900),
      titleMedium: AppTextStyle.headingMedium.copyWith(
        color: AppColors.grey900,
      ),
      titleSmall: AppTextStyle.headingSmall.copyWith(color: AppColors.grey900),
      bodyLarge: AppTextStyle.bodyLarge.copyWith(color: AppColors.grey700),
      bodyMedium: AppTextStyle.bodyMedium.copyWith(color: AppColors.grey700),
      bodySmall: AppTextStyle.bodySmall.copyWith(color: AppColors.grey500),
      labelLarge: AppTextStyle.labelLarge.copyWith(color: AppColors.primary),
      labelMedium: AppTextStyle.labelMedium.copyWith(color: AppColors.grey600),
      labelSmall: AppTextStyle.labelSmall.copyWith(color: AppColors.grey500),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.grey50,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      hintStyle: AppTextStyle.bodyMedium.copyWith(color: AppColors.grey400),
      labelStyle: AppTextStyle.bodyMedium.copyWith(color: AppColors.grey700),
      errorStyle: AppTextStyle.bodySmall.copyWith(color: AppColors.error),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.grey200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.grey200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        textStyle: AppTextStyle.labelLarge.copyWith(color: AppColors.white),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        textStyle: AppTextStyle.labelLarge,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surfaceLight,
      elevation: 2,
      shadowColor: AppColors.grey100,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.grey200,
      thickness: 1,
      space: 1,
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.backgroundDark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: AppColors.white,
      secondary: AppColors.secondary,
      onSecondary: AppColors.white,
      error: AppColors.error,
      onError: AppColors.white,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.grey50,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: AppTextStyle.headingLarge.copyWith(
        color: AppColors.grey50,
      ),
      iconTheme: const IconThemeData(color: AppColors.grey50),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: AppColors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    ),
    textTheme: TextTheme(
      displayLarge: AppTextStyle.displayLarge.copyWith(color: AppColors.grey50),
      displayMedium: AppTextStyle.displayMedium.copyWith(
        color: AppColors.grey50,
      ),
      displaySmall: AppTextStyle.displaySmall.copyWith(color: AppColors.grey50),
      titleLarge: AppTextStyle.headingLarge.copyWith(color: AppColors.grey50),
      titleMedium: AppTextStyle.headingMedium.copyWith(color: AppColors.grey50),
      titleSmall: AppTextStyle.headingSmall.copyWith(color: AppColors.grey50),
      bodyLarge: AppTextStyle.bodyLarge.copyWith(color: AppColors.grey300),
      bodyMedium: AppTextStyle.bodyMedium.copyWith(color: AppColors.grey300),
      bodySmall: AppTextStyle.bodySmall.copyWith(color: AppColors.grey400),
      labelLarge: AppTextStyle.labelLarge.copyWith(
        color: AppColors.primaryLight,
      ),
      labelMedium: AppTextStyle.labelMedium.copyWith(color: AppColors.grey400),
      labelSmall: AppTextStyle.labelSmall.copyWith(color: AppColors.grey500),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.grey900,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      hintStyle: AppTextStyle.bodyMedium.copyWith(color: AppColors.grey500),
      labelStyle: AppTextStyle.bodyMedium.copyWith(color: AppColors.grey300),
      errorStyle: AppTextStyle.bodySmall.copyWith(color: AppColors.error),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.grey800),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.grey800),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 0,
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        textStyle: AppTextStyle.labelLarge.copyWith(color: AppColors.white),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryLight,
        side: const BorderSide(color: AppColors.primaryLight),
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        textStyle: AppTextStyle.labelLarge,
      ),
    ),
    cardTheme: CardThemeData(
      color: AppColors.surfaceDark,
      elevation: 2,
      shadowColor: AppColors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.grey800,
      thickness: 1,
      space: 1,
    ),
  );
}
