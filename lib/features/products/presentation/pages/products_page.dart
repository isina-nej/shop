// Products Page - Responsive Products List with Filters (Updated for DataManager)
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/localization/localization_extension.dart';
import '../../../../core/data/data_manager.dart';
import '../../../../core/data/models/product_model.dart';
import 'product_details_page.dart';

class ProductsPage extends StatefulWidget {
  final String? categoryId;
  final String? categoryName;
  final String? searchQuery;

  const ProductsPage({
    super.key,
    this.categoryId,
    this.categoryName,
    this.searchQuery,
  });

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final DataManager _dataManager = DataManager.instance;
  
  List<ProductModel> _products = [];
  List<ProductModel> _filteredProducts = [];
  String _searchQuery = '';
  bool _isGridView = true;
  bool _isLoading = false;
  String? _errorMessage;
  
  // Filter options
  String? _selectedCategoryId;
  double? _minPrice;
  double? _maxPrice;
  double? _minRating;
  bool _inStockOnly = false;
  String _sortBy = 'name';
  String _sortOrder = 'asc';

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.categoryId;
    _searchQuery = widget.searchQuery ?? '';
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _dataManager.getProducts(
        categoryId: _selectedCategoryId,
        query: _searchQuery.isEmpty ? null : _searchQuery,
        minPrice: _minPrice,
        maxPrice: _maxPrice,
        minRating: _minRating,
        inStockOnly: _inStockOnly ? true : null,
        sortBy: _sortBy,
        sortOrder: _sortOrder,
        limit: 50,
      );

      if (response.success) {
        setState(() {
          _products = response.data;
          _filteredProducts = _products;
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

  void _applyFilters() {
    _loadProducts(); // Reload with new filters
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      appBar: _buildAppBar(context),
      body: ResponsiveUtils.isMobile(context)
          ? _buildMobileLayout(context)
          : _buildDesktopLayout(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        widget.categoryName ?? context.tr('products'),
        style: AppTextStyles.headlineMedium.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
          onPressed: () {
            setState(() {
              _isGridView = !_isGridView;
            });
          },
        ),
        IconButton(
          icon: const Icon(Icons.tune),
          onPressed: () => _showFilterOptions(context),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return _buildErrorState(context);
    }

    return Column(
      children: [
        // Search Bar
        Container(
          margin: const EdgeInsets.all(AppDimensions.paddingM),
          child: _buildSearchBar(context),
        ),

        // Products Count
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingM,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_filteredProducts.length} ${context.tr('products')}',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
              TextButton.icon(
                onPressed: () => _showSortOptions(context),
                icon: const Icon(Icons.sort, size: 16),
                label: Text(context.tr('sort_products')),
              ),
            ],
          ),
        ),

        // Products List/Grid
        Expanded(
          child: _filteredProducts.isEmpty
              ? _buildEmptyState(context)
              : _buildProductsList(context),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return _buildErrorState(context);
    }

    return Row(
      children: [
        // Filters Sidebar
        Container(
          width: 300,
          padding: const EdgeInsets.all(AppDimensions.paddingL),
          child: _buildFilterSidebar(context),
        ),

        // Products Area
        Expanded(
          child: Column(
            children: [
              // Search and Controls
              Container(
                padding: const EdgeInsets.all(AppDimensions.paddingL),
                child: Row(
                  children: [
                    Expanded(child: _buildSearchBar(context)),
                    const SizedBox(width: AppDimensions.paddingM),
                    _buildViewToggle(context),
                  ],
                ),
              ),

              // Products Count and Sort
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingL,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_filteredProducts.length} ${context.tr('products')}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                    _buildSortDropdown(context),
                  ],
                ),
              ),

              // Products List/Grid
              Expanded(
                child: _filteredProducts.isEmpty
                    ? _buildEmptyState(context)
                    : _buildProductsList(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            _errorMessage!,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadProducts,
            child: const Text('تلاش مجدد'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'محصولی یافت نشد',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'فیلترها را تغییر دهید یا جستجوی جدید انجام دهید',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppColors.shadowDark : AppColors.shadowLight,
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: TextField(
        controller: TextEditingController(text: _searchQuery),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
          // Debounce search to avoid too many API calls
          Future.delayed(const Duration(milliseconds: 500), () {
            if (_searchQuery == value) {
              _onSearchChanged(value);
            }
          });
        },
        decoration: InputDecoration(
          hintText: context.tr('search_products'),
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _searchQuery = '';
                    });
                    _onSearchChanged('');
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingM,
            vertical: AppDimensions.paddingM,
          ),
        ),
      ),
    );
  }

  Widget _buildProductsList(BuildContext context) {
    return _isGridView
        ? _buildProductsGrid(context, crossAxisCount: 2)
        : _buildProductsListView(context);
  }

