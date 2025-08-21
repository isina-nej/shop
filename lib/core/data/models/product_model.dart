class ProductModel {
  final String id;
  final String name;
  final String brand;
  final String model;
  final String description;
  final List<String> shortDescriptions;
  final double price;
  final double originalPrice;
  final String currency;
  final List<ProductImage> images;
  final List<ProductColor> availableColors;
  final List<ProductSize> availableSizes;
  final String categoryId;
  final String categoryName;
  final List<String> subCategories;
  final ProductRating rating;
  final ProductReviews reviews;
  final ProductSpecifications specifications;
  final ProductInventory inventory;
  final ProductShipping shipping;
  final ProductSales salesInfo;
  final List<String> tags;
  final ProductSEO seo;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final bool isFeatured;
  final bool isNewArrival;
  final bool isBestSeller;
  final ProductWarranty warranty;
  final List<String> relatedProductIds;
  final List<ProductVariant> variants;

  const ProductModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.model,
    required this.description,
    required this.shortDescriptions,
    required this.price,
    required this.originalPrice,
    required this.currency,
    required this.images,
    required this.availableColors,
    required this.availableSizes,
    required this.categoryId,
    required this.categoryName,
    required this.subCategories,
    required this.rating,
    required this.reviews,
    required this.specifications,
    required this.inventory,
    required this.shipping,
    required this.salesInfo,
    required this.tags,
    required this.seo,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
    required this.isFeatured,
    required this.isNewArrival,
    required this.isBestSeller,
    required this.warranty,
    required this.relatedProductIds,
    required this.variants,
  });

  // Calculate discount percentage
  double get discountPercentage {
    if (originalPrice > price) {
      return ((originalPrice - price) / originalPrice) * 100;
    }
    return 0;
  }

  // Check if product is on sale
  bool get isOnSale => originalPrice > price;

  // Get main image
  String get mainImage => images.isNotEmpty ? images.first.url : '';

  // Check if product is in stock
  bool get isInStock => inventory.availableStock > 0;

  // Get stock quantity
  int get stockQuantity => inventory.availableStock;

  // Format price with currency
  String get formattedPrice => '${formatCurrency(price)} $currency';
  String get formattedOriginalPrice =>
      '${formatCurrency(originalPrice)} $currency';

  String formatCurrency(double amount) {
    return amount.toInt().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'model': model,
      'description': description,
      'shortDescriptions': shortDescriptions,
      'price': price,
      'originalPrice': originalPrice,
      'currency': currency,
      'images': images.map((img) => img.toJson()).toList(),
      'availableColors': availableColors
          .map((color) => color.toJson())
          .toList(),
      'availableSizes': availableSizes.map((size) => size.toJson()).toList(),
      'categoryId': categoryId,
      'categoryName': categoryName,
      'subCategories': subCategories,
      'rating': rating.toJson(),
      'reviews': reviews.toJson(),
      'specifications': specifications.toJson(),
      'inventory': inventory.toJson(),
      'shipping': shipping.toJson(),
      'salesInfo': salesInfo.toJson(),
      'tags': tags,
      'seo': seo.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isActive': isActive,
      'isFeatured': isFeatured,
      'isNewArrival': isNewArrival,
      'isBestSeller': isBestSeller,
      'warranty': warranty.toJson(),
      'relatedProductIds': relatedProductIds,
      'variants': variants.map((variant) => variant.toJson()).toList(),
    };
  }
}

class ProductImage {
  final String id;
  final String url;
  final String altText;
  final bool isPrimary;
  final String colorVariant;
  final int order;

  const ProductImage({
    required this.id,
    required this.url,
    required this.altText,
    required this.isPrimary,
    required this.colorVariant,
    required this.order,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'altText': altText,
      'isPrimary': isPrimary,
      'colorVariant': colorVariant,
      'order': order,
    };
  }
}

class ProductColor {
  final String id;
  final String name;
  final String hexCode;
  final String imageUrl;
  final bool isAvailable;

