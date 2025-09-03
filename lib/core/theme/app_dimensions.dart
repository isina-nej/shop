import 'package:flutter_screenutil/flutter_screenutil.dart';

// Responsive Breakpoints
class AppBreakpoints {
  static const double mobile = 480;
  static const double tablet = 768;
  static const double desktop = 1024;
  static const double largeDesktop = 1440;

  static bool isMobile(double width) => width < mobile;
  static bool isTablet(double width) => width >= mobile && width < desktop;
  static bool isDesktop(double width) => width >= desktop;
  static bool isLargeDesktop(double width) => width >= largeDesktop;
}

// App Dimensions
class AppDimensions {
  // Padding
  static double get paddingXS => 4.0.w;
  static double get paddingS => 8.0.w;
  static double get paddingM => 16.0.w;
  static double get paddingL => 24.0.w;
  static double get paddingXL => 32.0.w;
  static double get paddingXXL => 48.0.w;

  // Margin
  static double get marginXS => 4.0.w;
  static double get marginS => 8.0.w;
  static double get marginM => 16.0.w;
  static double get marginL => 24.0.w;
  static double get marginXL => 32.0.w;
  static double get marginXXL => 48.0.w;

  // Border Radius
  static double get radiusXS => 4.0.r;
  static double get radiusS => 8.0.r;
  static double get radiusM => 12.0.r;
  static double get radiusL => 16.0.r;
  static double get radiusXL => 24.0.r;
  static double get radiusXXL => 32.0.r;

  // Icon Sizes
  static double get iconXS => 16.0.sp;
  static double get iconS => 20.0.sp;
  static double get iconM => 24.0.sp;
  static double get iconL => 32.0.sp;
  static double get iconXL => 48.0.sp;

  // Button Heights
  static double get buttonHeightS => 32.0.h;
  static double get buttonHeightM => 44.0.h;
  static double get buttonHeightL => 56.0.h;

  // Card Heights
  static double get cardHeightS => 120.0.h;
  static double get cardHeightM => 180.0.h;
  static double get cardHeightL => 240.0.h;

  // App Bar Height
  static double get appBarHeight => 56.0.h;
  static double get tabBarHeight => 48.0.h;

  // Bottom Navigation Height
  static double get bottomNavHeight => 60.0.h;

  // Grid Spacing
  static double get gridSpacingS => 8.0.w;
  static double get gridSpacingM => 16.0.w;
  static double get gridSpacingL => 24.0.w;

  // Elevation
  static double get elevationS => 2.0;
  static double get elevationM => 4.0;
  static double get elevationL => 8.0;
  static double get elevationXL => 16.0;

  // Responsive Spacing Helpers
  static double getResponsiveSpacing(
    double screenWidth, {
    double baseSpacing = 16.0,
  }) {
    if (AppBreakpoints.isMobile(screenWidth)) {
      return baseSpacing;
    } else if (AppBreakpoints.isTablet(screenWidth)) {
      return baseSpacing * 1.2;
    } else {
      return baseSpacing * 1.5;
    }
  }

  // Responsive Font Size Helpers
  static double getResponsiveFontSize(
    double screenWidth, {
    double baseSize = 14.0,
  }) {
    if (AppBreakpoints.isMobile(screenWidth)) {
      return baseSize.sp;
    } else if (AppBreakpoints.isTablet(screenWidth)) {
      return (baseSize * 1.1).sp;
    } else {
      return (baseSize * 1.2).sp;
    }
  }

  // Responsive Container Width Helpers
  static double getResponsiveContainerWidth(
    double screenWidth, {
    double maxWidth = 1200.0,
  }) {
    if (AppBreakpoints.isMobile(screenWidth)) {
      return screenWidth - 32.0; // Account for padding
    } else if (AppBreakpoints.isTablet(screenWidth)) {
      return screenWidth * 0.9;
    } else {
      return maxWidth;
    }
  }
}