  Widget _buildProductsGrid(
    BuildContext context, {
    required int crossAxisCount,
  }) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.7,
        crossAxisSpacing: AppDimensions.paddingM,
        mainAxisSpacing: AppDimensions.paddingM,
      ),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        return _buildProductCard(context, _filteredProducts[index]);
      },
    );
  }

  Widget _buildProductsListView(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        return _buildProductListItem(context, _filteredProducts[index]);
      },
    );
  }

  Widget _buildProductCard(BuildContext context, ProductModel product) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 4,
      shadowColor: isDark ? AppColors.shadowDark : AppColors.shadowLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: InkWell(
        onTap: () => _navigateToProductDetails(context, product),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(AppDimensions.radiusL),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(product.mainImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Discount Badge
                  if (product.isOnSale)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusS,
                          ),
                        ),
                        child: Text(
                          '${product.discountPercentage.round()}%',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.white,
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
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.favorite_border),
                        onPressed: () => _toggleFavorite(product),
                        iconSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Product Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.paddingS),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    Text(
                      product.name,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    // Brand
                    Text(
                      product.brand,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),

                    const Spacer(),

                    // Rating and Price
                    Row(
                      children: [
                        Icon(Icons.star, size: 16, color: Colors.amber[600]),
                        const SizedBox(width: 2),
                        Text(
                          product.rating.average.toString(),
                          style: AppTextStyles.bodySmall,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${product.rating.totalReviews})',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // Price
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            product.formattedPrice,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        if (product.isOnSale) ...[
                          Text(
                            product.formattedOriginalPrice,
                            style: AppTextStyles.bodySmall.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: Theme.of(
                                context,
                              ).textTheme.bodySmall?.color,
                            ),
                          ),
                        ],
                      ],
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

  Widget _buildProductListItem(BuildContext context, ProductModel product) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingM),
      elevation: 2,
      shadowColor: isDark ? AppColors.shadowDark : AppColors.shadowLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: InkWell(
        onTap: () => _navigateToProductDetails(context, product),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingM),
          child: Row(
            children: [
              // Product Image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                  image: DecorationImage(
                    image: NetworkImage(product.mainImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(width: AppDimensions.paddingM),

              // Product Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    Text(
                      product.brand,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Icon(Icons.star, size: 16, color: Colors.amber[600]),
                        const SizedBox(width: 4),
                        Text(
                          '${product.rating.average} (${product.rating.totalReviews})',
                          style: AppTextStyles.bodySmall,
                        ),
                        const Spacer(),
                        Text(
                          product.formattedPrice,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Favorite Button
              IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () => _toggleFavorite(product),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildViewToggle(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.grid_view,
            color: _isGridView ? AppColors.primary : Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _isGridView = true;
            });
          },
        ),
        IconButton(
          icon: Icon(
            Icons.list,
            color: !_isGridView ? AppColors.primary : Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _isGridView = false;
            });
          },
        ),
      ],
    );
  }

  Widget _buildSortDropdown(BuildContext context) {
    return DropdownButton<String>(
      value: '$_sortBy-$_sortOrder',
      items: const [
        DropdownMenuItem(
          value: 'name-asc',
          child: Text('نام (الف-ی)'),
        ),
        DropdownMenuItem(
          value: 'name-desc',
          child: Text('نام (ی-الف)'),
        ),
        DropdownMenuItem(
          value: 'price-asc',
          child: Text('قیمت (کم به زیاد)'),
        ),
        DropdownMenuItem(
          value: 'price-desc',
          child: Text('قیمت (زیاد به کم)'),
        ),
        DropdownMenuItem(
          value: 'rating-desc',
          child: Text('امتیاز (بالا به پایین)'),
        ),
        DropdownMenuItem(
          value: 'popularity-desc',
          child: Text('پرفروش‌ترین'),
        ),
      ],
      onChanged: (value) {
        if (value != null) {
          final parts = value.split('-');
          setState(() {
            _sortBy = parts[0];
            _sortOrder = parts[1];
          });
          _applyFilters();
        }
      },
    );
  }

  Widget _buildFilterSidebar(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'فیلترها',
          style: AppTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        // Price Range
        Text(
          'محدوده قیمت',
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'حداقل',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _minPrice = double.tryParse(value);
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'حداکثر',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _maxPrice = double.tryParse(value);
                },
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Stock filter
        CheckboxListTile(
          title: const Text('فقط کالاهای موجود'),
          value: _inStockOnly,
          onChanged: (value) {
            setState(() {
              _inStockOnly = value ?? false;
            });
          },
        ),
        
        const SizedBox(height: 16),
        
        // Apply Filters Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _applyFilters,
            child: const Text('اعمال فیلتر'),
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Clear Filters Button
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: () {
              setState(() {
                _selectedCategoryId = null;
                _minPrice = null;
                _maxPrice = null;
                _minRating = null;
                _inStockOnly = false;
                _sortBy = 'name';
                _sortOrder = 'asc';
              });
              _applyFilters();
            },
            child: const Text('پاک کردن فیلترها'),
          ),
        ),
      ],
    );
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'مرتب‌سازی براساس',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('نام (الف-ی)'),
                trailing: _sortBy == 'name' && _sortOrder == 'asc'
                    ? Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _sortBy = 'name';
                    _sortOrder = 'asc';
                  });
                  _applyFilters();
                },
              ),
              ListTile(
                title: const Text('قیمت (کم به زیاد)'),
                trailing: _sortBy == 'price' && _sortOrder == 'asc'
                    ? Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _sortBy = 'price';
                    _sortOrder = 'asc';
                  });
                  _applyFilters();
                },
              ),
              ListTile(
                title: const Text('قیمت (زیاد به کم)'),
                trailing: _sortBy == 'price' && _sortOrder == 'desc'
                    ? Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _sortBy = 'price';
                    _sortOrder = 'desc';
                  });
                  _applyFilters();
                },
              ),
              ListTile(
                title: const Text('امتیاز (بالا به پایین)'),
                trailing: _sortBy == 'rating' && _sortOrder == 'desc'
                    ? Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _sortBy = 'rating';
                    _sortOrder = 'desc';
                  });
                  _applyFilters();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFilterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                controller: scrollController,
                child: _buildFilterSidebar(context),
              ),
            );
          },
        );
      },
    );
  }

  void _toggleFavorite(ProductModel product) {
    // TODO: Implement favorite functionality with DataManager
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('محصول به علاقه‌مندی‌ها اضافه شد')),
    );
  }

  void _navigateToProductDetails(BuildContext context, ProductModel product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductDetailsPage(productId: product.id),
      ),
    );
  }
}
