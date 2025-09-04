// Hero Section Widget for Landing Page
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/localization/localization_extension.dart';
import '../../../../core/utils/responsive_utils.dart';

class HeroSection extends StatelessWidget {
  final AnimationController animationController;

  const HeroSection({super.key, required this.animationController});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveUtils.isDesktop(context);
    final isTablet = ResponsiveUtils.isTablet(context);

    return Container(
      height: isDesktop ? 600.h : (isTablet ? 500.h : 450.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.secondary.withOpacity(0.05),
            AppColors.primary.withOpacity(0.15),
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 80.w : (isTablet ? 40.w : 20.w),
          vertical: AppDimensions.paddingXL,
        ),
        child: isDesktop
            ? _buildDesktopLayout(context)
            : _buildMobileLayout(context),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 6, child: _buildContent(context, isDesktop: true)),
        SizedBox(width: 60.w),
        Expanded(flex: 4, child: _buildHeroImage(context, isDesktop: true)),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildContent(context, isDesktop: false),
        SizedBox(height: 40.h),
        _buildHeroImage(context, isDesktop: false),
      ],
    );
  }

  Widget _buildContent(BuildContext context, {required bool isDesktop}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Main Title
        AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            return SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(-0.5, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animationController,
                      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
                    ),
                  ),
              child: FadeTransition(
                opacity: CurvedAnimation(
                  parent: animationController,
                  curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
                ),
                child: Text(
                  context.tr('hero_title'),
                  style: isDesktop
                      ? AppTextStyles.displayLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          height: 1.2,
                        )
                      : AppTextStyles.headlineLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                          height: 1.2,
                        ),
                  textAlign: isDesktop ? TextAlign.start : TextAlign.center,
                ),
              ),
            );
          },
        ),

        SizedBox(height: 20.h),

        // Subtitle
        AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            return SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(-0.3, 0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animationController,
                      curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
                    ),
                  ),
              child: FadeTransition(
                opacity: CurvedAnimation(
                  parent: animationController,
                  curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
                ),
                child: Text(
                  context.tr('hero_subtitle'),
                  style: isDesktop
                      ? AppTextStyles.titleLarge.copyWith(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                          height: 1.5,
                        )
                      : AppTextStyles.titleMedium.copyWith(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                          height: 1.5,
                        ),
                  textAlign: isDesktop ? TextAlign.start : TextAlign.center,
                ),
              ),
            );
          },
        ),

        SizedBox(height: 40.h),

        // CTA Buttons
        AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            return SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(0, 0.5),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animationController,
                      curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
                    ),
                  ),
              child: FadeTransition(
                opacity: CurvedAnimation(
                  parent: animationController,
                  curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
                ),
                child: isDesktop
                    ? Row(
                        children: [
                          _buildPrimaryButton(context),
                          SizedBox(width: 20.w),
                          _buildSecondaryButton(context),
                          SizedBox(width: 20.w),
                          _buildRegisterButton(context),
                        ],
                      )
                    : Column(
                        children: [
                          _buildPrimaryButton(context),
                          SizedBox(height: 16.h),
                          _buildSecondaryButton(context),
                          SizedBox(height: 16.h),
                          _buildRegisterButton(context),
                        ],
                      ),
              ),
            );
          },
        ),

        SizedBox(height: 30.h),

        // Features List
        AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animationController,
                curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
              ),
              child: Wrap(
                spacing: 20.w,
                runSpacing: 10.h,
                children: [
                  _buildFeatureChip(
                    context,
                    Icons.local_shipping,
                    context.tr('free_shipping'),
                  ),
                  _buildFeatureChip(
                    context,
                    Icons.security,
                    context.tr('secure_payment'),
                  ),
                  _buildFeatureChip(
                    context,
                    Icons.support_agent,
                    context.tr('24_7_support'),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildHeroImage(BuildContext context, {required bool isDesktop}) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(0.5, 0), end: Offset.zero)
              .animate(
                CurvedAnimation(
                  parent: animationController,
                  curve: const Interval(0.3, 0.9, curve: Curves.easeOut),
                ),
              ),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(
              CurvedAnimation(
                parent: animationController,
                curve: const Interval(0.3, 0.9, curve: Curves.easeOut),
              ),
            ),
            child: Container(
              height: isDesktop ? 400.h : 250.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.2),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary.withOpacity(0.8),
                        AppColors.secondary.withOpacity(0.6),
                        AppColors.primary.withOpacity(0.9),
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Placeholder for hero image
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_bag_outlined,
                              size: isDesktop ? 120.sp : 80.sp,
                              color: Colors.white.withOpacity(0.9),
                            ),
                            SizedBox(height: 20.h),
                            Text(
                              context.tr('app_name'),
                              style: AppTextStyles.headlineMedium.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Decorative circles
                      Positioned(
                        top: 30.h,
                        right: 30.w,
                        child: Container(
                          width: 60.w,
                          height: 60.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 40.h,
                        left: 40.w,
                        child: Container(
                          width: 40.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPrimaryButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => Get.toNamed('/products'),
      icon: const Icon(Icons.shopping_bag),
      label: Text(context.tr('start_shopping')),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 16.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
        elevation: 8,
        shadowColor: AppColors.primary.withOpacity(0.3),
      ),
    );
  }

  Widget _buildSecondaryButton(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => Get.toNamed('/categories'),
      icon: const Icon(Icons.explore),
      label: Text(context.tr('explore_categories')),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: BorderSide(color: AppColors.primary, width: 2),
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 16.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return TextButton.icon(
      onPressed: () => Get.toNamed('/register'),
      icon: const Icon(Icons.person_add),
      label: Text(context.tr('register')),
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 16.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        ),
      ),
    );
  }

  Widget _buildFeatureChip(BuildContext context, IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.surfaceDark
            : Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16.sp, color: AppColors.primary),
          SizedBox(width: 8.w),
          Text(
            text,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
