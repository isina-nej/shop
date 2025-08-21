import 'models/product_model.dart';
import 'models/user_model.dart';
import 'services/product_api_service.dart';
import 'services/user_api_service.dart';

/// Unified Data Manager - Main API interface for the app
/// Acts as a single point of access for all data operations
class DataManager {
  static final DataManager _instance = DataManager._internal();
  factory DataManager() => _instance;
  DataManager._internal();

  // Singleton instance getter
  static DataManager get instance => _instance;

  // ==================== PRODUCT OPERATIONS ====================

  /// Get all products with optional filters and pagination
  Future<ApiResponse<List<ProductModel>>> getProducts({
    int page = 1,
    int limit = 20,
    String? categoryId,
    String? brand,
    String? query,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    List<String>? colors,
    List<String>? sizes,
    bool? inStockOnly,
    String? sortBy,
    String? sortOrder = 'asc',
  }) async {
    if (query != null && query.isNotEmpty) {
      return await ProductApiService.searchProducts(
        query,
        page: page,
        limit: limit,
        categoryId: categoryId,
        brand: brand,
        minPrice: minPrice,
        maxPrice: maxPrice,
        minRating: minRating,
        colors: colors,
        sizes: sizes,
        inStockOnly: inStockOnly,
        sortBy: sortBy,
        sortOrder: sortOrder,
      );
    } else if (categoryId != null) {
      return await ProductApiService.getProductsByCategory(
        categoryId,
        page: page,
        limit: limit,
        sortBy: sortBy,
        sortOrder: sortOrder,
      );
    } else {
      return await ProductApiService.getAllProducts(
        page: page,
        limit: limit,
        sortBy: sortBy,
        sortOrder: sortOrder,
      );
    }
  }

  /// Get a single product by ID
  Future<ApiResponse<ProductModel?>> getProduct(String id) async {
    return await ProductApiService.getProductById(id);
  }

  /// Get a single product by ID (alias for getProduct)
  Future<ApiResponse<ProductModel?>> getProductById(String id) async {
    return await getProduct(id);
  }

  /// Search products by query
  Future<ApiResponse<List<ProductModel>>> searchProducts(
    String query, {
    Map<String, dynamic>? filters,
    int page = 1,
    int limit = 20,
  }) async {
    return await ProductApiService.searchProducts(
      query,
      page: page,
      limit: limit,
      categoryId: filters?['categoryId'],
      brand: filters?['brand'],
      minPrice: filters?['minPrice'],
      maxPrice: filters?['maxPrice'],
      minRating: filters?['minRating'],
      colors: filters?['colors'],
      sizes: filters?['sizes'],
      inStockOnly: filters?['inStockOnly'],
      sortBy: filters?['sortBy'],
      sortOrder: filters?['sortOrder'],
    );
  }

  /// Get products by category
  Future<ApiResponse<List<ProductModel>>> getProductsByCategory(
    String categoryId, {
    int page = 1,
    int limit = 20,
    String? sortBy,
    String? sortOrder = 'asc',
  }) async {
    return await ProductApiService.getProductsByCategory(
      categoryId,
      page: page,
      limit: limit,
      sortBy: sortBy,
      sortOrder: sortOrder,
    );
  }

  /// Get featured products for homepage
  Future<ApiResponse<List<ProductModel>>> getFeaturedProducts({
    int limit = 10,
  }) async {
    return await ProductApiService.getFeaturedProducts(limit: limit);
  }

  /// Get best selling products
  Future<ApiResponse<List<ProductModel>>> getBestSellers({
    int limit = 10,
  }) async {
    return await ProductApiService.getBestSellers(limit: limit);
  }

  /// Get new arrival products
  Future<ApiResponse<List<ProductModel>>> getNewArrivals({
    int limit = 10,
  }) async {
    return await ProductApiService.getNewArrivals(limit: limit);
  }

  /// Get products on sale
  Future<ApiResponse<List<ProductModel>>> getProductsOnSale({
    int limit = 10,
  }) async {
    return await ProductApiService.getProductsOnSale(limit: limit);
  }

  /// Get related products for a given product
  Future<ApiResponse<List<ProductModel>>> getRelatedProducts(
    String productId, {
    int limit = 8,
  }) async {
    return await ProductApiService.getRelatedProducts(productId, limit: limit);
  }

  /// Get available filters for product filtering
  Future<ApiResponse<Map<String, dynamic>>> getProductFilters() async {
    return await ProductApiService.getAvailableFilters();
  }

