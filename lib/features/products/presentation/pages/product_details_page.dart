// Product Details Page - Responsive Product Detail View
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/product_image_gallery.dart';
import '../widgets/product_info_section.dart';
import '../widgets/product_description.dart';
import '../widgets/product_reviews.dart';
import '../widgets/related_products.dart';

class ProductDetailsPage extends StatefulWidget {
  final String productId;

  const ProductDetailsPage({super.key, required this.productId});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  bool _isFavorite = false;
  int _quantity = 1;

  // Mock product data - TODO: Replace with API call
  final ProductDetailModel _product = const ProductDetailModel(
    id: '1',
    title: 'آیفون 15 پرو مکس',
    brand: 'Apple',
    description:
        'آخرین نسل گوشی‌های هوشمند اپل با فناوری پیشرفته A17 Pro و سیستم دوربین بهبود یافته. طراحی تیتانیومی جدید با مقاومت بالا و عملکرد فوق‌العاده برای تمام نیازهای روزانه شما.',
    price: 85000000,
    discountPrice: 79000000,
    rating: 4.8,
    reviewCount: 127,
    imageUrls: [
      'https://via.placeholder.com/400x400/667EEA/FFFFFF?text=iPhone+1',
      'https://via.placeholder.com/400x400/764ABC/FFFFFF?text=iPhone+2',
      'https://via.placeholder.com/400x400/F093FB/FFFFFF?text=iPhone+3',
      'https://via.placeholder.com/400x400/F59E0B/FFFFFF?text=iPhone+4',
    ],
    specifications: {
      'نمایشگر': '6.7 اینچ Super Retina XDR',
      'پردازنده': 'A17 Pro',
      'حافظه داخلی': '256 گیگابایت',
      'دوربین': '48 مگاپیکسل سه گانه',
      'باتری': '4422 میلی‌آمپر ساعت',
      'سیستم عامل': 'iOS 17',
    },
    colors: [
      ColorOption('مشکی طبیعی', AppColors.grey900),
      ColorOption('آبی تیتانیوم', AppColors.primary),
      ColorOption('طلایی', AppColors.warning),
      ColorOption('نقره‌ای', AppColors.grey400),
    ],
    inStock: true,
    stockCount: 15,
  );

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 768;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,

      // Custom App Bar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: isDark ? AppColors.shadowDark : AppColors.shadowLight,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.arrow_back_ios,
              color: isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
              size: 20,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isFavorite = !_isFavorite;
              });
            },
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? AppColors.shadowDark
                        : AppColors.shadowLight,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                color: _isFavorite
                    ? AppColors.error
                    : (isDark
                          ? AppColors.textPrimaryDark
                          : AppColors.textPrimaryLight),
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.paddingS),
          IconButton(
            onPressed: () {
              // TODO: Implement share functionality
            },
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : AppColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? AppColors.shadowDark
                        : AppColors.shadowLight,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.share_outlined,
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.paddingM),
        ],
      ),

      body: Column(
        children: [
          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: isTablet
                  ? _buildTabletLayout(context)
                  : _buildMobileLayout(context),
            ),
          ),

          // Bottom Bar - Add to Cart
          _buildBottomBar(context),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Images
        ProductImageGallery(
          imageUrls: _product.imageUrls,
          onImageTap: (index) => _showImageGallery(context, index),
        ),

        const SizedBox(height: AppDimensions.paddingM),

        // Product Info
        ProductInfoSection(
          product: _product,
          selectedQuantity: _quantity,
          onQuantityChanged: (quantity) => setState(() => _quantity = quantity),
        ),

        const SizedBox(height: AppDimensions.paddingL),

        // Product Description
        ProductDescription(product: _product),

        const SizedBox(height: AppDimensions.paddingL),

        // Product Reviews
        ProductReviews(
          rating: _product.rating,
          reviewCount: _product.reviewCount,
          onViewAllReviews: () => _navigateToReviews(),
        ),

        const SizedBox(height: AppDimensions.paddingL),

        // Related Products
        RelatedProducts(
          currentProductId: _product.id,
          onProductTap: (productId) => _navigateToProduct(productId),
        ),

        const SizedBox(height: AppDimensions.paddingXL),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Column - Images
          Expanded(
            flex: 1,
            child: ProductImageGallery(
              imageUrls: _product.imageUrls,
              onImageTap: (index) => _showImageGallery(context, index),
            ),
          ),

          const SizedBox(width: AppDimensions.paddingXL),

          // Right Column - Info
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProductInfoSection(
                  product: _product,
                  selectedQuantity: _quantity,
                  onQuantityChanged: (quantity) =>
                      setState(() => _quantity = quantity),
                ),

                const SizedBox(height: AppDimensions.paddingL),

                ProductDescription(product: _product),

                const SizedBox(height: AppDimensions.paddingL),

                ProductReviews(
                  rating: _product.rating,
                  reviewCount: _product.reviewCount,
                  onViewAllReviews: () => _navigateToReviews(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        boxShadow: [
          BoxShadow(
            color: isDark ? AppColors.shadowDark : AppColors.shadowLight,
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Price Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_product.discountPrice != null) ...[
                    Text(
                      '${_formatPrice(_product.price)} تومان',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.grey500,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    Text(
                      '${_formatPrice(_product.discountPrice!)} تومان',
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ] else
                    Text(
                      '${_formatPrice(_product.price)} تومان',
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(width: AppDimensions.paddingM),

            // Add to Cart Button
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _product.inStock ? () => _addToCart() : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _product.inStock
                      ? AppColors.primary
                      : AppColors.grey400,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: AppDimensions.paddingM,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_cart_outlined, size: 20),
                    const SizedBox(width: AppDimensions.paddingS),
                    Text(
                      _product.inStock ? 'افزودن به سبد خرید' : 'ناموجود',
                      style: AppTextStyles.labelLarge.copyWith(
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

  void _addToCart() {
    // TODO: Implement add to cart functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_product.title} به سبد خرید اضافه شد'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
      ),
    );
  }

  void _showImageGallery(BuildContext context, int initialIndex) {
    // TODO: Implement image gallery view
    debugPrint('Show image gallery at index: $initialIndex');
  }

  void _navigateToReviews() {
    // TODO: Navigate to reviews page
    debugPrint('Navigate to reviews');
  }

  void _navigateToProduct(String productId) {
    // TODO: Navigate to another product
    debugPrint('Navigate to product: $productId');
  }
}

// Product Detail Model
class ProductDetailModel {
  final String id;
  final String title;
  final String brand;
  final String description;
  final int price;
  final int? discountPrice;
  final double rating;
  final int reviewCount;
  final List<String> imageUrls;
  final Map<String, String> specifications;
  final List<ColorOption> colors;
  final bool inStock;
  final int stockCount;

  const ProductDetailModel({
    required this.id,
    required this.title,
    required this.brand,
    required this.description,
    required this.price,
    this.discountPrice,
    required this.rating,
    required this.reviewCount,
    required this.imageUrls,
    required this.specifications,
    required this.colors,
    required this.inStock,
    required this.stockCount,
  });
}

// Color Option Model
class ColorOption {
  final String name;
  final Color color;

  const ColorOption(this.name, this.color);
}
