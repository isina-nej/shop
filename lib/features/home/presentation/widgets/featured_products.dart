// Featured Products Widget
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class FeaturedProducts extends StatelessWidget {
  const FeaturedProducts({super.key});

  // Mock featured products data
  static const List<ProductModel> _featuredProducts = [
    ProductModel(
      id: '1',
      title: 'آیفون 15 پرو مکس',
      description: 'گوشی هوشمند آیفون با آخرین تکنولوژی',
      price: 85000000,
      discountPrice: 79000000,
      imageUrl: 'https://via.placeholder.com/300x300/667EEA/FFFFFF?text=iPhone',
      rating: 4.8,
      isOnSale: true,
    ),
    ProductModel(
      id: '2',
      title: 'سامسونگ گلکسی S24',
      description: 'گوشی هوشمند سامسونگ پرفروش',
      price: 45000000,
      discountPrice: null,
      imageUrl:
          'https://via.placeholder.com/300x300/764ABC/FFFFFF?text=Samsung',
      rating: 4.6,
      isOnSale: false,
    ),
    ProductModel(
      id: '3',
      title: 'لپ تاپ مک بوک ایر',
      description: 'لپ تاپ اپل با چیپ M2',
      price: 65000000,
      discountPrice: 59000000,
      imageUrl:
          'https://via.placeholder.com/300x300/F093FB/FFFFFF?text=MacBook',
      rating: 4.9,
      isOnSale: true,
    ),
    ProductModel(
      id: '4',
      title: 'هدفون بی سیم ایرپاد',
      description: 'هدفون اپل با کیفیت عالی',
      price: 12000000,
      discountPrice: null,
      imageUrl:
          'https://via.placeholder.com/300x300/F59E0B/FFFFFF?text=AirPods',
      rating: 4.7,
      isOnSale: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header with View All
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingM,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'محصولات ویژه',
                style: AppTextStyles.headlineMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // TODO: Navigate to all products
                  debugPrint('View all products');
                },
                child: Text(
                  'مشاهده همه',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.paddingM),

        // Products List
        SizedBox(
          height: 280,
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
        // TODO: Navigate to product details
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
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.grey200,
                          child: const Icon(
                            Icons.image_not_supported_outlined,
                            color: AppColors.grey500,
                            size: 48,
                          ),
                        );
                      },
                    ),
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
                        'تخفیف',
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
                      color: AppColors.white.withOpacity(0.9),
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