  const ProductColor({
    required this.id,
    required this.name,
    required this.hexCode,
    required this.imageUrl,
    required this.isAvailable,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'hexCode': hexCode,
      'imageUrl': imageUrl,
      'isAvailable': isAvailable,
    };
  }
}

class ProductSize {
  final String id;
  final String name;
  final String value;
  final String unit;
  final bool isAvailable;
  final int stockCount;

  const ProductSize({
    required this.id,
    required this.name,
    required this.value,
    required this.unit,
    required this.isAvailable,
    required this.stockCount,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'value': value,
      'unit': unit,
      'isAvailable': isAvailable,
      'stockCount': stockCount,
    };
  }
}

class ProductRating {
  final double average;
  final int totalReviews;
  final Map<int, int> starDistribution; // star => count
  final double qualityRating;
  final double valueRating;
  final double shippingRating;

  const ProductRating({
    required this.average,
    required this.totalReviews,
    required this.starDistribution,
    required this.qualityRating,
    required this.valueRating,
    required this.shippingRating,
  });

  Map<String, dynamic> toJson() {
    return {
      'average': average,
      'totalReviews': totalReviews,
      'starDistribution': starDistribution,
      'qualityRating': qualityRating,
      'valueRating': valueRating,
      'shippingRating': shippingRating,
    };
  }
}

class ProductReviews {
  final int totalCount;
  final List<ProductReview> latestReviews;
  final int verifiedPurchases;
  final int recommendationCount;

  const ProductReviews({
    required this.totalCount,
    required this.latestReviews,
    required this.verifiedPurchases,
    required this.recommendationCount,
  });

  Map<String, dynamic> toJson() {
    return {
      'totalCount': totalCount,
      'latestReviews': latestReviews.map((review) => review.toJson()).toList(),
      'verifiedPurchases': verifiedPurchases,
      'recommendationCount': recommendationCount,
    };
  }
}

class ProductReview {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final int rating;
  final String title;
  final String comment;
  final List<String> images;
  final bool isVerifiedPurchase;
  final bool isRecommended;
  final int helpfulVotes;
  final DateTime createdAt;
  final List<String> pros;
  final List<String> cons;

  const ProductReview({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.rating,
    required this.title,
    required this.comment,
    required this.images,
    required this.isVerifiedPurchase,
    required this.isRecommended,
    required this.helpfulVotes,
    required this.createdAt,
    required this.pros,
    required this.cons,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'rating': rating,
      'title': title,
      'comment': comment,
      'images': images,
      'isVerifiedPurchase': isVerifiedPurchase,
      'isRecommended': isRecommended,
      'helpfulVotes': helpfulVotes,
      'createdAt': createdAt.toIso8601String(),
      'pros': pros,
      'cons': cons,
    };
  }
}

class ProductSpecifications {
  final Map<String, String> general;
  final Map<String, String> technical;
  final Map<String, String> physical;
  final Map<String, String> additional;

  const ProductSpecifications({
    required this.general,
    required this.technical,
    required this.physical,
    required this.additional,
  });

  // Get all specifications as a flat map
  Map<String, String> get entries {
    final Map<String, String> allSpecs = {};
    allSpecs.addAll(general);
    allSpecs.addAll(technical);
    allSpecs.addAll(physical);
    allSpecs.addAll(additional);
    return allSpecs;
  }

  Map<String, dynamic> toJson() {
    return {
      'general': general,
      'technical': technical,
      'physical': physical,
      'additional': additional,
    };
  }
}

class ProductInventory {
  final int totalStock;
  final int availableStock;
  final int reservedStock;
  final int soldCount;
  final String stockStatus; // in_stock, low_stock, out_of_stock
  final int lowStockThreshold;
  final Map<String, int> variantStock; // colorId-sizeId => count

  const ProductInventory({
    required this.totalStock,
    required this.availableStock,
    required this.reservedStock,
    required this.soldCount,
    required this.stockStatus,
    required this.lowStockThreshold,
    required this.variantStock,
  });

