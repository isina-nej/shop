import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../data_manager.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';
import '../../../core/localization/localization_extension.dart';

/// Fixed example of how to use the DataManager in your app
class DataManagerExampleFixed extends StatefulWidget {
  const DataManagerExampleFixed({super.key});

  @override
  State<DataManagerExampleFixed> createState() =>
      _DataManagerExampleFixedState();
}

class _DataManagerExampleFixedState extends State<DataManagerExampleFixed> {
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
      _status = 'در حال بارگذاری داده‌ها...';
    });

    try {
      // 1. Get all products
      final productsResponse = await _dataManager.getProducts();
      if (productsResponse.success) {
        _products = productsResponse.data;
        setState(() {
          _status = 'محصولات بارگذاری شدند: ${_products.length} محصول';
        });
      }

      // 2. Get featured products
      final featuredResponse = await _dataManager.getFeaturedProducts();
      if (featuredResponse.success) {
        _featuredProducts = featuredResponse.data;
        setState(() {
          _status += '\nمحصولات ویژه: ${_featuredProducts.length} محصول';
        });
      }

      // 3. Get a specific user
      final userResponse = await _dataManager.getUser('user_1');
      if (userResponse.success && userResponse.data != null) {
        _currentUser = userResponse.data;
        setState(() {
          _status +=
              '\nکاربر بارگذاری شد: ${_currentUser!.profile.firstName} ${_currentUser!.profile.lastName}';
        });
      }

      // 4. Search for products
      final searchResponse = await _dataManager.searchProducts('آیفون');
      setState(() {
        _status += '\nجستجوی آیفون: ${searchResponse.data.length} نتیجه';
      });

      // 5. Get product stats
      final productStatsResponse = await _dataManager.getProductStats();
      if (productStatsResponse.success) {
        final stats = productStatsResponse.data;
        setState(() {
          _status +=
              '\nآمار محصولات: ${stats['totalProducts']} محصول، ${stats['totalCategories']} دسته‌بندی';
        });
      }

      setState(() {
        _isLoading = false;
        _status += '\n\n✅ همه داده‌ها با موفقیت بارگذاری شدند!';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _status = 'خطا: ${e.toString()}';
      });
    }
  }

  Future<void> _testSearchAndFilter() async {
    setState(() {
      _status = 'تست جستجو و فیلترها...';
    });

    try {
      // Search in category
      final electronicProducts = await _dataManager.getProducts(
        categoryId: 'electronics',
        limit: 5,
      );
      setState(() {
        _status = 'محصولات الکترونیک: ${electronicProducts.data.length}';
      });

      // Search by price range
      final expensiveProducts = await _dataManager.getProducts(
        minPrice: 1000000,
        maxPrice: 5000000,
        limit: 5,
      );
      setState(() {
        _status += '\nمحصولات گران: ${expensiveProducts.data.length}';
      });

      // Get best sellers
      final bestSellers = await _dataManager.getBestSellers(limit: 3);
      setState(() {
        _status += '\nپرفروش‌ترین: ${bestSellers.data.length}';
      });

      // Get products on sale
      final saleProducts = await _dataManager.getProductsOnSale(limit: 3);
      setState(() {
        _status += '\nحراجی: ${saleProducts.data.length}';
      });

      setState(() {
        _status += '\n\n✅ تست‌ها با موفقیت اجرا شدند!';
      });
    } catch (e) {
      setState(() {
        _status = 'خطا در تست: ${e.toString()}';
      });
    }
  }

  Future<void> _testUserOperations() async {
    setState(() {
      _status = 'تست عملیات کاربری...';
    });

    try {
      // Get all users
      final usersResponse = await _dataManager.getUsers();
      setState(() {
        _status = 'تمام کاربران: ${usersResponse.data.length}';
      });

      // Search users
      final searchUsers = await _dataManager.searchUsers('علی');
      setState(() {
        _status += '\nجستجوی علی: ${searchUsers.data.length} نتیجه';
      });

      // Get premium users
      final premiumUsers = await _dataManager.getPremiumUsers();
      setState(() {
        _status += '\nکاربران ویژه: ${premiumUsers.data.length}';
      });

      // Remove getUserStatistics call as it doesn't exist

      setState(() {
        _status += '\n\n✅ عملیات کاربری با موفقیت اجرا شدند!';
      });
    } catch (e) {
      setState(() {
        _status = 'خطا در عملیات کاربری: ${e.toString()}';
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
                _status.isEmpty ? 'آماده برای شروع...' : _status,
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
                  child: Text(context.tr('load_data')),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _testSearchAndFilter,
                  child: Text(context.tr('test_search_and_filters')),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _testUserOperations,
                  child: Text(context.tr('test_user_operations')),
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
                    .tr('products_with_count')
                    .replaceAll('{count}', _products.length.toString()),
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
                context.tr('current_user'),
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
                      Text(
                        '${context.tr('email_label')}${_currentUser!.email}',
                      ),
                      Text(
                        '${context.tr('phone_label')}${_currentUser!.profile.phoneNumber ?? context.tr('unknown')}',
                      ),
                      Text(
                        '${context.tr('account_type_label')}${context.translateAccountType(_currentUser!.account.accountType)}',
                      ),
                      Text(
                        '${context.tr('points_label')}${_currentUser!.loyalty.currentPoints}',
                      ),
                      Text(
                        '${context.tr('last_login_label')}${_currentUser!.activity.lastLoginAt.toString().substring(0, 10)}',
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

/// Simple example methods for using DataManager
class SimpleDataExampleFixed {
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

  /// Get search suggestions (if method exists)
  static Future<void> getSearchSuggestionsExample() async {
    try {
      final response = await _dataManager.getSearchSuggestions('موب');

      if (response.success) {
        debugPrint('پیشنهادات جستجو:');
        for (final suggestion in response.data) {
          debugPrint('- $suggestion');
        }
      }
    } catch (e) {
      debugPrint('خطا در دریافت پیشنهادات: $e');
    }
  }

  /// Check system health (if method exists)
  static Future<void> checkSystemHealthExample() async {
    try {
      final response = await _dataManager.getSystemHealth();

      if (response.success) {
        final health = response.data;
        debugPrint('وضعیت سیستم:');
        debugPrint('- API: ${health['apiStatus']}');
        debugPrint('- دیتابیس: ${health['databaseStatus']}');
        debugPrint('- حافظه: ${health['memoryUsage']}');
        debugPrint('- درخواست‌ها: ${health['requestCount']}');
      }
    } catch (e) {
      debugPrint('خطا در بررسی سلامت سیستم: $e');
    }
  }
}
