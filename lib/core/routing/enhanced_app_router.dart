// Enhanced App Router with Deferred Loading
import 'package:flutter/material.dart';
import 'deferred_page_loader.dart';

class EnhancedAppRouter {
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

  // Route generator with deferred loading
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const _SplashPage());

      case onboarding:
        return MaterialPageRoute(
          builder: (_) => const _PlaceholderPage('Onboarding'),
        );

      case login:
        return MaterialPageRoute(
          builder: (_) => const _PlaceholderPage('Login'),
        );

      case register:
        return MaterialPageRoute(
          builder: (_) => const _PlaceholderPage('Register'),
        );

      case home:
        return MaterialPageRoute(
          builder: (_) => DeferredPageWrapper(
            pageLoader: () => DeferredPageLoader.loadHomePage(),
            pageName: 'خانه',
          ),
        );

      case categories:
        return MaterialPageRoute(
          builder: (_) => DeferredPageWrapper(
            pageLoader: () => DeferredPageLoader.loadCategoriesPage(),
            pageName: 'دسته‌بندی‌ها',
          ),
        );

      case categoryProducts:
        final args = settings.arguments as Map<String, dynamic>?;
        final categoryId = args?['categoryId'] as String?;
        final categoryName = args?['categoryName'] as String?;
        return MaterialPageRoute(
          builder: (_) => DeferredPageWrapper(
            pageLoader: () => DeferredPageLoader.loadProductsPage(
              categoryId: categoryId,
              categoryName: categoryName,
            ),
            pageName: categoryName ?? 'محصولات دسته‌بندی',
          ),
        );

      case specialOffers:
        return MaterialPageRoute(
          builder: (_) => DeferredPageWrapper(
            pageLoader: () => DeferredPageLoader.loadProductsPage(
              searchQuery: 'special_offers',
            ),
            pageName: 'پیشنهادات ویژه',
          ),
        );

      case featuredProducts:
        return MaterialPageRoute(
          builder: (_) => DeferredPageWrapper(
            pageLoader: () => DeferredPageLoader.loadProductsPage(
              searchQuery: 'featured_products',
            ),
            pageName: 'محصولات ویژه',
          ),
        );

      case products:
        return MaterialPageRoute(
          builder: (_) => DeferredPageWrapper(
            pageLoader: () => DeferredPageLoader.loadProductsPage(),
            pageName: 'محصولات',
          ),
        );

      case productDetails:
        final args = settings.arguments as Map<String, dynamic>?;
        final productId = args?['productId'] as String?;
        if (productId == null) {
          return _errorRoute('شناسه محصول الزامی است');
        }
        return MaterialPageRoute(
          builder: (_) => DeferredPageWrapper(
            pageLoader: () =>
                DeferredPageLoader.loadProductDetailsPage(productId: productId),
            pageName: 'جزئیات محصول',
          ),
        );

      case cart:
        return MaterialPageRoute(
          builder: (_) => DeferredPageWrapper(
            pageLoader: () => DeferredPageLoader.loadCartPage(),
            pageName: 'سبد خرید',
          ),
        );

      case profile:
        return MaterialPageRoute(
          builder: (_) => DeferredPageWrapper(
            pageLoader: () => DeferredPageLoader.loadProfilePage(),
            pageName: 'پروفایل',
          ),
        );

      case editProfile:
        return MaterialPageRoute(
          builder: (_) => DeferredPageWrapper(
            pageLoader: () => DeferredPageLoader.loadEditProfilePage(),
            pageName: 'ویرایش پروفایل',
          ),
        );

      case securitySettings:
        return MaterialPageRoute(
          builder: (_) => DeferredPageWrapper(
            pageLoader: () => DeferredPageLoader.loadSecuritySettingsPage(),
            pageName: 'تنظیمات امنیت',
          ),
        );

      case addresses:
        return MaterialPageRoute(
          builder: (_) => DeferredPageWrapper(
            pageLoader: () => DeferredPageLoader.loadAddressesPage(),
            pageName: 'آدرس‌ها',
          ),
        );

      case paymentMethods:
        return MaterialPageRoute(
          builder: (_) => DeferredPageWrapper(
            pageLoader: () => DeferredPageLoader.loadPaymentMethodsPage(),
            pageName: 'روش‌های پرداخت',
          ),
        );

      case reviews:
        return MaterialPageRoute(
          builder: (_) => DeferredPageWrapper(
            pageLoader: () => DeferredPageLoader.loadReviewsPage(),
            pageName: 'نظرات',
          ),
        );

      case notifications:
        return MaterialPageRoute(
          builder: (_) => DeferredPageWrapper(
            pageLoader: () => DeferredPageLoader.loadNotificationsPage(),
            pageName: 'اعلان‌ها',
          ),
        );

      case faq:
        return MaterialPageRoute(
          builder: (_) => DeferredPageWrapper(
            pageLoader: () => DeferredPageLoader.loadFAQPage(),
            pageName: 'سوالات متداول',
          ),
        );

      case support:
        return MaterialPageRoute(
          builder: (_) => DeferredPageWrapper(
            pageLoader: () => DeferredPageLoader.loadSupportPage(),
            pageName: 'پشتیبانی',
          ),
        );

      case about:
        return MaterialPageRoute(
          builder: (_) => DeferredPageWrapper(
            pageLoader: () => DeferredPageLoader.loadAboutPage(),
            pageName: 'درباره ما',
          ),
        );

      case privacy:
        return MaterialPageRoute(
          builder: (_) => DeferredPageWrapper(
            pageLoader: () => DeferredPageLoader.loadPrivacyPolicyPage(),
            pageName: 'حریم خصوصی',
          ),
        );

      case search:
        final args = settings.arguments as Map<String, dynamic>?;
        final query = args?['query'] as String?;
        return MaterialPageRoute(
          builder: (_) => DeferredPageWrapper(
            pageLoader: () =>
                DeferredPageLoader.loadProductsPage(searchQuery: query),
            pageName: 'جستجو',
          ),
        );

      case wishlist:
        return MaterialPageRoute(
          builder: (_) => const _PlaceholderPage('لیست علاقه‌مندی‌ها'),
        );

      case EnhancedAppRouter.settings:
        return MaterialPageRoute(
          builder: (_) => DeferredPageWrapper(
            pageLoader: () => DeferredPageLoader.loadSettingsPage(),
            pageName: 'تنظیمات',
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

  /// Preload critical pages for better performance
  static Future<void> preloadCriticalPages() async {
    await DeferredPageLoader.preloadCriticalPages();
  }
}

/// Widget wrapper for deferred loading with loading indicator
class DeferredPageWrapper extends StatelessWidget {
  final Future<Widget> Function() pageLoader;
  final String pageName;

  const DeferredPageWrapper({
    super.key,
    required this.pageLoader,
    required this.pageName,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: pageLoader(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return DeferredLoadingPage(pageName: pageName);
        } else if (snapshot.hasError) {
          return DeferredErrorPage(
            error: snapshot.error.toString(),
            pageName: pageName,
            onRetry: () {
              // Trigger rebuild to retry loading
              (context as Element).markNeedsBuild();
            },
          );
        } else if (snapshot.hasData) {
          return snapshot.data!;
        } else {
          return DeferredLoadingPage(pageName: pageName);
        }
      },
    );
  }
}

