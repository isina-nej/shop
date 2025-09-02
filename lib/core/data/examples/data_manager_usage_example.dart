import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../data_manager.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';
import '../../../../core/localization/localization_extension.dart';

/// Example of how to use the DataManager in your app
class DataManagerExample extends StatefulWidget {
  const DataManagerExample({super.key});

  @override
  State<DataManagerExample> createState() => _DataManagerExampleState();
}

class _DataManagerExampleState extends State<DataManagerExample> {
  final DataManager _dataManager = DataManager.instance;
  List<ProductModel> _products = [];
  List<ProductModel> _featuredProducts = [];
  UserModel? _currentUser;
  bool _isLoading = false;
  String _status = '';

  @override
  void initState() {
    super.initState();
    _loadExampleData();
  }

  Future<void> _loadExampleData() async {
    setState(() {
      _isLoading = true;
      _status = context.tr('dm_loading_data');
    });

    try {
      // 1. Get all products
      final productsResponse = await _dataManager.getProducts();
      if (productsResponse.success) {
        _products = productsResponse.data;
        setState(() {
          _status = context
              .tr('dm_products_loaded')
              .replaceAll('{count}', '${_products.length}');
        });
      }

      // 2. Get featured products
      final featuredResponse = await _dataManager.getFeaturedProducts();
      if (featuredResponse.success) {
        _featuredProducts = featuredResponse.data;
        setState(() {
          _status +=
              '\n${context.tr('dm_featured_products').replaceAll('{count}', '${_featuredProducts.length}')}';
        });
      }

      // 3. Get a specific user
      final userResponse = await _dataManager.getUser('user_1');
      if (userResponse.success && userResponse.data != null) {
        _currentUser = userResponse.data;
        setState(() {
          _status +=
              '\n${context.tr('dm_user_loaded').replaceAll('{name}', '${_currentUser!.profile.firstName} ${_currentUser!.profile.lastName}')}';
        });
      }

      // 4. Search for products
      final searchResponse = await _dataManager.searchProducts('آیفون');
      setState(() {
        _status +=
            '\n${context.tr('dm_search_results').replaceAll('{query}', 'آیفون').replaceAll('{count}', '${searchResponse.data.length}')}';
      });

      // 5. Get product stats
      final productStatsResponse = await _dataManager.getProductStats();
      if (productStatsResponse.success) {
        final stats = productStatsResponse.data;
        setState(() {
          _status +=
              '\n${context.tr('dm_product_stats').replaceAll('{0}', '${stats['totalProducts']}').replaceAll('{1}', '${stats['totalCategories']}')}';
        });
      }

      setState(() {
        _isLoading = false;
        _status += '\n\n${context.tr('dm_all_data_loaded_success')}';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _status = context.tr('dm_error').replaceAll('{0}', e.toString());
      });
    }
  }

  Future<void> _testSearchAndFilter() async {
    setState(() {
      _status = context.tr('dm_testing_search_filters');
    });

    try {
      // Search in category
      final electronicProducts = await _dataManager.getProducts(
        categoryId: 'electronics',
        limit: 5,
      );
      setState(() {
        _status = context
            .tr('dm_category_results')
            .replaceAll('{count}', '${electronicProducts.data.length}');
      });

      // Search by price range
      final expensiveProducts = await _dataManager.getProducts(
        minPrice: 1000000,
        maxPrice: 5000000,
        limit: 5,
      );
      setState(() {
        _status +=
            '\n${context.tr('dm_expensive_products').replaceAll('{count}', '${expensiveProducts.data.length}')}';
      });

      // Get best sellers
      final bestSellers = await _dataManager.getBestSellers(limit: 3);
      setState(() {
        _status +=
            '\n${context.tr('dm_best_sellers').replaceAll('{count}', '${bestSellers.data.length}')}';
      });

      // Get products on sale
      final saleProducts = await _dataManager.getProductsOnSale(limit: 3);
      setState(() {
        _status +=
            '\n${context.tr('dm_on_sale').replaceAll('{count}', '${saleProducts.data.length}')}';
      });

      setState(() {
        _status += '\n\n${context.tr('dm_tests_successful')}';
      });
    } catch (e) {
      setState(() {
        _status = context.tr('dm_test_error').replaceAll('{0}', e.toString());
      });
    }
  }

  Future<void> _testUserOperations() async {
    setState(() {
      _status = context.tr('dm_testing_user_operations');
    });

    try {
      // Get all users
      final usersResponse = await _dataManager.getUsers();
      setState(() {
        _status = context
            .tr('dm_all_users')
            .replaceAll('{0}', '${usersResponse.data.length}');
      });

      // Search users
      final searchUsers = await _dataManager.searchUsers('علی');
      setState(() {
        _status +=
            '\n${context.tr('dm_search_users').replaceAll('{0}', 'علی').replaceAll('{1}', '${searchUsers.data.length}')}';
      });

      // Get premium users
      final premiumUsers = await _dataManager.getPremiumUsers();
      setState(() {
        _status +=
            '\n${context.tr('dm_premium_users').replaceAll('{0}', '${premiumUsers.data.length}')}';
      });

      // Remove getUserStatistics call as it doesn't exist

      setState(() {
        _status += '\n\n${context.tr('dm_user_ops_successful')}';
      });
    } catch (e) {
      setState(() {
        _status = context
            .tr('dm_user_ops_error')
            .replaceAll('{0}', e.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.tr('data_manager_example_title'))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _status.isEmpty ? context.tr('dm_ready_to_start') : _status,
                style: TextStyle(fontFamily: 'monospace'),
              ),
            ),

            SizedBox(height: 20.0.h),

            // Action Buttons
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ElevatedButton(
                  onPressed: _isLoading ? null : _loadExampleData,
                  child: Text(context.tr('dm_btn_load_data')),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _testSearchAndFilter,
                  child: Text(context.tr('dm_btn_test_search_filters')),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _testUserOperations,
                  child: Text(context.tr('dm_btn_test_user_ops')),
                ),
              ],
            ),

