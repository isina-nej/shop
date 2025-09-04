// Stats Section Widget for Landing Page
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/localization/localization_extension.dart';
import '../../../../core/utils/responsive_utils.dart';

class StatsSection extends StatelessWidget {
  final AnimationController animationController;

  const StatsSection({super.key, required this.animationController});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveUtils.isDesktop(context);
    final isTablet = ResponsiveUtils.isTablet(context);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80.w : (isTablet ? 40.w : 20.w),
      ),
      padding: EdgeInsets.all(isDesktop ? 60.w : 40.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.05),
            AppColors.secondary.withOpacity(0.03),
            AppColors.primary.withOpacity(0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: isDesktop
          ? _buildDesktopLayout(context)
          : _buildMobileLayout(context),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    final stats = _getStats(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: stats
          .map(
            (stat) =>
                Expanded(child: _buildStatItem(context, stat, isDesktop: true)),
          )
          .toList(),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    final stats = _getStats(context);
    return Column(
      children: [
        Row(
          children: stats
              .take(2)
              .map(
                (stat) => Expanded(
                  child: _buildStatItem(context, stat, isDesktop: false),
                ),
              )
              .toList(),
        ),
        SizedBox(height: 30.h),
        Row(
          children: stats
              .skip(2)
              .map(
                (stat) => Expanded(
                  child: _buildStatItem(context, stat, isDesktop: false),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    StatData stat, {
    required bool isDesktop,
  }) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1.0).animate(
            CurvedAnimation(
              parent: animationController,
              curve: Interval(
                stat.animationDelay,
                stat.animationDelay + 0.5,
                curve: Curves.elasticOut,
              ),
            ),
          ),
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: animationController,
              curve: Interval(
                stat.animationDelay,
                stat.animationDelay + 0.5,
                curve: Curves.easeOut,
              ),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Column(
                children: [
                  // Icon
                  Container(
                    width: isDesktop ? 60.w : 50.w,
                    height: isDesktop ? 60.w : 50.w,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          stat.color.withOpacity(0.2),
                          stat.color.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusL,
                      ),
                    ),
                    child: Icon(
                      stat.icon,
                      size: isDesktop ? 30.sp : 25.sp,
                      color: stat.color,
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Number with animation
                  TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 2000),
                    tween: Tween<double>(begin: 0, end: stat.value),
                    builder: (context, value, child) {
                      return Text(
                        stat.formatValue(value),
                        style: isDesktop
                            ? AppTextStyles.displaySmall.copyWith(
                                fontWeight: FontWeight.bold,
                                color: stat.color,
                              )
                            : AppTextStyles.headlineMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: stat.color,
                              ),
                      );
                    },
                  ),

                  SizedBox(height: 8.h),

                  // Label
                  Text(
                    stat.label,
                    style: isDesktop
                        ? AppTextStyles.titleMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          )
                        : AppTextStyles.titleSmall.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 4.h),

                  // Description
                  Text(
                    stat.description,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
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

  List<StatData> _getStats(BuildContext context) {
    return [
      StatData(
        icon: Icons.people_outline,
        value: 50000,
        label: context.tr('happy_customers'),
        description: context.tr('satisfied_users'),
        color: AppColors.primary,
        animationDelay: 0.1,
        formatValue: (value) => '${(value / 1000).toStringAsFixed(0)}K+',
      ),
      StatData(
        icon: Icons.inventory_outlined,
        value: 25000,
        label: context.tr('products'),
        description: context.tr('in_stock'),
        color: AppColors.secondary,
        animationDelay: 0.2,
        formatValue: (value) => '${(value / 1000).toStringAsFixed(0)}K+',
      ),
      StatData(
        icon: Icons.local_shipping_outlined,
        value: 100000,
        label: context.tr('orders_delivered'),
        description: context.tr('successfully'),
        color: AppColors.success,
        animationDelay: 0.3,
        formatValue: (value) => '${(value / 1000).toStringAsFixed(0)}K+',
      ),
      StatData(
        icon: Icons.star_outline,
        value: 4.9,
        label: context.tr('rating'),
        description: context.tr('average_rating'),
        color: AppColors.warning,
        animationDelay: 0.4,
        formatValue: (value) => value.toStringAsFixed(1),
      ),
    ];
  }
}

class StatData {
  final IconData icon;
  final double value;
  final String label;
  final String description;
  final Color color;
  final double animationDelay;
  final String Function(double) formatValue;

  StatData({
    required this.icon,
    required this.value,
    required this.label,
    required this.description,
    required this.color,
    required this.animationDelay,
    required this.formatValue,
  });
}