/// Loading page shown during deferred loading
class DeferredLoadingPage extends StatelessWidget {
  final String pageName;

  const DeferredLoadingPage({super.key, required this.pageName});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0A0A0A)
          : const Color(0xFFF8F9FA),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [const Color(0xFF0A0A0A), const Color(0xFF1A1A1A)]
                : [const Color(0xFFF8F9FA), const Color(0xFFE3F2FD)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Modern loading indicator
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF3B82F6),
                      const Color(0xFF6366F1),
                      const Color(0xFF8B5CF6),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
                      blurRadius: 20,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: const Padding(
                  padding: EdgeInsets.all(15),
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'در حال بارگیری $pageName...',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: isDark ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 32),
                width: 200,
                child: LinearProgressIndicator(
                  value: DeferredPageLoader.getLoadingProgress(),
                  backgroundColor: isDark ? Colors.grey[800] : Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    const Color(0xFF3B82F6),
                  ),
                  minHeight: 4,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '${(DeferredPageLoader.getLoadingProgress() * 100).toInt()}% کامل شده',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Error page for deferred loading failures
class DeferredErrorPage extends StatelessWidget {
  final String error;
  final String pageName;
  final VoidCallback onRetry;

  const DeferredErrorPage({
    super.key,
    required this.error,
    required this.pageName,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pageName)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'خطا در بارگیری $pageName',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                error,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('بازگشت'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: onRetry,
                    child: const Text('تلاش مجدد'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Simple splash page
class _SplashPage extends StatelessWidget {
  const _SplashPage();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(size: 100),
            SizedBox(height: 24),
            Text(
              'خوش آمدید',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

/// Placeholder page for non-critical routes
class _PlaceholderPage extends StatelessWidget {
  final String title;

  const _PlaceholderPage(this.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 64, color: Colors.grey.shade600),
            const SizedBox(height: 16),
            Text('صفحه $title', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'در حال توسعه...',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