  /// Get product statistics
  Future<ApiResponse<Map<String, dynamic>>> getProductStats() async {
    return await ProductApiService.getProductStats();
  }

  // ==================== USER OPERATIONS ====================

  /// Get all users (Admin only)
  Future<ApiResponse<List<UserModel>>> getUsers({
    int page = 1,
    int limit = 20,
    String? sortBy,
    String? sortOrder = 'asc',
  }) async {
    return await UserApiService.getAllUsers(
      page: page,
      limit: limit,
      sortBy: sortBy,
      sortOrder: sortOrder,
    );
  }

  /// Get a single user by ID
  Future<ApiResponse<UserModel?>> getUser(String id) async {
    return await UserApiService.getUserById(id);
  }

  /// Get user by email
  Future<ApiResponse<UserModel?>> getUserByEmail(String email) async {
    return await UserApiService.getUserByEmail(email);
  }

  /// Get user by username
  Future<ApiResponse<UserModel?>> getUserByUsername(String username) async {
    return await UserApiService.getUserByUsername(username);
  }

  /// Search users (Admin only)
  Future<ApiResponse<List<UserModel>>> searchUsers(
    String query, {
    Map<String, dynamic>? filters,
    int page = 1,
    int limit = 20,
  }) async {
    return await UserApiService.searchUsers(
      query,
      page: page,
      limit: limit,
      accountType: filters?['accountType'],
      loyaltyTier: filters?['loyaltyTier'],
      city: filters?['city'],
      isPremium: filters?['isPremium'],
      isActive: filters?['isActive'],
      isVerified: filters?['isVerified'],
      sortBy: filters?['sortBy'],
      sortOrder: filters?['sortOrder'],
    );
  }

  /// Get premium users
  Future<ApiResponse<List<UserModel>>> getPremiumUsers({
    int page = 1,
    int limit = 20,
  }) async {
    return await UserApiService.getPremiumUsers(page: page, limit: limit);
  }

  /// Get new users
  Future<ApiResponse<List<UserModel>>> getNewUsers({
    int days = 30,
    int page = 1,
    int limit = 20,
  }) async {
    return await UserApiService.getNewUsers(
      days: days,
      page: page,
      limit: limit,
    );
  }

  /// Get users by loyalty tier
  Future<ApiResponse<List<UserModel>>> getUsersByLoyaltyTier(
    String tier, {
    int page = 1,
    int limit = 20,
  }) async {
    return await UserApiService.getUsersByLoyaltyTier(
      tier,
      page: page,
      limit: limit,
    );
  }

  /// Get top spending users
  Future<ApiResponse<List<UserModel>>> getTopSpenders({int limit = 10}) async {
    return await UserApiService.getTopSpenders(limit: limit);
  }

  /// Get most active users
  Future<ApiResponse<List<UserModel>>> getMostActiveUsers({
    int limit = 10,
  }) async {
    return await UserApiService.getMostActiveUsers(limit: limit);
  }

  /// Get user statistics
  Future<ApiResponse<Map<String, dynamic>>> getUserStats() async {
    return await UserApiService.getUserStats();
  }

  // ==================== AUTHENTICATION OPERATIONS ====================

  /// Authenticate user with email and password
  Future<ApiResponse<UserAuthResponse>> login(
    String email,
    String password,
  ) async {
    return await UserApiService.authenticateUser(email, password);
  }

  /// Register new user
  Future<ApiResponse<UserAuthResponse>> register({
    required String email,
    required String username,
    required String password,
    required String firstName,
    required String lastName,
    String? phoneNumber,
  }) async {
    return await UserApiService.registerUser(
      email: email,
      username: username,
      password: password,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
    );
  }

  /// Update user profile
  Future<ApiResponse<UserModel>> updateUserProfile(
    String userId,
    Map<String, dynamic> updates,
  ) async {
    return await UserApiService.updateUserProfile(userId, updates);
  }

  // ==================== DASHBOARD & ANALYTICS ====================

