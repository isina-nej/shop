// Wishlist Page
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/localization/localization_extension.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/models/shop_models.dart';
import '../wishlist_controller.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlistController = Get.put(WishlistController());

    return ResponsiveLayout(
      mobile: _buildMobileLayout(context, wishlistController),
      tablet: _buildTabletLayout(context, wishlistController),
      desktop: _buildDesktopLayout(context, wishlistController),
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    WishlistController controller,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('wishlist')),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          Obx(() {
            if (controller.wishlistItems.isNotEmpty) {
              return PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  switch (value) {
                    case 'clear_all':
                      controller.clearWishlist();
                      break;
                    case 'share':
                      controller.shareWishlist();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'clear_all',
                    child: Row(
                      children: [
                        const Icon(Icons.clear_all),
                        SizedBox(width: AppDimensions.paddingM),
                        Text(context.tr('clear_all')),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'share',
                    child: Row(
                      children: [
                        const Icon(Icons.share),
                        SizedBox(width: AppDimensions.paddingM),
                        Text(context.tr('share_wishlist')),
                      ],
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.wishlistItems.isEmpty) {
          return _buildEmptyWishlist(context);
        }

        return Column(
          children: [
            // Wishlist summary
            _buildWishlistSummary(context, controller),

            // Wishlist items
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(AppDimensions.paddingM),
                itemCount: controller.wishlistItems.length,
                itemBuilder: (context, index) {
                  final product = controller.wishlistItems[index];
                  return _buildWishlistItem(context, controller, product);
                },
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: Obx(() {
        if (controller.wishlistItems.isNotEmpty) {
          return _buildBottomActions(context, controller);
        }
        return const SizedBox.shrink();
      }),
    );
  }

  Widget _buildTabletLayout(
    BuildContext context,
    WishlistController controller,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('wishlist')),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.wishlistItems.isEmpty) {
          return _buildEmptyWishlist(context);
        }

        return Column(
          children: [
            _buildWishlistSummary(context, controller),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(AppDimensions.paddingM),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: AppDimensions.paddingM,
                  mainAxisSpacing: AppDimensions.paddingM,
                ),
                itemCount: controller.wishlistItems.length,
                itemBuilder: (context, index) {
                  final product = controller.wishlistItems[index];
                  return _buildWishlistCard(context, controller, product);
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    WishlistController controller,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('wishlist')),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.wishlistItems.isEmpty) {
          return _buildEmptyWishlist(context);
        }

        return Row(
          children: [
            // Left sidebar - Wishlist actions
            Container(
              width: 280.w,
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.surfaceDark
                  : AppColors.white,
              child: Column(
                children: [
                  _buildWishlistSummary(context, controller),
                  SizedBox(height: AppDimensions.paddingL),
                  _buildWishlistActions(context, controller),
                ],
              ),
            ),

            // Main content - Wishlist items
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(AppDimensions.paddingL),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: AppDimensions.paddingL,
                  mainAxisSpacing: AppDimensions.paddingL,
                ),
                itemCount: controller.wishlistItems.length,
                itemBuilder: (context, index) {
                  final product = controller.wishlistItems[index];
                  return _buildWishlistCard(context, controller, product);
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildEmptyWishlist(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80.sp,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
          SizedBox(height: AppDimensions.paddingL),
          Text(
            context.tr('empty_wishlist_title'),
            style: AppTextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppDimensions.paddingM),
          Text(
            context.tr('empty_wishlist_subtitle'),
            style: AppTextStyles.bodyMedium.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppDimensions.paddingXL),
          ElevatedButton.icon(
            onPressed: () {
              Get.toNamed('/products');
            },
            icon: const Icon(Icons.shopping_bag),
            label: Text(context.tr('browse_products')),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingXL,
                vertical: AppDimensions.paddingM,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistSummary(
    BuildContext context,
    WishlistController controller,
  ) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      margin: EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.surfaceDark
            : AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.shadowDark
                : AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr('total_items'),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
              Text(
                '${controller.wishlistItems.length}',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                context.tr('estimated_total'),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
              ),
              Text(
                '${controller.totalValue} تومان',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistActions(
    BuildContext context,
    WishlistController controller,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            onPressed: () => controller.addAllToCart(),
            icon: const Icon(Icons.shopping_cart),
            label: Text(context.tr('add_all_to_cart')),
          ),
          SizedBox(height: AppDimensions.paddingM),
          OutlinedButton.icon(
            onPressed: () => controller.shareWishlist(),
            icon: const Icon(Icons.share),
            label: Text(context.tr('share_wishlist')),
          ),
          SizedBox(height: AppDimensions.paddingM),
          OutlinedButton.icon(
            onPressed: () => controller.clearWishlist(),
            icon: const Icon(Icons.clear_all),
            label: Text(context.tr('clear_wishlist')),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: BorderSide(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistItem(
    BuildContext context,
    WishlistController controller,
    Product product,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppColors.shadowDark : AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingM),
        child: Row(
          children: [
            // Product Image
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                color: AppColors.grey100,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                child: Image.network(
                  product.images.first,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.image,
                      size: 40.sp,
                      color: AppColors.grey400,
                    );
                  },
                ),
              ),
            ),

            SizedBox(width: AppDimensions.paddingM),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    product.brand,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Text(
                        '${product.price.toStringAsFixed(0)} تومان',
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      if (product.originalPrice != null) ...[
                        SizedBox(width: 8.w),
                        Text(
                          '${product.originalPrice!.toStringAsFixed(0)} تومان',
                          style: AppTextStyles.bodySmall.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: AppColors.grey500,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Actions
            Column(
              children: [
                IconButton(
                  onPressed: () => controller.removeFromWishlist(product.id),
                  icon: const Icon(Icons.favorite),
                  color: AppColors.error,
                ),
                IconButton(
                  onPressed: () => controller.addToCart(product),
                  icon: const Icon(Icons.shopping_cart_outlined),
                  color: AppColors.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWishlistCard(
    BuildContext context,
    WishlistController controller,
    Product product,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppColors.shadowDark : AppColors.shadowLight,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppDimensions.radiusL),
                      topRight: Radius.circular(AppDimensions.radiusL),
                    ),
                    color: AppColors.grey100,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppDimensions.radiusL),
                      topRight: Radius.circular(AppDimensions.radiusL),
                    ),
                    child: Image.network(
                      product.images.first,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.image,
                          size: 40.sp,
                          color: AppColors.grey400,
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 8.h,
                  right: 8.w,
                  child: IconButton(
                    onPressed: () => controller.removeFromWishlist(product.id),
                    icon: const Icon(Icons.favorite),
                    color: AppColors.error,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Product Details
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.paddingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    product.brand,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${product.price.toStringAsFixed(0)} تومان',
                            style: AppTextStyles.titleMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          if (product.originalPrice != null)
                            Text(
                              '${product.originalPrice!.toStringAsFixed(0)} تومان',
                              style: AppTextStyles.bodySmall.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: AppColors.grey500,
                              ),
                            ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => controller.addToCart(product),
                        icon: const Icon(Icons.shopping_cart_outlined),
                        color: AppColors.primary,
                        style: IconButton.styleFrom(
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(
    BuildContext context,
    WishlistController controller,
  ) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.surfaceDark
            : AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => controller.clearWishlist(),
                child: Text(context.tr('clear_all')),
              ),
            ),
            SizedBox(width: AppDimensions.paddingM),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () => controller.addAllToCart(),
                child: Text(context.tr('add_all_to_cart')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
