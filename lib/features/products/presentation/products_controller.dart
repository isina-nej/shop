// Products Controller using GetX
import 'package:get/get.dart';
import '../../../core/models/shop_models.dart';
import '../../../core/data/mock_data.dart';

class ProductsController extends GetxController {
  var products = <Product>[].obs;
  var filteredProducts = <Product>[].obs;
  var isLoading = false.obs;
  var searchQuery = ''.obs;
  var selectedCategory = Rxn<String>();
  var sortBy = 'name'.obs;
  var sortOrder = 'asc'.obs;

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  void loadProducts() {
    isLoading.value = true;
    // Simulate API call delay
    Future.delayed(const Duration(milliseconds: 500), () {
      products.value = MockData.products;
      filteredProducts.value = MockData.products;
      isLoading.value = false;
    });
  }

  void searchProducts(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  void setCategory(String? categoryId) {
    selectedCategory.value = categoryId;
    _applyFilters();
  }

  void setSorting(String sort, String order) {
    sortBy.value = sort;
    sortOrder.value = order;
    _applyFilters();
  }

  void _applyFilters() {
    var filtered = products.where((product) {
      // Search filter
      if (searchQuery.value.isNotEmpty) {
        final query = searchQuery.value.toLowerCase();
        if (!product.name.toLowerCase().contains(query) &&
            !product.description.toLowerCase().contains(query)) {
          return false;
        }
      }

      // Category filter
      if (selectedCategory.value != null &&
          product.category != selectedCategory.value) {
        return false;
      }

      return true;
    }).toList();

    // Apply sorting
    filtered.sort((a, b) {
      int comparison;
      switch (sortBy.value) {
        case 'price':
          comparison = a.price.compareTo(b.price);
          break;
        case 'rating':
          comparison = a.rating.compareTo(b.rating);
          break;
        case 'name':
        default:
          comparison = a.name.compareTo(b.name);
          break;
      }

      return sortOrder.value == 'desc' ? -comparison : comparison;
    });

    filteredProducts.value = filtered;
  }
}
