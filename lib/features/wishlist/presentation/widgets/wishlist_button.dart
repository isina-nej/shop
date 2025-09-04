// Wishlist Heart Button Widget
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/models/shop_models.dart';
import '../wishlist_controller.dart';

class WishlistButton extends StatelessWidget {
  final Product product;
  final double? size;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? backgroundColor;
  final bool showAnimation;
  final VoidCallback? onToggle;

  const WishlistButton({
    super.key,
    required this.product,
    this.size,
    this.activeColor,
    this.inactiveColor,
    this.backgroundColor,
    this.showAnimation = true,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final wishlistController = Get.find<WishlistController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final isInWishlist = wishlistController.isInWishlist(product.id);

      return GestureDetector(
        onTap: () {
          wishlistController.toggleWishlist(product);
          onToggle?.call();
        },
        child: AnimatedContainer(
          duration: showAnimation
              ? const Duration(milliseconds: 200)
              : Duration.zero,
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color:
                backgroundColor ??
                (isDark ? AppColors.surfaceDark : Colors.white).withOpacity(
                  0.9,
                ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AnimatedScale(
            scale: isInWishlist ? 1.1 : 1.0,
            duration: showAnimation
                ? const Duration(milliseconds: 200)
                : Duration.zero,
            child: Icon(
              isInWishlist ? Icons.favorite : Icons.favorite_border,
              size: size ?? 20.sp,
              color: isInWishlist
                  ? (activeColor ?? AppColors.error)
                  : (inactiveColor ??
                        (isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight)),
            ),
          ),
        ),
      );
    });
  }
}

// Simple wishlist icon for compact spaces
class WishlistIcon extends StatelessWidget {
  final Product product;
  final double? size;
  final Color? activeColor;
  final Color? inactiveColor;
  final VoidCallback? onToggle;

  const WishlistIcon({
    super.key,
    required this.product,
    this.size,
    this.activeColor,
    this.inactiveColor,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final wishlistController = Get.find<WishlistController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final isInWishlist = wishlistController.isInWishlist(product.id);

      return IconButton(
        onPressed: () {
          wishlistController.toggleWishlist(product);
          onToggle?.call();
        },
        icon: Icon(
          isInWishlist ? Icons.favorite : Icons.favorite_border,
          size: size ?? 24.sp,
          color: isInWishlist
              ? (activeColor ?? AppColors.error)
              : (inactiveColor ??
                    (isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight)),
        ),
      );
    });
  }
}

// Animated wishlist button with count
class WishlistButtonWithCount extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? iconColor;
  final Color? badgeColor;
  final double? size;

  const WishlistButtonWithCount({
    super.key,
    this.onPressed,
    this.iconColor,
    this.badgeColor,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final wishlistController = Get.find<WishlistController>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Obx(() {
      final count = wishlistController.wishlistCount;

      return Stack(
        children: [
          IconButton(
            onPressed: onPressed ?? () => Get.toNamed('/wishlist'),
            icon: Icon(
              Icons.favorite_border,
              size: size ?? 24.sp,
              color:
                  iconColor ??
                  (isDark
                      ? AppColors.textPrimaryDark
                      : AppColors.textPrimaryLight),
            ),
          ),
          if (count > 0)
            Positioned(
              right: 0,
              top: 0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: badgeColor ?? AppColors.error,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    width: 1,
                  ),
                ),
                constraints: BoxConstraints(minWidth: 16.w, minHeight: 16.w),
                child: Text(
                  count > 99 ? '99+' : count.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      );
    });
  }
}

// Floating wishlist button for product pages
class FloatingWishlistButton extends StatelessWidget {
  final Product product;
  final VoidCallback? onToggle;

  const FloatingWishlistButton({
    super.key,
    required this.product,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final wishlistController = Get.find<WishlistController>();

    return Obx(() {
      final isInWishlist = wishlistController.isInWishlist(product.id);

      return FloatingActionButton(
        heroTag: "wishlist_${product.id}",
        onPressed: () {
          wishlistController.toggleWishlist(product);
          onToggle?.call();
        },
        backgroundColor: isInWishlist ? AppColors.error : AppColors.grey200,
        child: Icon(
          isInWishlist ? Icons.favorite : Icons.favorite_border,
          color: isInWishlist ? Colors.white : AppColors.textSecondaryLight,
        ),
      );
    });
  }
}
