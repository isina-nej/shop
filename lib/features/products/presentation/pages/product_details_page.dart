// Product Details Page - Updated for DataManager
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/localization/localization_extension.dart';
import '../../../../core/data/data_manager.dart';
import '../../../../core/data/models/product_model.dart';

class ProductDetailsPage extends StatefulWidget {
  final String productId;

  const ProductDetailsPage({super.key, required this.productId});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  final DataManager _dataManager = DataManager.instance;

  ProductModel? _product;
  List<ProductModel> _relatedProducts = [];
  bool _isLoading = false;
  bool _isFavorite = false;
  int _quantity = 1;
  int _selectedImageIndex = 0;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProductDetails();
    _loadRelatedProducts();
  }

  Future<void> _loadProductDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _dataManager.getProductById(widget.productId);
      if (response.success && response.data != null) {
        setState(() {
          _product = response.data;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = response.message;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'خطای غیرمنتظره: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadRelatedProducts() async {
    if (_product?.categoryId != null) {
      try {
        final response = await _dataManager.getProducts(
          categoryId: _product!.categoryId,
          limit: 6,
        );
        if (response.success) {
          setState(() {
            _relatedProducts = response.data
                .where((p) => p.id != widget.productId)
                .take(4)
                .toList();
          });
        }
      } catch (e) {
        // Ignore related products error
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: _buildAppBar(context),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? _buildErrorState(context)
          : _product == null
          ? _buildNotFoundState(context)
          : ResponsiveUtils.isMobile(context)
          ? _buildMobileLayout(context)
          : _buildDesktopLayout(context),
      bottomNavigationBar: _product != null && ResponsiveUtils.isMobile(context)
          ? _buildBottomActionBar(context)
          : null,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        _product?.name ?? context.tr('products'),
        style: AppTextStyles.headlineMedium.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(
            _isFavorite ? Icons.favorite : Icons.favorite_border,
            color: _isFavorite ? Colors.red : null,
          ),
          onPressed: () => _toggleFavorite(),
        ),
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () => _shareProduct(),
        ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            _errorMessage!,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadProductDetails,
            child: const Text('تلاش مجدد'),
          ),
        ],
      ),
    );
  }

  Widget _buildNotFoundState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'محصول یافت نشد',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'محصول مورد نظر حذف شده یا وجود ندارد',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImageGallery(context),
          const SizedBox(height: AppDimensions.paddingM),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingM,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProductInfo(context),
                const SizedBox(height: AppDimensions.paddingL),
                _buildQuantitySelector(context),
                const SizedBox(height: AppDimensions.paddingL),
                _buildDescription(context),
                const SizedBox(height: AppDimensions.paddingL),
                _buildSpecifications(context),
                const SizedBox(height: AppDimensions.paddingL),
                _buildReviews(context),
                const SizedBox(height: AppDimensions.paddingL),
                _buildRelatedProducts(context),
                const SizedBox(height: 80), // Space for bottom bar
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.paddingL),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side - Images
          Expanded(flex: 1, child: _buildImageGallery(context)),

          const SizedBox(width: AppDimensions.paddingXL),

          // Right side - Info
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProductInfo(context),
                const SizedBox(height: AppDimensions.paddingL),
                _buildQuantitySelector(context),
                const SizedBox(height: AppDimensions.paddingL),
                _buildActionButtons(context),
                const SizedBox(height: AppDimensions.paddingXL),
                _buildDescription(context),
                const SizedBox(height: AppDimensions.paddingL),
                _buildSpecifications(context),
                const SizedBox(height: AppDimensions.paddingL),
                _buildReviews(context),
                const SizedBox(height: AppDimensions.paddingL),
                _buildRelatedProducts(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGallery(BuildContext context) {
    return Container(
      height: ResponsiveUtils.isMobile(context) ? 400 : 500,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          // Main image
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppDimensions.radiusL),
                ),
                image: DecorationImage(
                  image: NetworkImage(
                    _product!.images[_selectedImageIndex].url,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  if (_product!.isOnSale)
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusS,
                          ),
                        ),
                        child: Text(
                          '${_product!.discountPercentage.round()}%',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Image thumbnails
          if (_product!.images.length > 1)
            Container(
              height: 80,
              padding: const EdgeInsets.all(8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _product!.images.length,
                itemBuilder: (context, index) {
                  final isSelected = index == _selectedImageIndex;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedImageIndex = index;
                      });
                    },
                    child: Container(
                      width: 64,
                      margin: const EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.transparent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusS,
                        ),
                        image: DecorationImage(
                          image: NetworkImage(_product!.images[index].url),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProductInfo(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Brand
        Text(
          _product!.brand,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 8),

        // Name
        Text(
          _product!.name,
          style: AppTextStyles.headlineLarge.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        // Rating
        Row(
          children: [
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < _product!.rating.average.floor()
                      ? Icons.star
                      : Icons.star_border,
                  size: 20,
                  color: Colors.amber[600],
                );
              }),
            ),
            const SizedBox(width: 8),
            Text(
              '${_product!.rating.average} (${_product!.rating.totalReviews} نظر)',
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Price
        Row(
          children: [
            Text(
              _product!.formattedPrice,
              style: AppTextStyles.headlineMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            if (_product!.isOnSale) ...[
              const SizedBox(width: 12),
              Text(
                _product!.formattedOriginalPrice,
                style: AppTextStyles.bodyLarge.copyWith(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ],
        ),

        const SizedBox(height: 8),

        // Stock status
        Row(
          children: [
            Icon(
              _product!.isInStock ? Icons.check_circle : Icons.error,
              size: 16,
              color: _product!.isInStock ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 4),
            Text(
              _product!.isInStock
                  ? 'موجود در انبار (${_product!.stockQuantity} عدد)'
                  : 'ناموجود',
              style: AppTextStyles.bodyMedium.copyWith(
                color: _product!.isInStock ? Colors.green : Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuantitySelector(BuildContext context) {
    return Row(
      children: [
        Text(
          'تعداد:',
          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 16),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: _quantity > 1
                    ? () {
                        setState(() {
                          _quantity--;
                        });
                      }
                    : null,
              ),
              Container(
                width: 60,
                alignment: Alignment.center,
                child: Text(
                  _quantity.toString(),
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: _quantity < _product!.stockQuantity
                    ? () {
                        setState(() {
                          _quantity++;
                        });
                      }
                    : null,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.shopping_cart),
            label: const Text('افزودن به سبد خرید'),
            onPressed: _product!.isInStock ? _addToCart : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            icon: const Icon(Icons.flash_on),
            label: const Text('خرید فوری'),
            onPressed: _product!.isInStock ? _buyNow : null,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActionBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: AppDimensions.paddingM,
        right: AppDimensions.paddingM,
        top: AppDimensions.paddingM,
        bottom: MediaQuery.of(context).padding.bottom + AppDimensions.paddingM,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 48,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.shopping_cart),
                label: const Text('افزودن به سبد'),
                onPressed: _product!.isInStock ? _addToCart : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 48,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.flash_on),
                label: const Text('خرید فوری'),
                onPressed: _product!.isInStock ? _buyNow : null,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'توضیحات',
          style: AppTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _product!.description,
          style: AppTextStyles.bodyLarge.copyWith(height: 1.6),
        ),
      ],
    );
  }

  Widget _buildSpecifications(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'مشخصات',
          style: AppTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...(_product!.specifications.entries.entries.map((spec) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    spec.key,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(spec.value, style: AppTextStyles.bodyMedium),
                ),
              ],
            ),
          );
        }).toList()),
      ],
    );
  }

  Widget _buildReviews(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'نظرات',
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Navigate to reviews page
              },
              child: const Text('مشاهده همه'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          '${_product!.rating.totalReviews} نظر با میانگین ${_product!.rating.average} ستاره',
          style: AppTextStyles.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildRelatedProducts(BuildContext context) {
    if (_relatedProducts.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'محصولات مرتبط',
          style: AppTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _relatedProducts.length,
            itemBuilder: (context, index) {
              final product = _relatedProducts[index];
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailsPage(productId: product.id),
                    ),
                  );
                },
                child: Container(
                  width: 150,
                  margin: const EdgeInsets.only(left: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(AppDimensions.radiusM),
                            ),
                            image: DecorationImage(
                              image: NetworkImage(product.mainImage),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              product.formattedPrice,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    // TODO: Add to/remove from favorites via DataManager
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorite
              ? 'محصول به علاقه‌مندی‌ها اضافه شد'
              : 'محصول از علاقه‌مندی‌ها حذف شد',
        ),
      ),
    );
  }

  void _shareProduct() {
    // TODO: Implement product sharing
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('لینک محصول کپی شد')));
  }

  void _addToCart() {
    // TODO: Add to cart via DataManager
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$_quantity عدد از ${_product!.name} به سبد خرید اضافه شد',
        ),
      ),
    );
  }

  void _buyNow() {
    // TODO: Navigate to checkout page
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('انتقال به صفحه پرداخت...')));
  }
}
