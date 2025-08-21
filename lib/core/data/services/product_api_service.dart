import '../models/product_model.dart';
import '../test_data/product_test_data.dart';

/// Product API Service - Simulates real API calls
class ProductApiService {
  // Simulate network delay
  static Future<void> _simulateDelay([int milliseconds = 500]) async {
    await Future.delayed(Duration(milliseconds: milliseconds));
  }

  /// Get all products with pagination
  static Future<ApiResponse<List<ProductModel>>> getAllProducts({
    int page = 1,
    int limit = 20,
    String? sortBy,
    String? sortOrder = 'asc',
  }) async {
    await _simulateDelay();

    try {
      var products = ProductTestData.getAllProducts();

      // Apply sorting
      if (sortBy != null) {
        products = _sortProducts(products, sortBy, sortOrder == 'desc');
      }

      // Apply pagination
      final startIndex = (page - 1) * limit;
      final endIndex = startIndex + limit;

      final paginatedProducts = products.length > startIndex
          ? products.sublist(
              startIndex,
              endIndex > products.length ? products.length : endIndex,
            )
          : <ProductModel>[];

      return ApiResponse<List<ProductModel>>(
        data: paginatedProducts,
        success: true,
        message: 'محصولات با موفقیت بارگذاری شد',
        metadata: {
          'totalCount': products.length,
          'currentPage': page,
          'totalPages': (products.length / limit).ceil(),
          'hasNextPage': endIndex < products.length,
          'hasPreviousPage': page > 1,
        },
      );
    } catch (e) {
      return ApiResponse<List<ProductModel>>(
        data: [],
        success: false,
        message: 'خطا در بارگذاری محصولات: ${e.toString()}',
        errorCode: 'PRODUCTS_FETCH_ERROR',
      );
    }
  }

  /// Get product by ID
  static Future<ApiResponse<ProductModel?>> getProductById(String id) async {
    await _simulateDelay(300);

    try {
      final product = ProductTestData.getProductById(id);

      if (product != null) {
        return ApiResponse<ProductModel?>(
          data: product,
          success: true,
          message: 'محصول با موفقیت بارگذاری شد',
        );
      } else {
        return ApiResponse<ProductModel?>(
          data: null,
          success: false,
          message: 'محصول مورد نظر یافت نشد',
          errorCode: 'PRODUCT_NOT_FOUND',
        );
      }
    } catch (e) {
      return ApiResponse<ProductModel?>(
        data: null,
        success: false,
        message: 'خطا در بارگذاری محصول: ${e.toString()}',
        errorCode: 'PRODUCT_FETCH_ERROR',
      );
    }
  }

  /// Search products
  static Future<ApiResponse<List<ProductModel>>> searchProducts(
    String query, {
    int page = 1,
    int limit = 20,
    String? categoryId,
    String? brand,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    List<String>? colors,
    List<String>? sizes,
    bool? inStockOnly,
    String? sortBy,
    String? sortOrder = 'asc',
  }) async {
    await _simulateDelay(800);

    try {
      List<ProductModel> products;

      if (query.trim().isEmpty) {
        products = ProductTestData.getAllProducts();
      } else {
        products = ProductTestData.searchProducts(query);
      }

      // Apply filters
      products = ProductTestData.filterProducts(
        categoryId: categoryId,
        brand: brand,
        minPrice: minPrice,
        maxPrice: maxPrice,
        minRating: minRating,
        colors: colors,
        sizes: sizes,
        inStockOnly: inStockOnly,
      );

      // Apply sorting
      if (sortBy != null) {
        products = _sortProducts(products, sortBy, sortOrder == 'desc');
      }

      // Apply pagination
      final startIndex = (page - 1) * limit;
      final endIndex = startIndex + limit;

      final paginatedProducts = products.length > startIndex
          ? products.sublist(
              startIndex,
              endIndex > products.length ? products.length : endIndex,
            )
          : <ProductModel>[];

      return ApiResponse<List<ProductModel>>(
        data: paginatedProducts,
        success: true,
        message: 'نتایج جستجو با موفقیت بارگذاری شد',
        metadata: {
          'query': query,
          'totalCount': products.length,
          'currentPage': page,
          'totalPages': (products.length / limit).ceil(),
          'hasNextPage': endIndex < products.length,
          'hasPreviousPage': page > 1,
          'appliedFilters': {
            'categoryId': categoryId,
            'brand': brand,
            'minPrice': minPrice,
            'maxPrice': maxPrice,
            'minRating': minRating,
            'colors': colors,
            'sizes': sizes,
            'inStockOnly': inStockOnly,
          },
        },
      );
    } catch (e) {
      return ApiResponse<List<ProductModel>>(
        data: [],
        success: false,
        message: 'خطا در جستجوی محصولات: ${e.toString()}',
        errorCode: 'SEARCH_ERROR',
      );
    }
  }

