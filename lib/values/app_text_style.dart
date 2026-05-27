import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyle {
  AppTextStyle._();

  static const String fontFamily = 'Outfit';

  // Display Styles
  static TextStyle get displayLarge => TextStyle(
    fontFamily: fontFamily,
    fontSize: 32.r,
    fontWeight: FontWeight.bold,
    letterSpacing: -1.0,
  );

  static TextStyle get displayMedium => TextStyle(
    fontFamily: fontFamily,
    fontSize: 28.r,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );

  static TextStyle get displaySmall => TextStyle(
    fontFamily: fontFamily,
    fontSize: 24.r,
    fontWeight: FontWeight.w700,
  );

  // Heading Styles
  static TextStyle get headingLarge => TextStyle(
    fontFamily: fontFamily,
    fontSize: 20.r,
    fontWeight: FontWeight.w700,
  );

  static TextStyle get headingMedium => TextStyle(
    fontFamily: fontFamily,
    fontSize: 18.r,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get headingSmall => TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.r,
    fontWeight: FontWeight.w600,
  );

  // Body Styles
  static TextStyle get bodyLarge => TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.r,
    fontWeight: FontWeight.normal,
  );

  static TextStyle get bodyMedium => TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.r,
    fontWeight: FontWeight.normal,
  );

  static TextStyle get bodySmall => TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.r,
    fontWeight: FontWeight.normal,
  );

  // Button and Label Styles
  static TextStyle get labelLarge => TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.r,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  static TextStyle get labelMedium => TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.r,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get labelSmall => TextStyle(
    fontFamily: fontFamily,
    fontSize: 10.r,
    fontWeight: FontWeight.w500,
  );
}
