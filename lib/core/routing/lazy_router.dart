// Lazy Loading Router Implementation
import 'package:flutter/material.dart';

class LazyRouter {
  // Route names (same as AppRouter)
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

  // Lazy loaded page builders using deferred imports
  static final Map<String, Future<Widget> Function()> _pageBuilders = {
    home: () => _loadHomePage(),
    categories: () => _loadCategoriesPage(),
    products: () => _loadProductsPage(),
    productDetails: () => _loadProductDetailsPage(),
    cart: () => _loadCartPage(),
    profile: () => _loadProfilePage(),
    editProfile: () => _loadEditProfilePage(),
    securitySettings: () => _loadSecuritySettingsPage(),
    addresses: () => _loadAddressesPage(),
    paymentMethods: () => _loadPaymentMethodsPage(),
    reviews: () => _loadReviewsPage(),
    notifications: () => _loadNotificationsPage(),
    faq: () => _loadFAQPage(),
    support: () => _loadSupportPage(),
    about: () => _loadAboutPage(),
    privacy: () => _loadPrivacyPolicyPage(),
    settings: () => _loadSettingsPage(),
  };

  // Page loading functions - these will be implemented with deferred loading
  static Future<Widget> _loadHomePage() async {
    // Simulate network delay for lazy loading
    await Future.delayed(const Duration(milliseconds: 100));
    // Dynamic import would go here
    final module = await import(
      '../../features/home/presentation/pages/home_page.dart',
    );
    return module.HomePage();
  }

  static Future<Widget> _loadCategoriesPage() async {
    await Future.delayed(const Duration(milliseconds: 100));
    final module = await import(
      '../../features/categories/presentation/pages/categories_page.dart',
    );
    return module.CategoriesPage();
  }

  static Future<Widget> _loadProductsPage() async {
    await Future.delayed(const Duration(milliseconds: 100));
    final module = await import(
      '../../features/products/presentation/pages/products_page.dart',
    );
    return module.ProductsPage();
  }

  static Future<Widget> _loadProductDetailsPage() async {
    await Future.delayed(const Duration(milliseconds: 100));
    final module = await import(
      '../../features/products/presentation/pages/product_details_page.dart',
    );
    return module.ProductDetailsPage(productId: ''); // This will be overridden
  }

  static Future<Widget> _loadCartPage() async {
    await Future.delayed(const Duration(milliseconds: 100));
    final module = await import(
      '../../features/cart/presentation/pages/cart_page.dart',
    );
    return module.CartPage();
  }

  static Future<Widget> _loadProfilePage() async {
    await Future.delayed(const Duration(milliseconds: 100));
    final module = await import(
      '../../features/profile/presentation/pages/profile_page.dart',
    );
    return module.ProfilePage();
  }

  static Future<Widget> _loadEditProfilePage() async {
    await Future.delayed(const Duration(milliseconds: 100));
    final module = await import(
      '../../features/profile/presentation/pages/edit_profile_page.dart',
    );
    return module.EditProfilePage();
  }

  static Future<Widget> _loadSecuritySettingsPage() async {
    await Future.delayed(const Duration(milliseconds: 100));
    final module = await import(
      '../../features/profile/presentation/pages/security_settings_page.dart',
    );
    return module.SecuritySettingsPage();
  }

  static Future<Widget> _loadAddressesPage() async {
    await Future.delayed(const Duration(milliseconds: 100));
    final module = await import(
      '../../features/profile/presentation/pages/addresses_page.dart',
    );
    return module.AddressesPage();
  }

  static Future<Widget> _loadPaymentMethodsPage() async {
    await Future.delayed(const Duration(milliseconds: 100));
    final module = await import(
      '../../features/profile/presentation/pages/payment_methods_page.dart',
    );
    return module.PaymentMethodsPage();
  }

  static Future<Widget> _loadReviewsPage() async {
    await Future.delayed(const Duration(milliseconds: 100));
    final module = await import(
      '../../features/profile/presentation/pages/reviews_page.dart',
    );
    return module.ReviewsPage();
  }

  static Future<Widget> _loadNotificationsPage() async {
    await Future.delayed(const Duration(milliseconds: 100));
    final module = await import(
      '../../features/profile/presentation/pages/notifications_settings_page.dart',
    );
    return module.NotificationsSettingsPage();
  }

  static Future<Widget> _loadFAQPage() async {
    await Future.delayed(const Duration(milliseconds: 100));
    final module = await import(
      '../../features/profile/presentation/pages/faq_page.dart',
    );
    return module.FAQPage();
  }

  static Future<Widget> _loadSupportPage() async {
    await Future.delayed(const Duration(milliseconds: 100));
    final module = await import(
      '../../features/profile/presentation/pages/support_page.dart',
    );
    return module.SupportPage();
  }

  static Future<Widget> _loadAboutPage() async {
    await Future.delayed(const Duration(milliseconds: 100));
    final module = await import(
      '../../features/profile/presentation/pages/about_page.dart',
    );
    return module.AboutPage();
  }

  static Future<Widget> _loadPrivacyPolicyPage() async {
    await Future.delayed(const Duration(milliseconds: 100));
    final module = await import(
      '../../features/profile/presentation/pages/privacy_policy_page.dart',
    );
    return module.PrivacyPolicyPage();
  }

  static Future<Widget> _loadSettingsPage() async {
    await Future.delayed(const Duration(milliseconds: 100));
    final module = await import(
      '../../features/profile/presentation/pages/settings_page.dart',
    );
    return module.SettingsPage();
  }

