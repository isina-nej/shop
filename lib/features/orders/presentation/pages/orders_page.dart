// Orders Page
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/localization/localization_extension.dart';
import '../../../../core/utils/responsive_utils.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _orderStatuses = [
    'all',
    'pending',
    'processing',
    'shipped',
    'delivered',
    'cancelled',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _orderStatuses.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _buildMobileLayout(context),
      tablet: _buildTabletLayout(context),
      desktop: _buildDesktopLayout(context),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('orders')),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.textSecondaryDark
              : AppColors.textSecondaryLight,
          tabs: _orderStatuses.map((status) {
            return Tab(text: context.tr('order_status_$status'));
          }).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _orderStatuses.map((status) {
          return _buildOrdersList(context, status);
        }).toList(),
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return _buildMobileLayout(context);
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr('orders')),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Row(
        children: [
          // Left sidebar with order status filters
          Container(
            width: 200.w,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.surfaceDark
                : AppColors.white,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(AppDimensions.paddingM),
                  child: Text(
                    context.tr('order_status'),
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _orderStatuses.length,
                    itemBuilder: (context, index) {
                      final status = _orderStatuses[index];
                      return ListTile(
                        title: Text(context.tr('order_status_$status')),
                        onTap: () {
                          _tabController.animateTo(index);
                        },
                        selected: _tabController.index == index,
                        selectedTileColor: AppColors.primary.withOpacity(0.1),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // Main content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: _orderStatuses.map((status) {
                return _buildOrdersList(context, status);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList(BuildContext context, String status) {
    // Mock data - replace with actual data from controller
    final mockOrders = _getMockOrders(status);

    if (mockOrders.isEmpty) {
      return _buildEmptyState(context, status);
    }

    return ListView.builder(
      padding: EdgeInsets.all(AppDimensions.paddingM),
      itemCount: mockOrders.length,
      itemBuilder: (context, index) {
        final order = mockOrders[index];
        return _buildOrderCard(context, order);
      },
    );
  }

  Widget _buildOrderCard(BuildContext context, Map<String, dynamic> order) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppColors.shadowDark : AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Order Header
          Container(
            padding: EdgeInsets.all(AppDimensions.paddingM),
            decoration: BoxDecoration(
              color: _getStatusColor(order['status']).withOpacity(0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppDimensions.radiusL),
                topRight: Radius.circular(AppDimensions.radiusL),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${context.tr('order')} #${order['id']}',
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      order['date'],
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingM,
                    vertical: AppDimensions.paddingS,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order['status']),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                  ),
                  child: Text(
                    context.tr('order_status_${order['status']}'),
                    style: AppTextStyles.labelSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Order Items
          Padding(
            padding: EdgeInsets.all(AppDimensions.paddingM),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${order['itemCount']} ${context.tr('items')}',
                      style: AppTextStyles.bodyMedium,
                    ),
                    Text(
                      '${order['total']} تومان',
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppDimensions.paddingM),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => _showOrderDetails(context, order),
                        child: Text(context.tr('view_details')),
                      ),
                    ),
                    SizedBox(width: AppDimensions.paddingM),
                    if (order['status'] == 'pending') ...[
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _cancelOrder(context, order),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.error,
                          ),
                          child: Text(context.tr('cancel_order')),
                        ),
                      ),
                    ] else if (order['status'] == 'delivered') ...[
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _reorderItems(context, order),
                          child: Text(context.tr('reorder')),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String status) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 80.sp,
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
          SizedBox(height: AppDimensions.paddingL),
          Text(
            context.tr('no_orders_${status == 'all' ? 'found' : status}'),
            style: AppTextStyles.titleMedium.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppDimensions.paddingM),
          Text(
            context.tr('start_shopping_to_see_orders'),
            style: AppTextStyles.bodyMedium.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondaryLight,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppDimensions.paddingXL),
          ElevatedButton(
            onPressed: () {
              Get.toNamed('/products');
            },
            child: Text(context.tr('browse_products')),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return AppColors.warning;
      case 'processing':
        return AppColors.info;
      case 'shipped':
        return AppColors.primary;
      case 'delivered':
        return AppColors.success;
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.grey500;
    }
  }

  List<Map<String, dynamic>> _getMockOrders(String status) {
    final allOrders = [
      {
        'id': '12345',
        'date': '۱۵ آذر ۱۴۰۲',
        'status': 'delivered',
        'itemCount': 3,
        'total': '۲,۴۵۰,۰۰۰',
      },
      {
        'id': '12346',
        'date': '۱۰ آذر ۱۴۰۲',
        'status': 'shipped',
        'itemCount': 1,
        'total': '۸۹۰,۰۰۰',
      },
      {
        'id': '12347',
        'date': '۵ آذر ۱۴۰۲',
        'status': 'processing',
        'itemCount': 2,
        'total': '۱,۲۳۰,۰۰۰',
      },
      {
        'id': '12348',
        'date': '۱ آذر ۱۴۰۲',
        'status': 'pending',
        'itemCount': 5,
        'total': '۳,۲۸۰,۰۰۰',
      },
    ];

    if (status == 'all') {
      return allOrders;
    }

    return allOrders.where((order) => order['status'] == status).toList();
  }

  void _showOrderDetails(BuildContext context, Map<String, dynamic> order) {
    // Navigate to order details page
    Get.toNamed('/order-details', arguments: order);
  }

  void _cancelOrder(BuildContext context, Map<String, dynamic> order) {
    Get.dialog(
      AlertDialog(
        title: Text(context.tr('cancel_order')),
        content: Text(context.tr('cancel_order_confirmation')),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(context.tr('no')),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                context.tr('success'),
                context.tr('order_cancelled_successfully'),
                backgroundColor: AppColors.success,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(context.tr('yes_cancel')),
          ),
        ],
      ),
    );
  }

  void _reorderItems(BuildContext context, Map<String, dynamic> order) {
    Get.snackbar(
      context.tr('success'),
      context.tr('items_added_to_cart'),
      backgroundColor: AppColors.success,
      colorText: Colors.white,
    );
  }
}
