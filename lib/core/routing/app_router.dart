// App Router Configuration
import 'package:flutter/material.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/categories/presentation/pages/categories_page.dart';
import '../../features/products/presentation/pages/products_page.dart';
import '../../features/products/presentation/pages/product_details_page.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';

class AppRouter {
  // Route names
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String products = '/products';
  static const String productDetails = '/product-details';
  static const String categories = '/categories';
  static const String categoryProducts = '/category-products';
  static const String specialOffers = '/special-offers';
  static const String featuredProducts = '/featured-products';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orders = '/orders';
  static const String orderDetails = '/order-details';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String search = '/search';
  static const String wishlist = '/wishlist';

  // Route generator
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Splash Screen'))),
        );

      case onboarding:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Onboarding Screen'))),
        );

      case login:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Login Screen'))),
        );

      case register:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Register Screen'))),
        );

      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());

      case categories:
        return MaterialPageRoute(builder: (_) => const CategoriesPage());

      case categoryProducts:
        final args = settings.arguments as Map<String, dynamic>?;
        final categoryId = args?['categoryId'] as String?;
        final categoryName = args?['categoryName'] as String?;
        return MaterialPageRoute(
          builder: (_) =>
              ProductsPage(categoryId: categoryId, categoryName: categoryName),
        );

      case specialOffers:
        return MaterialPageRoute(
          builder: (_) => const ProductsPage(searchQuery: 'special_offers'),
        );

      case featuredProducts:
        return MaterialPageRoute(
          builder: (_) => const ProductsPage(searchQuery: 'featured_products'),
        );

      case products:
        return MaterialPageRoute(builder: (_) => const ProductsPage());

      case productDetails:
        final args = settings.arguments as Map<String, dynamic>?;
        final productId = args?['productId'] as String?;
        if (productId == null) {
          return _errorRoute('Product ID is required');
        }
        return MaterialPageRoute(
          builder: (_) => ProductDetailsPage(productId: productId),
        );

      case cart:
        return MaterialPageRoute(builder: (_) => const CartPage());

      case profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());

      case search:
        final args = settings.arguments as Map<String, dynamic>?;
        final query = args?['query'] as String?;
        return MaterialPageRoute(
          builder: (_) => ProductsPage(searchQuery: query),
        );

      case wishlist:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('لیست علاقه‌مندی‌ها')),
            body: const Center(child: Text('صفحه لیست علاقه‌مندی‌ها')),
          ),
        );

      case AppRouter.settings:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('تنظیمات')),
            body: const Center(child: Text('صفحه تنظیمات')),
          ),
        );

      default:
        return _errorRoute('صفحه مورد نظر یافت نشد');
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('خطا')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                message,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
