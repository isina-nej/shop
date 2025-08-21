// Core Models for Shop App
import 'package:flutter/material.dart';

// Product Model
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final List<String> images;
  final String category;
  final String brand;
  final double rating;
  final int reviewsCount;
  final bool isInStock;
  final bool isFeatured;
  final bool isOnSale;
  final List<String> colors;
  final List<String> sizes;
  final Map<String, String> specifications;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.images,
    required this.category,
    required this.brand,
    required this.rating,
    required this.reviewsCount,
    required this.isInStock,
    this.isFeatured = false,
    this.isOnSale = false,
    this.colors = const [],
    this.sizes = const [],
    this.specifications = const {},
  });

  // Calculate discount percentage
  double? get discountPercentage {
    if (originalPrice != null && originalPrice! > price) {
      return ((originalPrice! - price) / originalPrice!) * 100;
    }
    return null;
  }

  // Format price with currency
  String get formattedPrice =>
      '${price.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} تومان';

  String? get formattedOriginalPrice => originalPrice != null
      ? '${originalPrice!.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} تومان'
      : null;
}

// Category Model
class Category {
  final String id;
  final String name;
  final String description;
  final String image;
  final IconData icon;
  final Color color;
  final int productsCount;
  final bool isActive;

  const Category({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.icon,
    required this.color,
    required this.productsCount,
    this.isActive = true,
  });
}

// Cart Item Model
class CartItem {
  final String id;
  final Product product;
  final int quantity;
  final String? selectedColor;
  final String? selectedSize;
  final DateTime addedAt;

  const CartItem({
    required this.id,
    required this.product,
    required this.quantity,
    this.selectedColor,
    this.selectedSize,
    required this.addedAt,
  });

  double get totalPrice => product.price * quantity;

  String get formattedTotalPrice =>
      '${totalPrice.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} تومان';

  CartItem copyWith({
    String? id,
    Product? product,
    int? quantity,
    String? selectedColor,
    String? selectedSize,
    DateTime? addedAt,
  }) {
    return CartItem(
      id: id ?? this.id,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      selectedColor: selectedColor ?? this.selectedColor,
      selectedSize: selectedSize ?? this.selectedSize,
      addedAt: addedAt ?? this.addedAt,
    );
  }
}

// Filter Options
enum ProductSortOption {
  newest,
  oldest,
  priceLowToHigh,
  priceHighToLow,
  rating,
  popular,
}

class ProductFilter {
  final List<String> categories;
  final List<String> brands;
  final double? minPrice;
  final double? maxPrice;
  final double? minRating;
  final bool? inStockOnly;
  final bool? onSaleOnly;
  final ProductSortOption sortBy;

  const ProductFilter({
    this.categories = const [],
    this.brands = const [],
    this.minPrice,
    this.maxPrice,
    this.minRating,
    this.inStockOnly,
    this.onSaleOnly,
    this.sortBy = ProductSortOption.newest,
  });

  ProductFilter copyWith({
    List<String>? categories,
    List<String>? brands,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    bool? inStockOnly,
    bool? onSaleOnly,
    ProductSortOption? sortBy,
  }) {
    return ProductFilter(
      categories: categories ?? this.categories,
      brands: brands ?? this.brands,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minRating: minRating ?? this.minRating,
      inStockOnly: inStockOnly ?? this.inStockOnly,
      onSaleOnly: onSaleOnly ?? this.onSaleOnly,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}
