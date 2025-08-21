// Cart Page - Shopping Cart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/localization/localization_extension.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/models/shop_models.dart';
import '../../../../core/data/mock_data.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> _cartItems = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  void _loadCartItems() {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _cartItems = MockData.getCartItems();
        _isLoading = false;
      });
    });
  }

  double get _subtotal {
    return _cartItems.fold(
      0,
      (total, item) => total + (item.product.price * item.quantity),
    );
  }

  double get _tax {
    return _subtotal * 0.1; // 10% tax
  }

  double get _shipping {
    return _subtotal > 100 ? 0 : 10; // Free shipping over $100
  }

  double get _total {
    return _subtotal + _tax + _shipping;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: _buildAppBar(context),
      body: ResponsiveUtils.isMobile(context)
          ? _buildMobileLayout(context)
          : _buildDesktopLayout(context),
      bottomNavigationBar: _cartItems.isNotEmpty
          ? _buildBottomBar(context)
          : null,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
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
      actions: _cartItems.isNotEmpty
          ? [
              TextButton(
                onPressed: _showClearCartDialog,
                child: Text(
                  context.tr('clear_all'),
                  style: TextStyle(color: AppColors.error),
                ),
              ),
            ]
          : null,
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_cartItems.isEmpty) {
      return _buildEmptyCart(context);
    }

    return Column(
      children: [
        // Cart Items List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            itemCount: _cartItems.length,
            itemBuilder: (context, index) {
              return _buildCartItem(context, _cartItems[index]);
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
          child: _buildOrderSummary(context),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_cartItems.isEmpty) {
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
                  '${context.tr('your_cart')} (${_cartItems.length} ${context.tr('items')})',
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingL),
                Expanded(
                  child: ListView.builder(
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      return _buildCartItem(context, _cartItems[index]);
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
                _buildOrderSummary(context),
                const SizedBox(height: AppDimensions.paddingL),
                _buildCheckoutButton(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCartItem(BuildContext context, CartItem item) {
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
                            onPressed: () =>
                                _updateQuantity(item, item.quantity - 1),
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
                            onPressed: () =>
                                _updateQuantity(item, item.quantity + 1),
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
              onPressed: () => _removeItem(item),
              icon: Icon(Icons.delete_outline, color: AppColors.error),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context) {
    return Column(
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
          value: '\$${_subtotal.toStringAsFixed(2)}',
        ),

        // Tax
        _buildSummaryRow(
          context,
          label: context.tr('tax'),
          value: '\$${_tax.toStringAsFixed(2)}',
        ),

        // Shipping
        _buildSummaryRow(
          context,
          label: context.tr('shipping'),
          value: _shipping == 0
              ? context.tr('free')
              : '\$${_shipping.toStringAsFixed(2)}',
        ),

        if (_shipping == 0) ...[
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
          value: '\$${_total.toStringAsFixed(2)}',
          isTotal: true,
        ),
      ],
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

  Widget _buildBottomBar(BuildContext context) {
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
                  Text(
                    '\$${_total.toStringAsFixed(2)}',
                    style: AppTextStyles.headlineSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppDimensions.paddingM),
            Expanded(child: _buildCheckoutButton(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutButton(BuildContext context) {
    return ElevatedButton(
      onPressed: _cartItems.isNotEmpty ? _proceedToCheckout : null,
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

  void _updateQuantity(CartItem item, int newQuantity) {
    if (newQuantity <= 0) {
      _removeItem(item);
      return;
    }

    setState(() {
      final index = _cartItems.indexWhere(
        (cartItem) => cartItem.product.id == item.product.id,
      );
      if (index != -1) {
        _cartItems[index] = item.copyWith(quantity: newQuantity);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.tr('cart_updated')),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _removeItem(CartItem item) {
    setState(() {
      _cartItems.removeWhere(
        (cartItem) => cartItem.product.id == item.product.id,
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.tr('item_removed_from_cart')),
        action: SnackBarAction(
          label: context.tr('undo'),
          onPressed: () {
            setState(() {
              _cartItems.add(item);
            });
          },
        ),
      ),
    );
  }

  void _showClearCartDialog() {
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
              setState(() {
                _cartItems.clear();
              });
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

  void _proceedToCheckout() {
    // TODO: Implement checkout functionality
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(context.tr('checkout_coming_soon'))));
  }
}
