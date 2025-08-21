// Products Page - Responsive Products List with Filters
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/localization/localization_extension.dart';
import '../../../../core/data/mock_data.dart';
import '../../../../core/models/shop_models.dart';
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
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  ProductFilter _currentFilter = const ProductFilter();
  String _searchQuery = '';
  bool _isGridView = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _searchQuery = widget.searchQuery ?? '';
    if (_searchQuery.isNotEmpty) {
      _filterProducts();
    }
  }

  void _loadProducts() {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        if (widget.categoryId != null) {
          _products = MockData.getProductsByCategory(widget.categoryId!);
        } else {
          _products = MockData.products;
        }
        _filteredProducts = _products;
        _isLoading = false;
      });
    });
  }

  void _filterProducts() {
    setState(() {
      _filteredProducts = _products.where((product) {
        // Search filter
        if (_searchQuery.isNotEmpty) {
          final searchLower = _searchQuery.toLowerCase();
          if (!product.name.toLowerCase().contains(searchLower) &&
              !product.description.toLowerCase().contains(searchLower) &&
              !product.brand.toLowerCase().contains(searchLower)) {
            return false;
          }
        }

        // Category filter
        if (_currentFilter.categories.isNotEmpty &&
            !_currentFilter.categories.contains(product.category)) {
          return false;
        }

        // Brand filter
        if (_currentFilter.brands.isNotEmpty &&
            !_currentFilter.brands.contains(product.brand)) {
          return false;
        }

        // Price filter
        if (_currentFilter.minPrice != null &&
            product.price < _currentFilter.minPrice!) {
          return false;
        }
        if (_currentFilter.maxPrice != null &&
            product.price > _currentFilter.maxPrice!) {
          return false;
        }

        // Rating filter
        if (_currentFilter.minRating != null &&
            product.rating < _currentFilter.minRating!) {
          return false;
        }

        // Stock filter
        if (_currentFilter.inStockOnly == true && !product.isInStock) {
          return false;
        }

        // Sale filter
        if (_currentFilter.onSaleOnly == true && !product.isOnSale) {
          return false;
        }

        return true;
      }).toList();

      // Apply sorting
      _sortProducts();
    });
  }

  void _sortProducts() {
    switch (_currentFilter.sortBy) {
      case ProductSortOption.newest:
        // No sorting needed as mock data is already in newest order
        break;
      case ProductSortOption.oldest:
        _filteredProducts = _filteredProducts.reversed.toList();
        break;
      case ProductSortOption.priceLowToHigh:
        _filteredProducts.sort((a, b) => a.price.compareTo(b.price));
        break;
      case ProductSortOption.priceHighToLow:
        _filteredProducts.sort((a, b) => b.price.compareTo(a.price));
        break;
      case ProductSortOption.rating:
        _filteredProducts.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case ProductSortOption.popular:
        _filteredProducts.sort(
          (a, b) => b.reviewsCount.compareTo(a.reviewsCount),
        );
        break;
    }
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
          onPressed: () => _showFilterBottomSheet(context),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // Search Bar
        Container(
          margin: const EdgeInsets.all(AppDimensions.paddingM),
          child: _buildSearchBar(context),
        ),

        // Filter Chips
        if (_hasActiveFilters())
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingM,
            ),
            child: _buildFilterChips(context),
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
                onPressed: () => _showSortBottomSheet(context),
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

              // Products Grid/List
              Expanded(
                child: _filteredProducts.isEmpty
                    ? _buildEmptyState(context)
                    : Container(
                        padding: const EdgeInsets.all(AppDimensions.paddingL),
                        child: _buildProductsGrid(context, crossAxisCount: 4),
                      ),
              ),
            ],
          ),
        ),
      ],
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
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
          _filterProducts();
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
                    _filterProducts();
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

  Widget _buildProductCard(BuildContext context, Product product) {
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
                        image: NetworkImage(product.images.first),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Discount Badge
                  if (product.discountPercentage != null)
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
                          '${product.discountPercentage!.round()}%',
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
                          product.rating.toString(),
                          style: AppTextStyles.bodySmall,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${product.reviewsCount})',
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
                        if (product.formattedOriginalPrice != null) ...[
                          Text(
                            product.formattedOriginalPrice!,
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

  Widget _buildProductListItem(BuildContext context, Product product) {
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
                    image: NetworkImage(product.images.first),
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
                        const SizedBox(width: 2),
                        Text(
                          '${product.rating} (${product.reviewsCount})',
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

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
          const SizedBox(height: AppDimensions.paddingL),
          Text(
            context.tr('no_items_found'),
            style: AppTextStyles.headlineSmall.copyWith(
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: AppDimensions.paddingM),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _searchQuery = '';
                _currentFilter = const ProductFilter();
              });
              _filterProducts();
            },
            child: Text(context.tr('clear_filter')),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    final chips = <Widget>[];

    if (_searchQuery.isNotEmpty) {
      chips.add(
        FilterChip(
          label: Text(_searchQuery),
          selected: true,
          onSelected: (selected) {
            if (!selected) {
              setState(() {
                _searchQuery = '';
              });
              _filterProducts();
            }
          },
          onDeleted: () {
            setState(() {
              _searchQuery = '';
            });
            _filterProducts();
          },
        ),
      );
    }

    return ListView(scrollDirection: Axis.horizontal, children: chips);
  }

  Widget _buildViewToggle(BuildContext context) {
    return ToggleButtons(
      isSelected: [_isGridView, !_isGridView],
      onPressed: (index) {
        setState(() {
          _isGridView = index == 0;
        });
      },
      children: const [Icon(Icons.grid_view), Icon(Icons.list)],
    );
  }

  Widget _buildSortDropdown(BuildContext context) {
    return DropdownButton<ProductSortOption>(
      value: _currentFilter.sortBy,
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _currentFilter = _currentFilter.copyWith(sortBy: value);
          });
          _filterProducts();
        }
      },
      items: ProductSortOption.values.map((option) {
        String label;
        switch (option) {
          case ProductSortOption.newest:
            label = context.tr('newest_first');
            break;
          case ProductSortOption.oldest:
            label = context.tr('oldest_first');
            break;
          case ProductSortOption.priceLowToHigh:
            label = context.tr('price_low_to_high');
            break;
          case ProductSortOption.priceHighToLow:
            label = context.tr('price_high_to_low');
            break;
          case ProductSortOption.rating:
            label = context.tr('rating');
            break;
          case ProductSortOption.popular:
            label = context.tr('popularity');
            break;
        }

        return DropdownMenuItem(value: option, child: Text(label));
      }).toList(),
    );
  }

  Widget _buildFilterSidebar(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr('filter_products'),
          style: AppTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppDimensions.paddingL),

        // Add filter widgets here
        // This is a placeholder for the actual filter implementation
        ElevatedButton(
          onPressed: () {
            setState(() {
              _currentFilter = const ProductFilter();
              _searchQuery = '';
            });
            _filterProducts();
          },
          child: Text(context.tr('clear_filter')),
        ),
      ],
    );
  }

  bool _hasActiveFilters() {
    return _searchQuery.isNotEmpty ||
        _currentFilter.categories.isNotEmpty ||
        _currentFilter.brands.isNotEmpty ||
        _currentFilter.minPrice != null ||
        _currentFilter.maxPrice != null ||
        _currentFilter.minRating != null ||
        _currentFilter.inStockOnly == true ||
        _currentFilter.onSaleOnly == true;
  }

  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(AppDimensions.paddingL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.tr('filter_products'),
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingL),
              // Add filter options here
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          _currentFilter = const ProductFilter();
                        });
                        _filterProducts();
                      },
                      child: Text(context.tr('clear_filter')),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.paddingM),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _filterProducts();
                      },
                      child: Text(context.tr('apply_filter')),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSortBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(AppDimensions.paddingL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.tr('sort_products'),
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingL),
              ...ProductSortOption.values.map((option) {
                String label;
                switch (option) {
                  case ProductSortOption.newest:
                    label = context.tr('newest_first');
                    break;
                  case ProductSortOption.oldest:
                    label = context.tr('oldest_first');
                    break;
                  case ProductSortOption.priceLowToHigh:
                    label = context.tr('price_low_to_high');
                    break;
                  case ProductSortOption.priceHighToLow:
                    label = context.tr('price_high_to_low');
                    break;
                  case ProductSortOption.rating:
                    label = context.tr('rating');
                    break;
                  case ProductSortOption.popular:
                    label = context.tr('popularity');
                    break;
                }

                return ListTile(
                  title: Text(label),
                  trailing: _currentFilter.sortBy == option
                      ? Icon(Icons.check, color: AppColors.primary)
                      : null,
                  onTap: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _currentFilter = _currentFilter.copyWith(sortBy: option);
                    });
                    _filterProducts();
                  },
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }

  void _toggleFavorite(Product product) {
    // TODO: Implement favorite functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.tr('item_added_to_wishlist'))),
    );
  }

  void _navigateToProductDetails(BuildContext context, Product product) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ProductDetailsPage(productId: product.id),
      ),
    );
  }
}
