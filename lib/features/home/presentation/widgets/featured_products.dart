// Featured Products Widget
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/routing/app_router.dart';
import '../../../../core/localization/localization_extension.dart';

class FeaturedProducts extends StatelessWidget {
  const FeaturedProducts({super.key});

  // Mock featured products data
  static const List<ProductModel> _featuredProducts = [
    ProductModel(
      id: '1',
      title: 'سامسونگ گلکسی S24',
      description: 'گوشی هوشمند سامسونگ با فناوری پیشرفته',
      price: 45000000,
      discountPrice: null,
      imageUrl: 'assets/images/products/samsung_galaxy.png',
      rating: 4.6,
      isOnSale: false,
    ),
    ProductModel(
      id: '2',
      title: 'لپ تاپ مک بوک ایر',
      description: 'لپ تاپ اپل پرقدرت برای کار و سرگرمی',
      price: 65000000,
      discountPrice: 59000000,
      imageUrl: 'assets/images/products/macbook_air.png',
      rating: 4.9,
      isOnSale: true,
    ),
    ProductModel(
      id: '3',
      title: 'فون بی سیم ایرپاد',
      description: 'هدفون بی‌سیم با کیفیت صدای فوق‌العاده',
      price: 12000000,
      discountPrice: null,
      imageUrl: 'assets/images/products/airpods.png',
      rating: 4.7,
      isOnSale: false,
    ),
    ProductModel(
      id: '4',
      title: 'ساعت هوشمند اپل',
      description: 'ساعت هوشمند اپل با امکانات پیشرفته',
      price: 18000000,
      discountPrice: 15000000,
      imageUrl: 'assets/images/products/apple_watch.png',
      rating: 4.8,
      isOnSale: true,
    ),
    ProductModel(
      id: '5',
      title: 'تبلت آیپد پرو',
      description: 'تبلت حرفه‌ای برای کارهای گرافیکی',
      price: 42000000,
      discountPrice: null,
      imageUrl: 'assets/images/products/ipad_pro.png',
      rating: 4.9,
      isOnSale: false,
    ),
    ProductModel(
      id: '6',
      title: 'دوربین کانن DSLR',
      description: 'دوربین دیجیتال حرفه‌ای برای عکاسی',
      price: 28000000,
      discountPrice: 24000000,
      imageUrl: 'assets/images/products/canon_dslr.png',
      rating: 4.7,
      isOnSale: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Products List
        SizedBox(
          height: 300,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingM,
            ),
            itemCount: _featuredProducts.length,
            itemBuilder: (context, index) {
              final product = _featuredProducts[index];
              return Container(
                width: 200,
                margin: EdgeInsets.only(
                  left: index < _featuredProducts.length - 1
                      ? AppDimensions.paddingM
                      : 0,
                ),
                child: _ProductCard(product: product),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductModel product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        // Navigate to product details
        Navigator.pushNamed(
          context,
          AppRouter.productDetails,
          arguments: {'productId': product.id},
        );
        debugPrint('Product selected: ${product.title}');
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          boxShadow: [
            BoxShadow(
              color: isDark ? AppColors.shadowDark : AppColors.shadowLight,
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image with Sale Badge
            Stack(
              children: [
                Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.grey200,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppDimensions.radiusM),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppDimensions.radiusM),
                    ),
                    child: _buildProductImage(product),
                  ),
                ),

                // Sale Badge
                if (product.isOnSale)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingS,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusS,
                        ),
                      ),
                      child: Text(
                        context.tr('discount'),
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                // Favorite Button
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      color: AppColors.grey600,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),

            // Product Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingS),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Title
                    Text(
                      product.title,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Rating
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: AppColors.warning,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          product.rating.toString(),
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.grey600,
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Price
                    if (product.discountPrice != null) ...[
                      Text(
                        '${_formatPrice(product.price)} تومان',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.grey500,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${_formatPrice(product.discountPrice!)} تومان',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.error,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ] else
                      Text(
                        '${_formatPrice(product.price)} تومان',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage(ProductModel product) {
    // Create a placeholder image based on product category
    Widget placeholder;

    switch (product.id) {
      case '1': // Samsung Galaxy
        placeholder = Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade100, Colors.blue.shade50],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.phone_android, size: 48, color: Colors.blue.shade600),
              const SizedBox(height: 8),
              Text(
                'Samsung',
                style: TextStyle(
                  color: Colors.blue.shade600,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
        break;
      case '2': // MacBook
        placeholder = Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey.shade100, Colors.grey.shade50],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.laptop_mac, size: 48, color: Colors.grey.shade700),
              const SizedBox(height: 8),
              Text(
                'MacBook',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
        break;
      case '3': // AirPods
        placeholder = Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.orange.shade100, Colors.orange.shade50],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.headphones, size: 48, color: Colors.orange.shade600),
              const SizedBox(height: 8),
              Text(
                'AirPods',
                style: TextStyle(
                  color: Colors.orange.shade600,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
        break;
      case '4': // Apple Watch
        placeholder = Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green.shade100, Colors.green.shade50],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.watch, size: 48, color: Colors.green.shade600),
              const SizedBox(height: 8),
              Text(
                'Watch',
                style: TextStyle(
                  color: Colors.green.shade600,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
        break;
      case '5': // iPad
        placeholder = Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple.shade100, Colors.purple.shade50],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.tablet_mac, size: 48, color: Colors.purple.shade600),
              const SizedBox(height: 8),
              Text(
                'iPad',
                style: TextStyle(
                  color: Colors.purple.shade600,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
        break;
      case '6': // Camera
        placeholder = Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal.shade100, Colors.teal.shade50],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.camera_alt, size: 48, color: Colors.teal.shade600),
              const SizedBox(height: 8),
              Text(
                'Camera',
                style: TextStyle(
                  color: Colors.teal.shade600,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
        break;
      default:
        placeholder = Container(
          color: AppColors.grey200,
          child: const Icon(
            Icons.image_not_supported_outlined,
            color: AppColors.grey500,
            size: 48,
          ),
        );
    }

    return Image.asset(
      product.imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return placeholder;
      },
    );
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}

// Product Model
class ProductModel {
  final String id;
  final String title;
  final String description;
  final int price;
  final int? discountPrice;
  final String imageUrl;
  final double rating;
  final bool isOnSale;

  const ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.discountPrice,
    required this.imageUrl,
    required this.rating,
    required this.isOnSale,
  });
}
