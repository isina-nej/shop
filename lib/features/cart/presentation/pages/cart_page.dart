// Cart Page - Shopping Cart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/localization/localization_extension.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/models/shop_models.dart';
import '../cart_controller.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.put(CartController());

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: _buildAppBar(context, cartController),
      body: ResponsiveUtils.isMobile(context)
          ? _buildMobileLayout(context, cartController)
          : _buildDesktopLayout(context, cartController),
      bottomNavigationBar: Obx(
        () => cartController.cartItems.isNotEmpty
            ? _buildBottomBar(context, cartController)
            : const SizedBox.shrink(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    CartController cartController,
  ) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        context.tr('shopping_cart'),
        style: AppTextStyles.headlineMedium.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: cartController.cartItems.isNotEmpty
          ? [
              TextButton(
                onPressed: () => _showClearCartDialog(context, cartController),
                child: Text(
                  context.tr('clear_all'),
                  style: TextStyle(color: AppColors.error),
                ),
              ),
            ]
          : null,
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    CartController cartController,
  ) {
    return Obx(() {
      if (cartController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (cartController.cartItems.isEmpty) {
        return _buildEmptyCart(context);
      }

      return Column(
        children: [
          // Cart Items List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppDimensions.paddingM),
              itemCount: cartController.cartItems.length,
              itemBuilder: (context, index) {
                return _buildCartItem(
                  context,
                  cartController.cartItems[index],
                  cartController,
                );
              },
            ),
          ),

          // Order Summary
          Container(
            margin: const EdgeInsets.all(AppDimensions.paddingM),
            padding: const EdgeInsets.all(AppDimensions.paddingM),
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
                  offset: const Offset(0, 2),
                  blurRadius: 8,
                ),
              ],
            ),
            child: _buildOrderSummary(context, cartController),
          ),
        ],
      );
    });
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    CartController cartController,
  ) {
    return Obx(() {
      if (cartController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (cartController.cartItems.isEmpty) {
        return _buildEmptyCart(context);
      }

      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cart Items
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.paddingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${context.tr('your_cart')} (${cartController.cartItems.length} ${context.tr('items')})',
                    style: AppTextStyles.headlineSmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.paddingL),
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartController.cartItems.length,
                      itemBuilder: (context, index) {
                        return _buildCartItem(
                          context,
                          cartController.cartItems[index],
                          cartController,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Order Summary Sidebar
          Container(
            width: 400,
            padding: const EdgeInsets.all(AppDimensions.paddingL),
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.paddingL),
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
                    offset: const Offset(0, 2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildOrderSummary(context, cartController),
                  const SizedBox(height: AppDimensions.paddingL),
                  _buildCheckoutButton(context, cartController),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildCartItem(
    BuildContext context,
    CartItem item,
    CartController cartController,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingM),
      elevation: 2,
      shadowColor: isDark ? AppColors.shadowDark : AppColors.shadowLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingM),
        child: Row(
          children: [
            // Product Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                image: DecorationImage(
                  image: NetworkImage(item.product.images.first),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(width: AppDimensions.paddingM),

            // Product Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    item.product.brand,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price
                      Text(
                        item.product.formattedPrice,
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),

                      // Quantity Controls
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => _updateQuantity(
                              context,
                              item,
                              item.quantity - 1,
                              cartController,
                            ),
                            icon: const Icon(Icons.remove_circle_outline),
                            constraints: const BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          Container(
                            width: 40,
                            height: 32,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).dividerColor,
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${item.quantity}',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => _updateQuantity(
                              context,
                              item,
                              item.quantity + 1,
                              cartController,
                            ),
                            icon: const Icon(Icons.add_circle_outline),
                            constraints: const BoxConstraints(
                              minWidth: 32,
                              minHeight: 32,
                            ),
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Remove Button
            IconButton(
              onPressed: () => _removeItem(context, item, cartController),
              icon: Icon(Icons.delete_outline, color: AppColors.error),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(
    BuildContext context,
    CartController cartController,
  ) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.tr('order_summary'),
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingM),

          // Subtotal
          _buildSummaryRow(
            context,
            label: context.tr('subtotal'),
            value: '\$${cartController.subtotal.toStringAsFixed(2)}',
          ),

          // Tax
          _buildSummaryRow(
            context,
            label: context.tr('tax'),
            value: '\$${cartController.tax.toStringAsFixed(2)}',
          ),

          // Shipping
          _buildSummaryRow(
            context,
            label: context.tr('shipping'),
            value: cartController.shipping == 0
                ? context.tr('free')
                : '\$${cartController.shipping.toStringAsFixed(2)}',
          ),

          if (cartController.shipping == 0) ...[
            const SizedBox(height: 4),
            Text(
              context.tr('free_shipping_on_orders_over'),
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.success),
            ),
          ],

          const Divider(height: AppDimensions.paddingL),

          // Total
          _buildSummaryRow(
            context,
            label: context.tr('total'),
            value: '\$${cartController.total.toStringAsFixed(2)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context, {
    required String label,
    required String value,
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)
                : AppTextStyles.bodyMedium,
          ),
          Text(
            value,
            style: isTotal
                ? AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  )
                : AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 64,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
          const SizedBox(height: AppDimensions.paddingL),
          Text(
            context.tr('your_cart_is_empty'),
            style: AppTextStyles.headlineSmall.copyWith(
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingM),
          Text(
            context.tr('add_items_to_get_started'),
            style: AppTextStyles.bodyMedium.copyWith(
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.paddingL),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.tr('start_shopping')),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, CartController cartController) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.surfaceDark
            : AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.shadowDark
                : AppColors.shadowLight,
            offset: const Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.tr('total'),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                  Obx(
                    () => Text(
                      '\$${cartController.total.toStringAsFixed(2)}',
                      style: AppTextStyles.headlineSmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppDimensions.paddingM),
            Expanded(child: _buildCheckoutButton(context, cartController)),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutButton(
    BuildContext context,
    CartController cartController,
  ) {
    return ElevatedButton(
      onPressed: cartController.cartItems.isNotEmpty
          ? () => _proceedToCheckout(context)
          : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingM),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
      ),
      child: Text(
        context.tr('proceed_to_checkout'),
        style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }

  void _updateQuantity(
    BuildContext context,
    CartItem item,
    int newQuantity,
    CartController cartController,
  ) {
    cartController.updateQuantity(item, newQuantity);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.tr('cart_updated')),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _removeItem(
    BuildContext context,
    CartItem item,
    CartController cartController,
  ) {
    cartController.removeItem(item);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.tr('item_removed_from_cart')),
        action: SnackBarAction(
          label: context.tr('undo'),
          onPressed: () {
            cartController.addItem(item.product, quantity: item.quantity);
          },
        ),
      ),
    );
  }

  void _showClearCartDialog(
    BuildContext context,
    CartController cartController,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.tr('clear_cart')),
        content: Text(context.tr('are_you_sure_clear_cart')),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(context.tr('cancel')),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              cartController.clearCart();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(context.tr('cart_cleared'))),
              );
            },
            child: Text(
              context.tr('clear'),
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _proceedToCheckout(BuildContext context) {
    // TODO: Implement checkout functionality
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.tr('checkout_coming_soon'))));
  }
}
