// Wishlist Controller
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/models/shop_models.dart';
import '../../../core/storage/storage_service.dart';
import '../../cart/presentation/cart_controller.dart';

class WishlistController extends GetxController {
  final RxList<Product> wishlistItems = <Product>[].obs;
  final RxBool isLoading = false.obs;
  CartController? _cartController;

  CartController get cartController {
    _cartController ??= Get.find<CartController>();
    return _cartController!;
  }

  @override
  void onInit() {
    super.onInit();
    loadWishlist();
  }

  // Load wishlist from storage
  Future<void> loadWishlist() async {
    try {
      isLoading.value = true;

      final wishlistData = await AppStorage.getList('wishlist');
      if (wishlistData != null) {
        wishlistItems.clear();
        for (var item in wishlistData) {
          wishlistItems.add(Product.fromJson(item));
        }
      }
    } catch (e) {
      print('Error loading wishlist: $e');
      Get.snackbar(
        'خطا',
        'خطا در بارگذاری لیست علاقه‌مندی‌ها',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Save wishlist to storage
  Future<void> saveWishlist() async {
    try {
      final wishlistData = wishlistItems
          .map((product) => product.toJson())
          .toList();
      await AppStorage.setList('wishlist', wishlistData);
    } catch (e) {
      print('Error saving wishlist: $e');
    }
  }

  // Add product to wishlist
  Future<void> addToWishlist(Product product) async {
    try {
      if (!isInWishlist(product.id)) {
        wishlistItems.add(product);
        await saveWishlist();

        Get.snackbar(
          'افزوده شد',
          '${product.name} به لیست علاقه‌مندی‌ها اضافه شد',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(16),
        );
      } else {
        Get.snackbar(
          'اطلاع',
          'این محصول قبلاً در لیست علاقه‌مندی‌ها موجود است',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.withOpacity(0.1),
          colorText: Colors.orange,
        );
      }
    } catch (e) {
      print('Error adding to wishlist: $e');
      Get.snackbar(
        'خطا',
        'خطا در افزودن به لیست علاقه‌مندی‌ها',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }

  // Remove product from wishlist
  Future<void> removeFromWishlist(String productId) async {
    try {
      final productIndex = wishlistItems.indexWhere(
        (product) => product.id == productId,
      );
      if (productIndex != -1) {
        final removedProduct = wishlistItems[productIndex];
        wishlistItems.removeAt(productIndex);
        await saveWishlist();

        Get.snackbar(
          'حذف شد',
          '${removedProduct.name} از لیست علاقه‌مندی‌ها حذف شد',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.withOpacity(0.1),
          colorText: Colors.orange,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(16),
          mainButton: TextButton(
            onPressed: () {
              addToWishlist(removedProduct);
              Get.closeCurrentSnackbar();
            },
            child: const Text('بازگردانی'),
          ),
        );
      }
    } catch (e) {
      print('Error removing from wishlist: $e');
      Get.snackbar(
        'خطا',
        'خطا در حذف از لیست علاقه‌مندی‌ها',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }

  // Toggle product in wishlist
  Future<void> toggleWishlist(Product product) async {
    if (isInWishlist(product.id)) {
      await removeFromWishlist(product.id);
    } else {
      await addToWishlist(product);
    }
  }

  // Check if product is in wishlist
  bool isInWishlist(String productId) {
    return wishlistItems.any((product) => product.id == productId);
  }

  // Clear all wishlist items
  Future<void> clearWishlist() async {
    try {
      // Show confirmation dialog
      final result = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('پاک کردن لیست علاقه‌مندی‌ها'),
          content: const Text(
            'آیا مطمئن هستید که می‌خواهید تمام آیتم‌های لیست علاقه‌مندی‌ها را پاک کنید؟',
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('لغو'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('پاک کردن'),
            ),
          ],
        ),
      );

      if (result == true) {
        wishlistItems.clear();
        await saveWishlist();

        Get.snackbar(
          'پاک شد',
          'تمام آیتم‌های لیست علاقه‌مندی‌ها پاک شدند',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
        );
      }
    } catch (e) {
      print('Error clearing wishlist: $e');
      Get.snackbar(
        'خطا',
        'خطا در پاک کردن لیست علاقه‌مندی‌ها',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }

  // Add product to cart
  Future<void> addToCart(Product product) async {
    try {
      cartController.addToCart(product);

      Get.snackbar(
        'افزوده شد',
        '${product.name} به سبد خرید اضافه شد',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue.withOpacity(0.1),
        colorText: Colors.blue,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
        mainButton: TextButton(
          onPressed: () {
            Get.toNamed('/cart');
            Get.closeCurrentSnackbar();
          },
          child: const Text('مشاهده سبد'),
        ),
      );
    } catch (e) {
      print('Error adding to cart: $e');
      Get.snackbar(
        'خطا',
        'خطا در افزودن به سبد خرید',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }

  // Add all wishlist items to cart
  Future<void> addAllToCart() async {
    try {
      if (wishlistItems.isEmpty) {
        Get.snackbar(
          'اطلاع',
          'لیست علاقه‌مندی‌ها خالی است',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.withOpacity(0.1),
          colorText: Colors.orange,
        );
        return;
      }

      // Show confirmation dialog
      final result = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('افزودن همه به سبد خرید'),
          content: Text(
            '${wishlistItems.length} محصول به سبد خرید اضافه خواهد شد. ادامه می‌دهید؟',
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('لغو'),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('افزودن'),
            ),
          ],
        ),
      );

      if (result == true) {
        int addedCount = 0;
        for (final product in wishlistItems) {
          cartController.addToCart(product);
          addedCount++;
        }

        Get.snackbar(
          'افزوده شد',
          '$addedCount محصول به سبد خرید اضافه شد',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(16),
          mainButton: TextButton(
            onPressed: () {
              Get.toNamed('/cart');
              Get.closeCurrentSnackbar();
            },
            child: const Text('مشاهده سبد'),
          ),
        );
      }
    } catch (e) {
      print('Error adding all to cart: $e');
      Get.snackbar(
        'خطا',
        'خطا در افزودن محصولات به سبد خرید',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }

  // Share wishlist
  Future<void> shareWishlist() async {
    try {
      if (wishlistItems.isEmpty) {
        Get.snackbar(
          'اطلاع',
          'لیست علاقه‌مندی‌ها خالی است',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.withOpacity(0.1),
          colorText: Colors.orange,
        );
        return;
      }

      String shareText = 'لیست علاقه‌مندی‌های من:\n\n';
      for (int i = 0; i < wishlistItems.length; i++) {
        final product = wishlistItems[i];
        shareText += '${i + 1}. ${product.name}\n';
        shareText += '   برند: ${product.brand}\n';
        shareText += '   قیمت: ${product.price.toStringAsFixed(0)} تومان\n\n';
      }
      shareText += 'مجموع ${wishlistItems.length} محصول';

      await Share.share(shareText, subject: 'لیست علاقه‌مندی‌های من');
    } catch (e) {
      print('Error sharing wishlist: $e');
      Get.snackbar(
        'خطا',
        'خطا در اشتراک‌گذاری لیست علاقه‌مندی‌ها',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }

  // Get total value of wishlist
  double get totalValue {
    return wishlistItems.fold(0.0, (total, product) => total + product.price);
  }

  // Get wishlist count
  int get wishlistCount => wishlistItems.length;

  // Check if wishlist is empty
  bool get isEmpty => wishlistItems.isEmpty;

  // Check if wishlist is not empty
  bool get isNotEmpty => wishlistItems.isNotEmpty;

  // Get products by category
  List<Product> getProductsByCategory(String category) {
    return wishlistItems
        .where((product) => product.category == category)
        .toList();
  }

  // Search in wishlist
  List<Product> searchWishlist(String query) {
    if (query.isEmpty) return wishlistItems;

    return wishlistItems.where((product) {
      return product.name.toLowerCase().contains(query.toLowerCase()) ||
          product.brand.toLowerCase().contains(query.toLowerCase()) ||
          product.category.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // Sort wishlist
  void sortWishlist(String sortBy) {
    switch (sortBy) {
      case 'name_asc':
        wishlistItems.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'name_desc':
        wishlistItems.sort((a, b) => b.name.compareTo(a.name));
        break;
      case 'price_asc':
        wishlistItems.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_desc':
        wishlistItems.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'brand_asc':
        wishlistItems.sort((a, b) => a.brand.compareTo(b.brand));
        break;
      case 'brand_desc':
        wishlistItems.sort((a, b) => b.brand.compareTo(a.brand));
        break;
      default:
        break;
    }
    wishlistItems.refresh();
  }

  // Get recently added products (last 5)
  List<Product> getRecentlyAdded() {
    if (wishlistItems.length <= 5) return wishlistItems;
    return wishlistItems.sublist(wishlistItems.length - 5);
  }

  // Export wishlist data
  Map<String, dynamic> exportWishlist() {
    return {
      'wishlist': wishlistItems.map((product) => product.toJson()).toList(),
      'total_items': wishlistItems.length,
      'total_value': totalValue,
      'exported_at': DateTime.now().toIso8601String(),
    };
  }

  // Import wishlist data
  Future<void> importWishlist(Map<String, dynamic> data) async {
    try {
      if (data['wishlist'] != null) {
        wishlistItems.clear();
        for (var item in data['wishlist']) {
          wishlistItems.add(Product.fromJson(item));
        }
        await saveWishlist();

        Get.snackbar(
          'وارد شد',
          'لیست علاقه‌مندی‌ها با موفقیت وارد شد',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
        );
      }
    } catch (e) {
      print('Error importing wishlist: $e');
      Get.snackbar(
        'خطا',
        'خطا در وارد کردن لیست علاقه‌مندی‌ها',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    }
  }
}