  /// Get dashboard data combining products and users stats
  Future<ApiResponse<Map<String, dynamic>>> getDashboardData() async {
    try {
      final productStatsResponse = await getProductStats();
      final userStatsResponse = await getUserStats();

      if (!productStatsResponse.success || !userStatsResponse.success) {
        return ApiResponse<Map<String, dynamic>>(
          data: {},
          success: false,
          message: 'خطا در بارگذاری اطلاعات داشبورد',
          errorCode: 'DASHBOARD_ERROR',
        );
      }

      // Get recent data
      final featuredProductsResponse = await getFeaturedProducts(limit: 5);
      final newUsersResponse = await getNewUsers(days: 7, limit: 5);
      final topSpendersResponse = await getTopSpenders(limit: 5);

      final dashboardData = {
        'overview': {
          'products': productStatsResponse.data,
          'users': userStatsResponse.data,
          'lastUpdated': DateTime.now().toIso8601String(),
        },
        'featuredProducts': featuredProductsResponse.success
            ? featuredProductsResponse.data
            : <ProductModel>[],
        'newUsers': newUsersResponse.success
            ? newUsersResponse.data
            : <UserModel>[],
        'topSpenders': topSpendersResponse.success
            ? topSpendersResponse.data
            : <UserModel>[],
      };

      return ApiResponse<Map<String, dynamic>>(
        data: dashboardData,
        success: true,
        message: 'اطلاعات داشبورد با موفقیت بارگذاری شد',
        metadata: {
          'generatedAt': DateTime.now().toIso8601String(),
          'dataVersion': '1.0',
        },
      );
    } catch (e) {
      return ApiResponse<Map<String, dynamic>>(
        data: {},
        success: false,
        message: 'خطا در تولید اطلاعات داشبورد: ${e.toString()}',
        errorCode: 'DASHBOARD_GENERATION_ERROR',
      );
    }
  }

  /// Get search suggestions based on products and categories
  Future<ApiResponse<List<String>>> getSearchSuggestions(
    String query, {
    int limit = 10,
  }) async {
    try {
      await Future.delayed(Duration(milliseconds: 200)); // Simulate API delay

      final suggestions = <String>[];
      final lowercaseQuery = query.toLowerCase();

      // Get product suggestions
      final productsResponse = await ProductApiService.getAllProducts(
        limit: 100,
      );
      if (productsResponse.success) {
        final products = productsResponse.data;

        // Add product names
        for (final product in products) {
          if (product.name.toLowerCase().contains(lowercaseQuery)) {
            suggestions.add(product.name);
          }
          if (product.brand.toLowerCase().contains(lowercaseQuery)) {
            suggestions.add(product.brand);
          }
          // Add category names
          if (product.categoryName.toLowerCase().contains(lowercaseQuery)) {
            suggestions.add(product.categoryName);
          }
        }
      }

      // Remove duplicates and limit results
      final uniqueSuggestions = suggestions.toSet().take(limit).toList();

      return ApiResponse<List<String>>(
        data: uniqueSuggestions,
        success: true,
        message: 'پیشنهادات جستجو با موفقیت بارگذاری شد',
        metadata: {'query': query, 'count': uniqueSuggestions.length},
      );
    } catch (e) {
      return ApiResponse<List<String>>(
        data: [],
        success: false,
        message: 'خطا در بارگذاری پیشنهادات جستجو: ${e.toString()}',
        errorCode: 'SUGGESTIONS_ERROR',
      );
    }
  }

  // ==================== UTILITY METHODS ====================

  /// Check system health
  Future<ApiResponse<Map<String, dynamic>>> getSystemHealth() async {
    try {
      final startTime = DateTime.now();

      // Test both services
      final productTest = await ProductApiService.getAllProducts(limit: 1);
      final userTest = await UserApiService.getAllUsers(limit: 1);

      final endTime = DateTime.now();
      final responseTime = endTime.difference(startTime).inMilliseconds;

      return ApiResponse<Map<String, dynamic>>(
        data: {
          'status': 'healthy',
          'services': {
            'productService': productTest.success ? 'healthy' : 'error',
            'userService': userTest.success ? 'healthy' : 'error',
          },
          'responseTime': responseTime,
          'timestamp': DateTime.now().toIso8601String(),
          'version': '1.0.0',
        },
        success: true,
        message: 'سیستم در حال اجرا است',
      );
    } catch (e) {
      return ApiResponse<Map<String, dynamic>>(
        data: {
          'status': 'error',
          'error': e.toString(),
          'timestamp': DateTime.now().toIso8601String(),
        },
        success: false,
        message: 'خطا در سیستم: ${e.toString()}',
        errorCode: 'SYSTEM_ERROR',
      );
    }
  }

  /// Initialize data manager (can be used for setup operations)
  Future<void> initialize() async {
    // Perform any initialization tasks here
    // For example: load configuration, setup cache, etc.
    print('DataManager initialized successfully');
  }

  /// Clear any cached data (useful for logout or refresh operations)
  Future<void> clearCache() async {
    // Clear any cached data here
    print('DataManager cache cleared');
  }
}
