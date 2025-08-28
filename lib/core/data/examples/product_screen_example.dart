import 'package:flutter/material.dart';
import '../data_manager.dart';
import '../models/product_model.dart';

/// Example screen showing how to use the DataManager
class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final DataManager _dataManager = DataManager.instance;
  List<ProductModel> _products = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _currentPage = 1;
  bool _hasMoreData = true;
  String _searchQuery = '';
  String? _selectedCategory;
  String _sortBy = 'name';
  String _sortOrder = 'asc';

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      if (_hasMoreData && !_isLoading) {
        _loadMoreProducts();
      }
    }
  }

  Future<void> _loadProducts({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _products.clear();
      _hasMoreData = true;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await _dataManager.getProducts(
        page: _currentPage,
        limit: 20,
        query: _searchQuery.isEmpty ? null : _searchQuery,
        categoryId: _selectedCategory,
        sortBy: _sortBy,
        sortOrder: _sortOrder,
      );

      if (response.success) {
        setState(() {
          if (refresh) {
            _products = response.data;
          } else {
            _products.addAll(response.data);
          }
          _hasMoreData = response.metadata?['hasNextPage'] ?? false;
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

  Future<void> _loadMoreProducts() async {
    _currentPage++;
    await _loadProducts();
  }

  void _onSearch(String query) {
    _searchQuery = query;
    _loadProducts(refresh: true);
  }

  void _onCategoryChanged(String? category) {
    _selectedCategory = category;
    _loadProducts(refresh: true);
  }

  void _onSortChanged(String sortBy, String sortOrder) {
    _sortBy = sortBy;
    _sortOrder = sortOrder;
    _loadProducts(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('محصولات'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Column(
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'جستجوی محصولات...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: _onSearch,
                ),
              ),
              // Filters Row
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: DropdownButton<String>(
                        value: _selectedCategory,
                        hint: const Text('دسته‌بندی'),
                        isExpanded: true,
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('همه دسته‌ها'),
                          ),
                          const DropdownMenuItem(
                            value: 'electronics',
                            child: Text('الکترونیک'),
                          ),
                          const DropdownMenuItem(
                            value: 'fashion',
                            child: Text('پوشاک'),
                          ),
                          const DropdownMenuItem(
                            value: 'home-appliances',
                            child: Text('لوازم خانگی'),
                          ),
                          const DropdownMenuItem(
                            value: 'beauty-health',
                            child: Text('زیبایی و سلامت'),
                          ),
                          const DropdownMenuItem(
                            value: 'sports',
                            child: Text('ورزش'),
                          ),
                        ],
                        onChanged: _onCategoryChanged,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: DropdownButton<String>(
                        value: '$_sortBy-$_sortOrder',
                        isExpanded: true,
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
                          final parts = value!.split('-');
                          _onSortChanged(parts[0], parts[1]);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading && _products.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null && _products.isEmpty) {
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
              onPressed: () => _loadProducts(refresh: true),
              child: const Text('تلاش مجدد'),
            ),
          ],
        ),
      );
    }

    if (_products.isEmpty) {
      return const Center(
        child: Text('هیچ محصولی یافت نشد', style: TextStyle(fontSize: 18)),
      );
    }

    return RefreshIndicator(
      onRefresh: () => _loadProducts(refresh: true),
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _products.length + (_hasMoreData ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < _products.length) {
            return _buildProductItem(_products[index]);
          } else {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }

  Widget _buildProductItem(ProductModel product) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            product.mainImage,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 60,
                height: 60,
                color: Colors.grey[300],
                child: const Icon(Icons.image_not_supported),
              );
            },
          ),
        ),
        title: Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.brand,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  product.formattedPrice,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                if (product.isOnSale) ...[
                  const SizedBox(width: 8),
                  Text(
                    product.formattedOriginalPrice,
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.star, size: 16, color: Colors.amber[600]),
                const SizedBox(width: 4),
                Text(
                  product.rating.average.toString(),
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  ' (${product.rating.totalReviews})',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (product.isOnSale)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '${product.discountPercentage.toInt()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(height: 4),
            Icon(
              product.inventory.stockStatus == 'in_stock'
                  ? Icons.check_circle
                  : Icons.cancel,
              size: 16,
              color: product.inventory.stockStatus == 'in_stock'
                  ? Colors.green
                  : Colors.red,
            ),
          ],
        ),
        onTap: () {
          // Navigate to product detail screen
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ProductDetailScreen(productId: product.id),
            ),
          );
        },
      ),
    );
  }
}

