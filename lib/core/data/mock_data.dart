import 'package:flutter/material.dart';
import '../models/shop_models.dart';

class MockData {
  static const List<Category> categories = [
    Category(
      id: 'fashion',
      name: 'پوشاک و مد',
      description: 'لباس، کفش و اکسسوری',
      image:
          'https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=400',
      icon: Icons.checkroom,
      color: Color(0xFFE91E63),
      productsCount: 156,
    ),
    Category(
      id: 'home',
      name: 'خانه و باغ',
      description: 'لوازم خانگی، دکوراسیون و باغبانی',
      image:
          'https://images.unsplash.com/photo-1586023492125-27b2c045efd7?w=400',
      icon: Icons.home,
      color: Color(0xFF4CAF50),
      productsCount: 142,
    ),
    Category(
      id: 'beauty',
      name: 'زیبایی و سلامت',
      description: 'آرایشی، بهداشتی و مراقبت شخصی',
      image:
          'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=400',
      icon: Icons.spa,
      color: Color(0xFFFF9800),
      productsCount: 98,
    ),
    Category(
      id: 'sports',
      name: 'ورزش و تفریح',
      description: 'لوازم ورزشی، کفش و پوشاک ورزشی',
      image:
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=400',
      icon: Icons.sports_soccer,
      color: Color(0xFF9C27B0),
      productsCount: 87,
    ),
    Category(
      id: 'books',
      name: 'کتاب و مطالعه',
      description: 'کتاب، مجله و لوازم‌التحریر',
      image:
          'https://images.unsplash.com/photo-1481627834876-b7833e8f5570?w=400',
      icon: Icons.menu_book,
      color: Color(0xFF795548),
      productsCount: 67,
    ),
  ];

  static const List<Product> products = [
    Product(
      id: 'p1',
      name: 'تی‌شرت مردانه کلاسیک',
      description: 'تی‌شرت با کیفیت از جنس پنبه ۱۰۰٪',
      price: 29.99,
      originalPrice: 39.99,
      images: [
        'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400',
      ],
      category: 'fashion',
      brand: 'FashionBrand',
      rating: 4.5,
      reviewsCount: 128,
      isInStock: true,
      isOnSale: true,
    ),
    Product(
      id: 'p2',
      name: 'کفش کتانی اسپرت',
      description: 'کفش راحت برای پیاده‌روی و ورزش',
      price: 79.99,
      images: [
        'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=400',
      ],
      category: 'fashion',
      brand: 'SportWear',
      rating: 4.8,
      reviewsCount: 256,
      isInStock: true,
      isOnSale: false,
    ),
    Product(
      id: 'p3',
      name: 'لامپ رومیزی مدرن',
      description: 'لامپ زیبا و مدرن برای دکوراسیون منزل',
      price: 45.00,
      images: [
        'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400',
      ],
      category: 'home',
      brand: 'HomeDecor',
      rating: 4.3,
      reviewsCount: 67,
      isInStock: true,
      isOnSale: false,
    ),
    Product(
      id: 'p4',
      name: 'کرم مرطوب‌کننده صورت',
      description: 'کرم طبیعی برای مراقبت از پوست',
      price: 22.50,
      originalPrice: 30.00,
      images: [
        'https://images.unsplash.com/photo-1556228578-dd6e4e5d5b2c?w=400',
      ],
      category: 'beauty',
      brand: 'BeautyPlus',
      rating: 4.6,
      reviewsCount: 89,
      isInStock: true,
      isOnSale: true,
    ),
    Product(
      id: 'p5',
      name: 'توپ فوتبال حرفه‌ای',
      description: 'توپ با کیفیت برای بازی‌های حرفه‌ای',
      price: 35.99,
      images: [
        'https://images.unsplash.com/photo-1571068316344-75bc76f77890?w=400',
      ],
      category: 'sports',
      brand: 'SportsPro',
      rating: 4.4,
      reviewsCount: 143,
      isInStock: true,
      isOnSale: false,
    ),
    Product(
      id: 'p6',
      name: 'کتاب آموزش برنامه‌نویسی',
      description: 'راهنمای کامل یادگیری برنامه‌نویسی',
      price: 18.99,
      images: [
        'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400',
      ],
      category: 'books',
      brand: 'TechBooks',
      rating: 4.7,
      reviewsCount: 201,
      isInStock: true,
      isOnSale: false,
    ),
  ];

  // Get products by category
  static List<Product> getProductsByCategory(String categoryId) {
    return products.where((product) => product.category == categoryId).toList();
  }

  // Get featured products
  static List<Product> getFeaturedProducts() {
    try {
      return products
          .where((product) => product.rating >= 4.5)
          .take(6)
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Get sale products
  static List<Product> getSaleProducts() {
    try {
      return products.where((product) => product.isOnSale).toList();
    } catch (e) {
      return [];
    }
  }

  // Search products
  static List<Product> searchProducts(String query) {
    if (query.isEmpty) return products;

    final searchTerm = query.toLowerCase();
    return products
        .where(
          (product) =>
              product.name.toLowerCase().contains(searchTerm) ||
              product.description.toLowerCase().contains(searchTerm) ||
              product.brand.toLowerCase().contains(searchTerm) ||
              product.category.toLowerCase().contains(searchTerm),
        )
        .toList();
  }

  // Get category by ID
  static Category? getCategoryById(String id) {
    try {
      return categories.firstWhere((cat) => cat.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get product by ID
  static Product? getProductById(String id) {
    try {
      return products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get cart items for testing
  static List<CartItem> getCartItems() {
    final now = DateTime.now();
    return [
      CartItem(
        id: 'c1',
        product: products[0],
        quantity: 2,
        addedAt: now.subtract(const Duration(days: 1)),
      ),
      CartItem(
        id: 'c2',
        product: products[1],
        quantity: 1,
        addedAt: now.subtract(const Duration(hours: 3)),
      ),
      CartItem(
        id: 'c3',
        product: products[5],
        quantity: 3,
        addedAt: now.subtract(const Duration(minutes: 30)),
      ),
    ];
  }

  // Filter products by criteria
  static List<Product> filterProducts(ProductFilter filter) {
    return products.where((product) {
      // Category filter
      if (filter.categories.isNotEmpty &&
          !filter.categories.contains(product.category)) {
        return false;
      }

      // Brand filter
      if (filter.brands.isNotEmpty && !filter.brands.contains(product.brand)) {
        return false;
      }

      // Price range
      if (filter.minPrice != null && product.price < filter.minPrice!) {
        return false;
      }
      if (filter.maxPrice != null && product.price > filter.maxPrice!) {
        return false;
      }

      // Rating filter
      if (filter.minRating != null && product.rating < filter.minRating!) {
        return false;
      }

      // Stock filter
      if (filter.inStockOnly == true && !product.isInStock) {
        return false;
      }

      // Sale filter
      if (filter.onSaleOnly == true && !product.isOnSale) {
        return false;
      }

      return true;
    }).toList();
  }
}
