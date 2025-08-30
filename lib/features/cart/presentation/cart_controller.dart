// Cart Controller using GetX
import 'package:get/get.dart';
import '../../../core/models/shop_models.dart';
import '../../../core/data/mock_data.dart';

class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCartItems();
  }

  void loadCartItems() {
    isLoading.value = true;
    // Simulate API call delay
    Future.delayed(const Duration(milliseconds: 500), () {
      cartItems.value = MockData.getCartItems();
      isLoading.value = false;
    });
  }

  double get subtotal {
    return cartItems.fold(
      0,
      (total, item) => total + (item.product.price * item.quantity),
    );
  }

  double get tax {
    return subtotal * 0.1; // 10% tax
  }

  double get shipping {
    return subtotal > 100 ? 0 : 10; // Free shipping over $100
  }

  double get total {
    return subtotal + tax + shipping;
  }

  void clearCart() {
    cartItems.clear();
  }

  void removeItem(CartItem item) {
    cartItems.remove(item);
  }

  void updateQuantity(CartItem item, int quantity) {
    if (quantity <= 0) {
      removeItem(item);
      return;
    }

    final index = cartItems.indexOf(item);
    if (index != -1) {
      cartItems[index] = CartItem(
        id: item.id,
        product: item.product,
        quantity: quantity,
        selectedColor: item.selectedColor,
        selectedSize: item.selectedSize,
        addedAt: item.addedAt,
      );
      cartItems.refresh();
    }
  }

  void addItem(Product product, {int quantity = 1}) {
    final existingItem = cartItems.firstWhereOrNull(
      (item) => item.product.id == product.id,
    );

    if (existingItem != null) {
      updateQuantity(existingItem, existingItem.quantity + quantity);
    } else {
      cartItems.add(
        CartItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          product: product,
          quantity: quantity,
          addedAt: DateTime.now(),
        ),
      );
    }
  }
}
