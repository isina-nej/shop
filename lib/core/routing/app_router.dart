// App Router Configuration
import 'package:flutter/material.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/categories/presentation/pages/categories_page.dart';
import '../../features/products/presentation/pages/products_page.dart';
import '../../features/products/presentation/pages/product_details_page.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/profile/presentation/pages/addresses_page.dart';
import '../../features/profile/presentation/pages/security_settings_page.dart';
import '../../features/profile/presentation/pages/payment_methods_page.dart';
import '../../features/profile/presentation/pages/reviews_page.dart';
import '../../features/profile/presentation/pages/notifications_settings_page.dart';
import '../../features/profile/presentation/pages/faq_page.dart';
import '../../features/profile/presentation/pages/support_page.dart';
import '../../features/profile/presentation/pages/about_page.dart';
import '../../features/profile/presentation/pages/privacy_policy_page.dart';
import '../../features/profile/presentation/pages/settings_page.dart';

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
  static const String editProfile = '/edit-profile';
  static const String securitySettings = '/security-settings';
  static const String addresses = '/addresses';
  static const String paymentMethods = '/payment-methods';
  static const String reviews = '/reviews';
  static const String notifications = '/notifications';
  static const String faq = '/faq';
  static const String support = '/support';
  static const String about = '/about';
  static const String privacy = '/privacy';
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

      case editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfilePage());

      case securitySettings:
        return MaterialPageRoute(builder: (_) => const SecuritySettingsPage());

      case addresses:
        return MaterialPageRoute(builder: (_) => const AddressesPage());

      case paymentMethods:
        return MaterialPageRoute(builder: (_) => const PaymentMethodsPage());

      case reviews:
        return MaterialPageRoute(builder: (_) => const ReviewsPage());

      case notifications:
        return MaterialPageRoute(
          builder: (_) => const NotificationsSettingsPage(),
        );

      case faq:
        return MaterialPageRoute(builder: (_) => const FAQPage());

      case support:
        return MaterialPageRoute(builder: (_) => const SupportPage());

      case about:
        return MaterialPageRoute(builder: (_) => const AboutPage());

      case privacy:
        return MaterialPageRoute(builder: (_) => const PrivacyPolicyPage());

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
        return MaterialPageRoute(builder: (_) => const SettingsPage());

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