  // Simulate dynamic import - In a real implementation, this would use deferred imports
  static Future<dynamic> import(String path) async {
    // This is a placeholder - in reality you'd use deferred imports
    await Future.delayed(const Duration(milliseconds: 50));

    // Return a mock module with the required class
    switch (path) {
      case '../../features/home/presentation/pages/home_page.dart':
        return _HomePageModule();
      case '../../features/categories/presentation/pages/categories_page.dart':
        return _CategoriesPageModule();
      case '../../features/products/presentation/pages/products_page.dart':
        return _ProductsPageModule();
      case '../../features/products/presentation/pages/product_details_page.dart':
        return _ProductDetailsPageModule();
      case '../../features/cart/presentation/pages/cart_page.dart':
        return _CartPageModule();
      case '../../features/profile/presentation/pages/profile_page.dart':
        return _ProfilePageModule();
      default:
        return _DefaultModule();
    }
  }

  // Route generator with lazy loading
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final pageName = settings.name ?? splash;

    if (_pageBuilders.containsKey(pageName)) {
      return MaterialPageRoute(
        builder: (_) => LazyPageWrapper(
          pageBuilder: _pageBuilders[pageName]!,
          routeName: pageName,
          arguments: settings.arguments,
        ),
      );
    }

    // Handle routes with arguments
    switch (pageName) {
      case categoryProducts:
        return MaterialPageRoute(
          builder: (_) => LazyPageWrapper(
            pageBuilder: () =>
                _loadProductsPageWithCategory(settings.arguments),
            routeName: pageName,
            arguments: settings.arguments,
          ),
        );

      case productDetails:
        return MaterialPageRoute(
          builder: (_) => LazyPageWrapper(
            pageBuilder: () =>
                _loadProductDetailsPageWithId(settings.arguments),
            routeName: pageName,
            arguments: settings.arguments,
          ),
        );

      case search:
        return MaterialPageRoute(
          builder: (_) => LazyPageWrapper(
            pageBuilder: () => _loadProductsPageWithSearch(settings.arguments),
            routeName: pageName,
            arguments: settings.arguments,
          ),
        );

      default:
        return _errorRoute('صفحه مورد نظر یافت نشد');
    }
  }

  static Future<Widget> _loadProductsPageWithCategory(dynamic arguments) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final args = arguments as Map<String, dynamic>?;
    final categoryId = args?['categoryId'] as String?;
    final categoryName = args?['categoryName'] as String?;
    final module = await import(
      '../../features/products/presentation/pages/products_page.dart',
    );
    return module.ProductsPage(
      categoryId: categoryId,
      categoryName: categoryName,
    );
  }

  static Future<Widget> _loadProductDetailsPageWithId(dynamic arguments) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final args = arguments as Map<String, dynamic>?;
    final productId = args?['productId'] as String?;
    if (productId == null) throw Exception('Product ID is required');
    final module = await import(
      '../../features/products/presentation/pages/product_details_page.dart',
    );
    return module.ProductDetailsPage(productId: productId);
  }

  static Future<Widget> _loadProductsPageWithSearch(dynamic arguments) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final args = arguments as Map<String, dynamic>?;
    final query = args?['query'] as String?;
    final module = await import(
      '../../features/products/presentation/pages/products_page.dart',
    );
    return module.ProductsPage(searchQuery: query);
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

// Lazy page wrapper that shows loading while page is being loaded
class LazyPageWrapper extends StatelessWidget {
  final Future<Widget> Function() pageBuilder;
  final String routeName;
  final dynamic arguments;

  const LazyPageWrapper({
    super.key,
    required this.pageBuilder,
    required this.routeName,
    this.arguments,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: pageBuilder(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LazyLoadingPage();
        } else if (snapshot.hasError) {
          return LazyErrorPage(error: snapshot.error.toString());
        } else if (snapshot.hasData) {
          return snapshot.data!;
        } else {
          return const LazyLoadingPage();
        }
      },
    );
  }
}

// Loading page shown while lazy loading
class LazyLoadingPage extends StatelessWidget {
  const LazyLoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'در حال بارگیری...',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}

// Error page for lazy loading failures
class LazyErrorPage extends StatelessWidget {
  final String error;

  const LazyErrorPage({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('خطا')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'خطا در بارگیری صفحه',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('بازگشت'),
            ),
          ],
        ),
      ),
    );
  }
}

// Mock modules for simulating dynamic imports
class _HomePageModule {
  Widget HomePage() => const _PlaceholderPage('صفحه خانه');
}

class _CategoriesPageModule {
  Widget CategoriesPage() => const _PlaceholderPage('صفحه دسته‌بندی‌ها');
}

class _ProductsPageModule {
  Widget ProductsPage({
    String? categoryId,
    String? categoryName,
    String? searchQuery,
  }) => const _PlaceholderPage('صفحه محصولات');
}

class _ProductDetailsPageModule {
  Widget ProductDetailsPage({required String productId}) =>
      const _PlaceholderPage('جزئیات محصول');
}

class _CartPageModule {
  Widget CartPage() => const _PlaceholderPage('سبد خرید');
}

class _ProfilePageModule {
  Widget ProfilePage() => const _PlaceholderPage('پروفایل');
}

class _DefaultModule {
  Widget DefaultPage() => const _PlaceholderPage('صفحه پیش‌فرض');
}

class _PlaceholderPage extends StatelessWidget {
  final String title;

  const _PlaceholderPage(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          '$title (Lazy Loaded)',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
