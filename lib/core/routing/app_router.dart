// App Router Configuration
import 'package:flutter/material.dart';
import '../../core/localization/localization_extension.dart';
import '../../core/animations/page_transitions.dart';
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
        return PageTransitions.fadeTransition(
          Builder(
            builder: (context) => Scaffold(
              body: Center(child: Text(context.tr('splash_screen'))),
            ),
          ),
        );

      case onboarding:
        return PageTransitions.slideBottomToTop(
          Builder(
            builder: (context) => Scaffold(
              body: Center(child: Text(context.tr('onboarding_screen'))),
            ),
          ),
        );

      case login:
        return PageTransitions.slideRightToLeft(
          Builder(
            builder: (context) =>
                Scaffold(body: Center(child: Text(context.tr('login')))),
          ),
        );

      case register:
        return PageTransitions.slideRightToLeft(
          Builder(
            builder: (context) =>
                Scaffold(body: Center(child: Text(context.tr('register')))),
          ),
        );

      case home:
        return PageTransitions.slideRightToLeft(const HomePage());

      case categories:
        return PageTransitions.slideRightToLeft(const CategoriesPage());

      case categoryProducts:
        final args = settings.arguments as Map<String, dynamic>?;
        final categoryId = args?['categoryId'] as String?;
        final categoryName = args?['categoryName'] as String?;
        return PageTransitions.slideRightToLeft(
          ProductsPage(categoryId: categoryId, categoryName: categoryName),
        );

      case specialOffers:
        return PageTransitions.fadeTransition(
          const ProductsPage(searchQuery: 'special_offers'),
        );

      case featuredProducts:
        return PageTransitions.fadeTransition(
          const ProductsPage(searchQuery: 'featured_products'),
        );

      case products:
        return PageTransitions.slideRightToLeft(const ProductsPage());

      case productDetails:
        final args = settings.arguments as Map<String, dynamic>?;
        final productId = args?['productId'] as String?;
        if (productId == null) {
          return _errorRoute('Product ID is required');
        }
        return PageTransitions.scaleTransition(
          ProductDetailsPage(productId: productId),
        );

      case cart:
        return PageTransitions.slideRightToLeft(const CartPage());

      case profile:
        return PageTransitions.slideRightToLeft(const ProfilePage());

      case editProfile:
        return PageTransitions.scaleTransition(const EditProfilePage());

      case securitySettings:
        return PageTransitions.scaleTransition(const SecuritySettingsPage());

      case addresses:
        return PageTransitions.scaleTransition(const AddressesPage());

      case paymentMethods:
        return PageTransitions.scaleTransition(const PaymentMethodsPage());

      case reviews:
        return PageTransitions.scaleTransition(const ReviewsPage());

      case notifications:
        return PageTransitions.scaleTransition(
          const NotificationsSettingsPage(),
        );

      case faq:
        return PageTransitions.zoomTransition(const FAQPage());

      case support:
        return PageTransitions.zoomTransition(const SupportPage());

      case about:
        return PageTransitions.zoomTransition(const AboutPage());

      case privacy:
        return PageTransitions.scaleTransition(const PrivacyPolicyPage());

      case search:
        final args = settings.arguments as Map<String, dynamic>?;
        final query = args?['query'] as String?;
        return PageTransitions.fadeTransition(ProductsPage(searchQuery: query));

      case wishlist:
        return PageTransitions.slideAndScaleTransition(
          Builder(
            builder: (context) => Scaffold(
              appBar: AppBar(title: Text(context.tr('wishlist_title'))),
              body: Center(child: Text(context.tr('wishlist_page'))),
            ),
          ),
        );

      case AppRouter.settings:
        return PageTransitions.scaleTransition(const SettingsPage());

      default:
        return _errorRoute('page_not_found');
    }
  }

  static Route<dynamic> _errorRoute(String messageKey) {
    return PageTransitions.fadeTransition(
      Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text(context.tr('error_title'))),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  context.tr(messageKey),
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