/// Example Product Detail Screen
class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final DataManager _dataManager = DataManager.instance;
  ProductModel? _product;
  List<ProductModel> _relatedProducts = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProductDetails();
  }

  Future<void> _loadProductDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Load product details
      final productResponse = await _dataManager.getProduct(widget.productId);

      if (productResponse.success && productResponse.data != null) {
        _product = productResponse.data;

        // Load related products
        final relatedResponse = await _dataManager.getRelatedProducts(
          widget.productId,
          limit: 5,
        );

        if (relatedResponse.success) {
          _relatedProducts = relatedResponse.data;
        }

        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = productResponse.message;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_product?.name ?? 'جزئیات محصول'),
        actions: [
          IconButton(
            onPressed: () {
              // Add to wishlist logic
            },
            icon: const Icon(Icons.favorite_border),
          ),
          IconButton(
            onPressed: () {
              // Share product logic
            },
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: _product != null
          ? Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // Add to cart logic
                      },
                      child: const Text('افزودن به سبد'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Buy now logic
                      },
                      child: const Text('خرید فوری'),
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
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

    if (_product == null) {
      return const Center(child: Text('محصول یافت نشد'));
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          // Product Images
          SizedBox(
            height: 300,
            child: PageView.builder(
              itemCount: _product!.images.length,
              itemBuilder: (context, index) {
                return Image.network(
                  _product!.images[index].url,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported, size: 64),
                    );
                  },
                );
              },
            ),
          ),

          // Product Info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and Brand
                Text(
                  _product!.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'برند: ${_product!.brand}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 16),
                ),

                // Price
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      _product!.formattedPrice,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    if (_product!.isOnSale) ...[
                      const SizedBox(width: 12),
                      Text(
                        _product!.formattedOriginalPrice,
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${_product!.discountPercentage.toInt()}% تخفیف',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                // Rating
                const SizedBox(height: 16),
                Row(
                  children: [
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < _product!.rating.average.floor()
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber[600],
                          size: 20,
                        );
                      }),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${_product!.rating.average}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '(${_product!.rating.totalReviews} نظر)',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),

                // Description
                const SizedBox(height: 24),
                Text('توضیحات', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(
                  _product!.description,
                  style: const TextStyle(height: 1.5),
                ),

                // Colors (if available)
                if (_product!.availableColors.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Text(
                    'رنگ‌های موجود',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _product!.availableColors.map((color) {
                      return Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color(
                            int.parse(color.hexCode.replaceFirst('#', '0xFF')),
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey[300]!,
                            width: 2,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],

                // Related Products
                if (_relatedProducts.isNotEmpty) ...[
                  const SizedBox(height: 32),
                  Text(
                    'محصولات مرتبط',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _relatedProducts.length,
                      itemBuilder: (context, index) {
                        final relatedProduct = _relatedProducts[index];
                        return Container(
                          width: 150,
                          margin: const EdgeInsets.only(right: 16),
                          child: Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(4),
                                  ),
                                  child: Image.network(
                                    relatedProduct.mainImage,
                                    height: 100,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 100,
                                        color: Colors.grey[300],
                                        child: const Icon(
                                          Icons.image_not_supported,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        relatedProduct.name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        relatedProduct.formattedPrice,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 12,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