  /// Get products by category
  static Future<ApiResponse<List<ProductModel>>> getProductsByCategory(
    String categoryId, {
    int page = 1,
    int limit = 20,
    String? sortBy,
    String? sortOrder = 'asc',
  }) async {
    await _simulateDelay(600);

    try {
      var products = ProductTestData.getProductsByCategory(categoryId);

      // Apply sorting
      if (sortBy != null) {
        products = _sortProducts(products, sortBy, sortOrder == 'desc');
      }

      // Apply pagination
      final startIndex = (page - 1) * limit;
      final endIndex = startIndex + limit;

      final paginatedProducts = products.length > startIndex
          ? products.sublist(
              startIndex,
              endIndex > products.length ? products.length : endIndex,
            )
          : <ProductModel>[];

      return ApiResponse<List<ProductModel>>(
        data: paginatedProducts,
        success: true,
        message: 'محصولات دسته‌بندی با موفقیت بارگذاری شد',
        metadata: {
          'categoryId': categoryId,
          'totalCount': products.length,
          'currentPage': page,
          'totalPages': (products.length / limit).ceil(),
          'hasNextPage': endIndex < products.length,
          'hasPreviousPage': page > 1,
        },
      );
    } catch (e) {
      return ApiResponse<List<ProductModel>>(
        data: [],
        success: false,
        message: 'خطا در بارگذاری محصولات دسته‌بندی: ${e.toString()}',
        errorCode: 'CATEGORY_PRODUCTS_ERROR',
      );
    }
  }

  /// Get featured products
  static Future<ApiResponse<List<ProductModel>>> getFeaturedProducts({
    int limit = 10,
  }) async {
    await _simulateDelay(400);

    try {
      final products = ProductTestData.getFeaturedProducts()
          .take(limit)
          .toList();

      return ApiResponse<List<ProductModel>>(
        data: products,
        success: true,
        message: 'محصولات ویژه با موفقیت بارگذاری شد',
        metadata: {'count': products.length},
      );
    } catch (e) {
      return ApiResponse<List<ProductModel>>(
        data: [],
        success: false,
        message: 'خطا در بارگذاری محصولات ویژه: ${e.toString()}',
        errorCode: 'FEATURED_PRODUCTS_ERROR',
      );
    }
  }

  /// Get best sellers
  static Future<ApiResponse<List<ProductModel>>> getBestSellers({
    int limit = 10,
  }) async {
    await _simulateDelay(400);

    try {
      final products = ProductTestData.getBestSellers().take(limit).toList();

      return ApiResponse<List<ProductModel>>(
        data: products,
        success: true,
        message: 'پرفروش‌ترین محصولات با موفقیت بارگذاری شد',
        metadata: {'count': products.length},
      );
    } catch (e) {
      return ApiResponse<List<ProductModel>>(
        data: [],
        success: false,
        message: 'خطا در بارگذاری پرفروش‌ترین محصولات: ${e.toString()}',
        errorCode: 'BESTSELLERS_ERROR',
      );
    }
  }

  /// Get new arrivals
  static Future<ApiResponse<List<ProductModel>>> getNewArrivals({
    int limit = 10,
  }) async {
    await _simulateDelay(400);

    try {
      final products = ProductTestData.getNewArrivals().take(limit).toList();

      return ApiResponse<List<ProductModel>>(
        data: products,
        success: true,
        message: 'جدیدترین محصولات با موفقیت بارگذاری شد',
        metadata: {'count': products.length},
      );
    } catch (e) {
      return ApiResponse<List<ProductModel>>(
        data: [],
        success: false,
        message: 'خطا در بارگذاری جدیدترین محصولات: ${e.toString()}',
        errorCode: 'NEW_ARRIVALS_ERROR',
      );
    }
  }

  /// Get products on sale
  static Future<ApiResponse<List<ProductModel>>> getProductsOnSale({
    int limit = 10,
  }) async {
    await _simulateDelay(400);

    try {
      final products = ProductTestData.getProductsOnSale().take(limit).toList();

      return ApiResponse<List<ProductModel>>(
        data: products,
        success: true,
        message: 'محصولات تخفیف‌دار با موفقیت بارگذاری شد',
        metadata: {'count': products.length},
      );
    } catch (e) {
      return ApiResponse<List<ProductModel>>(
        data: [],
        success: false,
        message: 'خطا در بارگذاری محصولات تخفیف‌دار: ${e.toString()}',
        errorCode: 'SALE_PRODUCTS_ERROR',
      );
    }
  }

