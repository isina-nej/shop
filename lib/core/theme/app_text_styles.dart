// App Typography System
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  // Font Families
  static const String primaryFontFamily = 'Roboto';
  static const String secondaryFontFamily = 'Inter';

  // Display Styles
  static TextStyle get displayLarge => TextStyle(
    fontSize: 32.sp,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static TextStyle get displayMedium => TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.3,
    height: 1.3,
  );

  static TextStyle get displaySmall => TextStyle(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
    height: 1.3,
  );

  // Headline Styles
  static TextStyle get headlineLarge => TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.3,
  );

  static TextStyle get headlineMedium => TextStyle(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.4,
  );

  static TextStyle get headlineSmall => TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.4,
  );

  // Title Styles
  static TextStyle get titleLarge => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.15,
    height: 1.5,
  );

  static TextStyle get titleMedium => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.4,
  );

  static TextStyle get titleSmall => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.4,
  );

  // Body Styles
  static TextStyle get bodyLarge => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.5,
    height: 1.5,
  );

  static TextStyle get bodyMedium => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.25,
    height: 1.4,
  );

  static TextStyle get bodySmall => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.4,
    height: 1.3,
  );

  // Label Styles
  static TextStyle get labelLarge => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    height: 1.4,
  );

  static TextStyle get labelMedium => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.3,
  );

  static TextStyle get labelSmall => TextStyle(
    fontSize: 10.sp,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    height: 1.2,
  );

  // Price Styles
  static TextStyle get priceStyle => TextStyle(
    fontSize: 18.sp,
    fontWeight: FontWeight.bold,
    letterSpacing: 0,
    height: 1.2,
  );

  static TextStyle get discountPriceStyle => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    letterSpacing: 0,
    height: 1.2,
    decoration: TextDecoration.lineThrough,
  );

  // Button Styles
  static TextStyle get buttonTextStyle => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    height: 1.2,
  );

  // Caption Styles
  static TextStyle get caption => TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.normal,
    letterSpacing: 0.5,
    height: 1.3,
  );
}
