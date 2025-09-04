// Features Section Widget for Landing Page
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/localization/localization_extension.dart';
import '../../../../core/utils/responsive_utils.dart';

class FeaturesSection extends StatelessWidget {
  final AnimationController animationController;

  const FeaturesSection({super.key, required this.animationController});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveUtils.isDesktop(context);
    final isTablet = ResponsiveUtils.isTablet(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80.w : (isTablet ? 40.w : 20.w),
        vertical: 80.h,
      ),
      child: Column(
        children: [
          // Section Header
          AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: animationController,
                child: Column(
                  children: [
                    Text(
                      context.tr('why_choose_us'),
                      style: isDesktop
                          ? AppTextStyles.displaySmall.copyWith(
                              fontWeight: FontWeight.bold,
                            )
                          : AppTextStyles.headlineLarge.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      context.tr('features_subtitle'),
                      style: AppTextStyles.titleMedium.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),

          SizedBox(height: 60.h),

          // Features Grid
          _buildFeaturesGrid(context, isDesktop, isTablet),
        ],
      ),
    );
  }

  Widget _buildFeaturesGrid(
    BuildContext context,
    bool isDesktop,
    bool isTablet,
  ) {
    final features = _getFeatures(context);

    if (isDesktop) {
      return Row(
        children: features
            .map(
              (feature) => Expanded(
                child: _buildFeatureCard(context, feature, isDesktop: true),
              ),
            )
            .toList(),
      );
    } else if (isTablet) {
      return Column(
        children: [
          Row(
            children: features
                .take(2)
                .map(
                  (feature) => Expanded(
                    child: _buildFeatureCard(
                      context,
                      feature,
                      isDesktop: false,
                    ),
                  ),
                )
                .toList(),
          ),
          SizedBox(height: 20.h),
          Row(
            children: features
                .skip(2)
                .map(
                  (feature) => Expanded(
                    child: _buildFeatureCard(
                      context,
                      feature,
                      isDesktop: false,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      );
    } else {
      return Column(
        children: features
            .map(
              (feature) => Padding(
                padding: EdgeInsets.only(bottom: 20.h),
                child: _buildFeatureCard(context, feature, isDesktop: false),
              ),
            )
            .toList(),
      );
    }
  }

  Widget _buildFeatureCard(
    BuildContext context,
    FeatureData feature, {
    required bool isDesktop,
  }) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
              .animate(
                CurvedAnimation(
                  parent: animationController,
                  curve: Interval(
                    feature.animationDelay,
                    feature.animationDelay + 0.6,
                    curve: Curves.easeOut,
                  ),
                ),
              ),
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: animationController,
              curve: Interval(
                feature.animationDelay,
                feature.animationDelay + 0.6,
                curve: Curves.easeOut,
              ),
            ),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: isDesktop ? 10.w : 0),
              padding: EdgeInsets.all(isDesktop ? 30.w : 24.w),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.surfaceDark
                    : Colors.white,
                borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
                border: Border.all(
                  color: feature.color.withOpacity(0.1),
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  // Icon
                  Container(
                    width: isDesktop ? 80.w : 60.w,
                    height: isDesktop ? 80.w : 60.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          feature.color.withOpacity(0.2),
                          feature.color.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusL,
                      ),
                    ),
                    child: Icon(
                      feature.icon,
                      size: isDesktop ? 40.sp : 30.sp,
                      color: feature.color,
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Title
                  Text(
                    feature.title,
                    style: isDesktop
                        ? AppTextStyles.titleLarge.copyWith(
                            fontWeight: FontWeight.bold,
                          )
                        : AppTextStyles.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 12.h),

                  // Description
                  Text(
                    feature.description,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<FeatureData> _getFeatures(BuildContext context) {
    return [
      FeatureData(
        icon: Icons.local_shipping_outlined,
        title: context.tr('fast_delivery'),
        description: context.tr('fast_delivery_desc'),
        color: AppColors.primary,
        animationDelay: 0.1,
      ),
      FeatureData(
        icon: Icons.verified_user_outlined,
        title: context.tr('secure_shopping'),
        description: context.tr('secure_shopping_desc'),
        color: AppColors.success,
        animationDelay: 0.2,
      ),
      FeatureData(
        icon: Icons.support_agent_outlined,
        title: context.tr('customer_support'),
        description: context.tr('customer_support_desc'),
        color: AppColors.secondary,
        animationDelay: 0.3,
      ),
      FeatureData(
        icon: Icons.price_check_outlined,
        title: context.tr('best_prices'),
        description: context.tr('best_prices_desc'),
        color: AppColors.warning,
        animationDelay: 0.4,
      ),
    ];
  }
}

class FeatureData {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final double animationDelay;

  FeatureData({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.animationDelay,
  });
}