  /// Get related products
  static Future<ApiResponse<List<ProductModel>>> getRelatedProducts(
    String productId, {
    int limit = 8,
  }) async {
    await _simulateDelay(300);

    try {
      final products = ProductTestData.getRelatedProducts(
        productId,
      ).take(limit).toList();

      return ApiResponse<List<ProductModel>>(
        data: products,
        success: true,
        message: 'محصولات مرتبط با موفقیت بارگذاری شد',
        metadata: {'count': products.length, 'productId': productId},
      );
    } catch (e) {
      return ApiResponse<List<ProductModel>>(
        data: [],
        success: false,
        message: 'خطا در بارگذاری محصولات مرتبط: ${e.toString()}',
        errorCode: 'RELATED_PRODUCTS_ERROR',
      );
    }
  }

  /// Get product stats
  static Future<ApiResponse<Map<String, dynamic>>> getProductStats() async {
    await _simulateDelay(200);

    try {
      final stats = ProductTestData.getProductStats();

      return ApiResponse<Map<String, dynamic>>(
        data: stats,
        success: true,
        message: 'آمار محصولات با موفقیت بارگذاری شد',
      );
    } catch (e) {
      return ApiResponse<Map<String, dynamic>>(
        data: {},
        success: false,
        message: 'خطا در بارگذاری آمار محصولات: ${e.toString()}',
        errorCode: 'STATS_ERROR',
      );
    }
  }

  /// Get available filters for products
  static Future<ApiResponse<Map<String, dynamic>>> getAvailableFilters() async {
    await _simulateDelay(200);

    try {
      final products = ProductTestData.getAllProducts();

      final categories = products
          .map((p) => {'id': p.categoryId, 'name': p.categoryName})
          .toSet()
          .toList();

      final brands = products.map((p) => p.brand).toSet().toList();

      final colors = products
          .expand((p) => p.availableColors)
          .where((c) => c.isAvailable)
          .map((c) => {'id': c.id, 'name': c.name, 'hex': c.hexCode})
          .toSet()
          .toList();

      final sizes = products
          .expand((p) => p.availableSizes)
          .where((s) => s.isAvailable)
          .map((s) => {'id': s.id, 'name': s.name, 'value': s.value})
          .toSet()
          .toList();

      final priceRange = {
        'min': products.map((p) => p.price).reduce((a, b) => a < b ? a : b),
        'max': products.map((p) => p.price).reduce((a, b) => a > b ? a : b),
      };

      return ApiResponse<Map<String, dynamic>>(
        data: {
          'categories': categories,
          'brands': brands,
          'colors': colors,
          'sizes': sizes,
          'priceRange': priceRange,
        },
        success: true,
        message: 'فیلترهای موجود با موفقیت بارگذاری شد',
      );
    } catch (e) {
      return ApiResponse<Map<String, dynamic>>(
        data: {},
        success: false,
        message: 'خطا در بارگذاری فیلترها: ${e.toString()}',
        errorCode: 'FILTERS_ERROR',
      );
    }
  }

  // Helper method to sort products
  static List<ProductModel> _sortProducts(
    List<ProductModel> products,
    String sortBy,
    bool descending,
  ) {
    final sortedProducts = List<ProductModel>.from(products);

    switch (sortBy.toLowerCase()) {
      case 'name':
        sortedProducts.sort(
          (a, b) =>
              descending ? b.name.compareTo(a.name) : a.name.compareTo(b.name),
        );
        break;
      case 'price':
        sortedProducts.sort(
          (a, b) => descending
              ? b.price.compareTo(a.price)
              : a.price.compareTo(b.price),
        );
        break;
      case 'rating':
        sortedProducts.sort(
          (a, b) => descending
              ? b.rating.average.compareTo(a.rating.average)
              : a.rating.average.compareTo(b.rating.average),
        );
        break;
      case 'popularity':
        sortedProducts.sort(
          (a, b) => descending
              ? b.salesInfo.totalSold.compareTo(a.salesInfo.totalSold)
              : a.salesInfo.totalSold.compareTo(b.salesInfo.totalSold),
        );
        break;
      case 'newest':
        sortedProducts.sort(
          (a, b) => descending
              ? b.createdAt.compareTo(a.createdAt)
              : a.createdAt.compareTo(b.createdAt),
        );
        break;
      case 'discount':
        sortedProducts.sort(
          (a, b) => descending
              ? b.discountPercentage.compareTo(a.discountPercentage)
              : a.discountPercentage.compareTo(b.discountPercentage),
        );
        break;
      default:
        // Default sort by name
        sortedProducts.sort(
          (a, b) =>
              descending ? b.name.compareTo(a.name) : a.name.compareTo(b.name),
        );
        break;
    }

    return sortedProducts;
  }
}

/// Generic API Response class
class ApiResponse<T> {
  final T data;
  final bool success;
  final String message;
  final String? errorCode;
  final Map<String, dynamic>? metadata;
  final DateTime timestamp;

  ApiResponse({
    required this.data,
    required this.success,
    required this.message,
    this.errorCode,
    this.metadata,
  }) : timestamp = DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'success': success,
      'message': message,
      'errorCode': errorCode,
      'metadata': metadata,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
