import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSpacing {
  AppSpacing._();

  // Spacing sizes (margins / paddings)
  static double get s4 => 4.r;
  static double get s8 => 8.r;
  static double get s12 => 12.r;
  static double get s16 => 16.r;
  static double get s20 => 20.r;
  static double get s24 => 24.r;
  static double get s32 => 32.r;
  static double get s48 => 48.r;

  // Vertical spacing widgets
  static SizedBox get vs4 => 4.verticalSpace;
  static SizedBox get vs8 => 8.verticalSpace;
  static SizedBox get vs12 => 12.verticalSpace;
  static SizedBox get vs16 => 16.verticalSpace;
  static SizedBox get vs20 => 20.verticalSpace;
  static SizedBox get vs24 => 24.verticalSpace;
  static SizedBox get vs32 => 32.verticalSpace;
  static SizedBox get vs48 => 48.verticalSpace;

  // Horizontal spacing widgets
  static SizedBox get hs4 => 4.horizontalSpace;
  static SizedBox get hs8 => 8.horizontalSpace;
  static SizedBox get hs12 => 12.horizontalSpace;
  static SizedBox get hs16 => 16.horizontalSpace;
  static SizedBox get hs20 => 20.horizontalSpace;
  static SizedBox get hs24 => 24.horizontalSpace;
  static SizedBox get hs32 => 32.horizontalSpace;
  static SizedBox get hs48 => 48.horizontalSpace;

  // Edge Insets
  static EdgeInsets get allS4 => EdgeInsets.all(4.r);
  static EdgeInsets get allS8 => EdgeInsets.all(8.r);
  static EdgeInsets get allS12 => EdgeInsets.all(12.r);
  static EdgeInsets get allS16 => EdgeInsets.all(16.r);
  static EdgeInsets get allS20 => EdgeInsets.all(20.r);
  static EdgeInsets get allS24 => EdgeInsets.all(24.r);

  static EdgeInsets get symmetricHS4 => EdgeInsets.symmetric(horizontal: 4.r);
  static EdgeInsets get symmetricHS8 => EdgeInsets.symmetric(horizontal: 8.r);
  static EdgeInsets get symmetricHS12 => EdgeInsets.symmetric(horizontal: 12.r);
  static EdgeInsets get symmetricHS16 => EdgeInsets.symmetric(horizontal: 16.r);
  static EdgeInsets get symmetricHS20 => EdgeInsets.symmetric(horizontal: 20.r);
  static EdgeInsets get symmetricHS24 => EdgeInsets.symmetric(horizontal: 24.r);

  static EdgeInsets get symmetricVS4 => EdgeInsets.symmetric(vertical: 4.r);
  static EdgeInsets get symmetricVS8 => EdgeInsets.symmetric(vertical: 8.r);
  static EdgeInsets get symmetricVS12 => EdgeInsets.symmetric(vertical: 12.r);
  static EdgeInsets get symmetricVS16 => EdgeInsets.symmetric(vertical: 16.r);
  static EdgeInsets get symmetricVS20 => EdgeInsets.symmetric(vertical: 20.r);
  static EdgeInsets get symmetricVS24 => EdgeInsets.symmetric(vertical: 24.r);
}