  Map<String, dynamic> toJson() {
    return {
      'totalStock': totalStock,
      'availableStock': availableStock,
      'reservedStock': reservedStock,
      'soldCount': soldCount,
      'stockStatus': stockStatus,
      'lowStockThreshold': lowStockThreshold,
      'variantStock': variantStock,
    };
  }
}

class ProductShipping {
  final double weight;
  final ProductDimensions dimensions;
  final bool freeShipping;
  final double shippingCost;
  final int estimatedDeliveryDays;
  final List<String> shippingMethods;
  final List<String> availableRegions;

  const ProductShipping({
    required this.weight,
    required this.dimensions,
    required this.freeShipping,
    required this.shippingCost,
    required this.estimatedDeliveryDays,
    required this.shippingMethods,
    required this.availableRegions,
  });

  Map<String, dynamic> toJson() {
    return {
      'weight': weight,
      'dimensions': dimensions.toJson(),
      'freeShipping': freeShipping,
      'shippingCost': shippingCost,
      'estimatedDeliveryDays': estimatedDeliveryDays,
      'shippingMethods': shippingMethods,
      'availableRegions': availableRegions,
    };
  }
}

class ProductDimensions {
  final double length;
  final double width;
  final double height;
  final String unit;

  const ProductDimensions({
    required this.length,
    required this.width,
    required this.height,
    required this.unit,
  });

  Map<String, dynamic> toJson() {
    return {'length': length, 'width': width, 'height': height, 'unit': unit};
  }
}

class ProductSales {
  final int totalSold;
  final int monthlySales;
  final int weeklySales;
  final double revenue;
  final int viewCount;
  final int wishlistCount;
  final int cartAddCount;
  final double conversionRate;

  const ProductSales({
    required this.totalSold,
    required this.monthlySales,
    required this.weeklySales,
    required this.revenue,
    required this.viewCount,
    required this.wishlistCount,
    required this.cartAddCount,
    required this.conversionRate,
  });

  Map<String, dynamic> toJson() {
    return {
      'totalSold': totalSold,
      'monthlySales': monthlySales,
      'weeklySales': weeklySales,
      'revenue': revenue,
      'viewCount': viewCount,
      'wishlistCount': wishlistCount,
      'cartAddCount': cartAddCount,
      'conversionRate': conversionRate,
    };
  }
}

class ProductSEO {
  final String metaTitle;
  final String metaDescription;
  final List<String> keywords;
  final String slug;
  final String canonicalUrl;
  final Map<String, String> openGraph;

  const ProductSEO({
    required this.metaTitle,
    required this.metaDescription,
    required this.keywords,
    required this.slug,
    required this.canonicalUrl,
    required this.openGraph,
  });

  Map<String, dynamic> toJson() {
    return {
      'metaTitle': metaTitle,
      'metaDescription': metaDescription,
      'keywords': keywords,
      'slug': slug,
      'canonicalUrl': canonicalUrl,
      'openGraph': openGraph,
    };
  }
}

class ProductWarranty {
  final bool hasWarranty;
  final int durationMonths;
  final String type;
  final String description;
  final String provider;

  const ProductWarranty({
    required this.hasWarranty,
    required this.durationMonths,
    required this.type,
    required this.description,
    required this.provider,
  });

  Map<String, dynamic> toJson() {
    return {
      'hasWarranty': hasWarranty,
      'durationMonths': durationMonths,
      'type': type,
      'description': description,
      'provider': provider,
    };
  }
}

class ProductVariant {
  final String id;
  final String colorId;
  final String sizeId;
  final String sku;
  final double price;
  final int stock;
  final List<String> images;

  const ProductVariant({
    required this.id,
    required this.colorId,
    required this.sizeId,
    required this.sku,
    required this.price,
    required this.stock,
    required this.images,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'colorId': colorId,
      'sizeId': sizeId,
      'sku': sku,
      'price': price,
      'stock': stock,
      'images': images,
    };
  }
}
