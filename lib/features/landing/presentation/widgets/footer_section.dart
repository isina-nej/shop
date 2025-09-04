// Footer Section Widget for Landing Page
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/localization/localization_extension.dart';
import '../../../../core/utils/responsive_utils.dart';

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveUtils.isDesktop(context);
    final isTablet = ResponsiveUtils.isTablet(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDark ? AppColors.surfaceDark : AppColors.grey100,
      padding: EdgeInsets.all(isDesktop ? 60.w : (isTablet ? 40.w : 30.w)),
      child: Column(
        children: [
          isDesktop
              ? _buildDesktopLayout(context)
              : _buildMobileLayout(context),

          SizedBox(height: 40.h),

          // Divider
          Divider(
            color:
                (isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight)
                    .withOpacity(0.3),
          ),

          SizedBox(height: 20.h),

          // Bottom Footer
          _buildBottomFooter(context, isDesktop),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Company Info
        Expanded(flex: 2, child: _buildCompanyInfo(context)),

        SizedBox(width: 40.w),

        // Quick Links
        Expanded(child: _buildQuickLinks(context)),

        SizedBox(width: 40.w),

        // Customer Service
        Expanded(child: _buildCustomerService(context)),

        SizedBox(width: 40.w),

        // Contact Info
        Expanded(child: _buildContactInfo(context)),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        _buildCompanyInfo(context),
        SizedBox(height: 30.h),

        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildQuickLinks(context)),
            SizedBox(width: 20.w),
            Expanded(child: _buildCustomerService(context)),
          ],
        ),

        SizedBox(height: 30.h),
        _buildContactInfo(context),
      ],
    );
  }

  Widget _buildCompanyInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo and App Name
        Row(
          children: [
            Icon(Icons.shopping_bag, color: AppColors.primary, size: 32.sp),
            SizedBox(width: 12.w),
            Text(
              context.tr('app_name'),
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),

        SizedBox(height: 16.h),

        // Description
        Text(
          context.tr('app_description'),
          style: AppTextStyles.bodyMedium.copyWith(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
            height: 1.5,
          ),
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
        ),

        SizedBox(height: 20.h),

        // Social Media Icons
        Row(
          children: [
            _buildSocialIcon(context, Icons.facebook, 'Facebook'),
            SizedBox(width: 12.w),
            _buildSocialIcon(context, Icons.mail, 'Instagram'),
            SizedBox(width: 12.w),
            _buildSocialIcon(context, Icons.send, 'Twitter'),
            SizedBox(width: 12.w),
            _buildSocialIcon(context, Icons.telegram, 'Telegram'),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickLinks(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr('quick_links'),
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: 16.h),

        _buildFooterLink(context, context.tr('home'), '/home'),
        _buildFooterLink(context, context.tr('products'), '/products'),
        _buildFooterLink(context, context.tr('categories'), '/categories'),
        _buildFooterLink(context, context.tr('about_us'), '/about'),
        _buildFooterLink(context, context.tr('contact_us'), '/contact'),
      ],
    );
  }

  Widget _buildCustomerService(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr('customer_service'),
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: 16.h),

        _buildFooterLink(context, context.tr('help_center'), '/help'),
        _buildFooterLink(context, context.tr('shipping_info'), '/shipping'),
        _buildFooterLink(context, context.tr('returns'), '/returns'),
        _buildFooterLink(context, context.tr('faq'), '/faq'),
        _buildFooterLink(context, context.tr('support'), '/support'),
      ],
    );
  }

  Widget _buildContactInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr('contact_info'),
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: 16.h),

        _buildContactItem(
          context,
          Icons.location_on,
          context.tr('address_text'),
        ),
        SizedBox(height: 8.h),
        _buildContactItem(context, Icons.phone, '+98 21 1234 5678'),
        SizedBox(height: 8.h),
        _buildContactItem(context, Icons.email, 'info@sinashop.com'),
        SizedBox(height: 8.h),
        _buildContactItem(
          context,
          Icons.access_time,
          context.tr('working_hours_text'),
        ),
      ],
    );
  }

  Widget _buildFooterLink(BuildContext context, String text, String route) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: GestureDetector(
        onTap: () => Get.toNamed(route),
        child: Text(
          text,
          style: AppTextStyles.bodyMedium.copyWith(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem(BuildContext context, IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18.sp, color: AppColors.primary),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialIcon(
    BuildContext context,
    IconData icon,
    String platform,
  ) {
    return GestureDetector(
      onTap: () {
        // Handle social media link
      },
      child: Container(
        width: 40.w,
        height: 40.w,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        child: Icon(icon, size: 20.sp, color: AppColors.primary),
      ),
    );
  }

  Widget _buildBottomFooter(BuildContext context, bool isDesktop) {
    return isDesktop
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '© 2025 ${context.tr('app_name')}. ${context.tr('all_rights_reserved')}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
              Row(
                children: [
                  _buildBottomLink(context, context.tr('privacy_terms')),
                  SizedBox(width: 20.w),
                  _buildBottomLink(context, context.tr('service_terms')),
                  SizedBox(width: 20.w),
                  _buildBottomLink(context, context.tr('cookies_policy')),
                ],
              ),
            ],
          )
        : Column(
            children: [
              Text(
                '© 2025 ${context.tr('app_name')}. ${context.tr('all_rights_reserved')}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildBottomLink(context, context.tr('privacy_terms')),
                  SizedBox(width: 15.w),
                  _buildBottomLink(context, context.tr('service_terms')),
                  SizedBox(width: 15.w),
                  _buildBottomLink(context, context.tr('cookies_policy')),
                ],
              ),
            ],
          );
  }

  Widget _buildBottomLink(BuildContext context, String text) {
    return GestureDetector(
      onTap: () {
        // Handle bottom link navigation
      },
      child: Text(
        text,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.primary,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