            if (_isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: CircularProgressIndicator()),
              ),

            SizedBox(height: 30.0.h),

            // Products Preview
            if (_products.isNotEmpty) ...[
              Text(
                context
                    .tr('dm_products_count')
                    .replaceAll('{0}', '${_products.length}'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 10.0.h),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _products.take(5).length,
                  itemBuilder: (context, index) {
                    final product = _products[index];
                    return Container(
                      width: 100,
                      margin: EdgeInsets.only(left: 10),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 12.0.sp),
                              ),
                              const Spacer(),
                              Text(
                                product.formattedPrice,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10.0.sp,
                                ),
                              ),
                              Text(
                                '⭐ ${product.rating.average}',
                                style: TextStyle(fontSize: 10.0.sp),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],

            SizedBox(height: 20.0.h),

            // Current User Info
            if (_currentUser != null) ...[
              Text(
                context.tr('dm_current_user'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 10.0.h),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_currentUser!.profile.firstName} ${_currentUser!.profile.lastName}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0.sp,
                        ),
                      ),
                      Text('${context.tr('email')}: ${_currentUser!.email}'),
                      Text(
                        '${context.tr('phone')}: ${_currentUser!.profile.phoneNumber}',
                      ),
                      Text(
                        '${context.tr('account_type')}: ${_currentUser!.account.accountType}',
                      ),
                      Text(
                        '${context.tr('loyalty_points')}: ${_currentUser!.loyalty.currentPoints}',
                      ),
                      Text(
                        '${context.tr('dm_last_login')}: ${_currentUser!.activity.lastLoginAt.toString().substring(0, 10)}',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Simple example of using DataManager methods
class SimpleDataExample {
  static final DataManager _dataManager = DataManager.instance;

  /// Get products with pagination
  static Future<void> getProductsExample() async {
    final response = await _dataManager.getProducts(
      page: 1,
      limit: 10,
      categoryId: 'electronics',
    );

    if (response.success) {
      debugPrint('محصولات یافت شده: ${response.data.length}');
      for (final product in response.data) {
        debugPrint('- ${product.name}: ${product.formattedPrice}');
      }
    } else {
      debugPrint('خطا: ${response.message}');
    }
  }

  /// Search products by query
  static Future<void> searchProductsExample() async {
    final response = await _dataManager.searchProducts(
      'آیفون',
      page: 1,
      limit: 5,
    );

    debugPrint('نتایج جستجو: ${response.data.length}');
    for (final product in response.data) {
      debugPrint('- ${product.name}');
    }
  }

  /// Get user information
  static Future<void> getUserExample() async {
    final response = await _dataManager.getUser('user_1');

    if (response.success && response.data != null) {
      final user = response.data!;
      debugPrint('کاربر: ${user.profile.firstName} ${user.profile.lastName}');
      debugPrint('ایمیل: ${user.email}');
      debugPrint('امتیاز وفاداری: ${user.loyalty.currentPoints}');
    }
  }

  /// Get product statistics
  static Future<void> getProductStatsExample() async {
    final response = await _dataManager.getProductStats();

    if (response.success) {
      final stats = response.data;
      debugPrint('آمار کلی:');
      debugPrint('- محصولات: ${stats['totalProducts']}');
      debugPrint('- دسته‌بندی‌ها: ${stats['totalCategories']}');
      debugPrint('- برندها: ${stats['totalBrands']}');
    }
  }

  /// Get featured products
  static Future<void> getFeaturedProductsExample() async {
    final response = await _dataManager.getFeaturedProducts(limit: 3);

    debugPrint('محصولات ویژه:');
    for (final product in response.data) {
      debugPrint('- ${product.name}: ${product.formattedPrice}');
    }
  }

  /// Filter products by price range
  static Future<void> filterByPriceExample() async {
    final response = await _dataManager.getProducts(
      minPrice: 500000, // 500k تومان
      maxPrice: 2000000, // 2M تومان
      limit: 10,
    );

    debugPrint('محصولات در بازه قیمتی:');
    for (final product in response.data) {
      debugPrint('- ${product.name}: ${product.formattedPrice}');
    }
  }

  /// Get products on sale
  static Future<void> getSaleProductsExample() async {
    final response = await _dataManager.getProductsOnSale(limit: 5);

    debugPrint('محصولات حراجی:');
    for (final product in response.data) {
      debugPrint(
        '- ${product.name}: ${product.formattedPrice} (${product.discountPercentage.toInt()}% تخفیف)',
      );
    }
  }

  /// Get search suggestions
  static Future<void> getSearchSuggestionsExample() async {
    final response = await _dataManager.getSearchSuggestions('موب');

    if (response.success) {
      debugPrint('پیشنهادات جستجو:');
      for (final suggestion in response.data) {
        debugPrint('- $suggestion');
      }
    }
  }

  /// Check system health
  static Future<void> checkSystemHealthExample() async {
    final response = await _dataManager.getSystemHealth();

    if (response.success) {
      final health = response.data;
      debugPrint('وضعیت سیستم:');
      debugPrint('- API: ${health['apiStatus']}');
      debugPrint('- دیتابیس: ${health['databaseStatus']}');
      debugPrint('- حافظه: ${health['memoryUsage']}');
      debugPrint('- درخواست‌ها: ${health['requestCount']}');
    }
  }
}
