// Floating Action Buttons Widget for Landing Page
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/localization/localization_extension.dart';
import '../../../../features/wishlist/presentation/widgets/wishlist_button.dart';

class FloatingActionButtons extends StatelessWidget {
  final bool showBackToTop;
  final VoidCallback onBackToTop;

  const FloatingActionButtons({
    super.key,
    required this.showBackToTop,
    required this.onBackToTop,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Wishlist Button
        FloatingActionButton(
          heroTag: "wishlist_fab",
          onPressed: () => Get.toNamed('/wishlist'),
          backgroundColor: AppColors.error,
          child: const WishlistButtonWithCount(iconColor: Colors.white),
          tooltip: context.tr('wishlist'),
        ),

        SizedBox(height: 16.h),

        // Cart Button
        FloatingActionButton(
          heroTag: "cart_fab",
          onPressed: () => Get.toNamed('/cart'),
          backgroundColor: AppColors.primary,
          child: Icon(Icons.shopping_cart, color: Colors.white, size: 24.sp),
          tooltip: context.tr('cart'),
        ),

        if (showBackToTop) ...[
          SizedBox(height: 16.h),

          // Back to Top Button
          FloatingActionButton(
            heroTag: "back_to_top",
            onPressed: onBackToTop,
            backgroundColor: AppColors.secondary,
            mini: true,
            child: Icon(
              Icons.keyboard_arrow_up,
              color: Colors.white,
              size: 24.sp,
            ),
            tooltip: context.tr('back_to_top'),
          ),
        ],
      ],
    );
  }
}
