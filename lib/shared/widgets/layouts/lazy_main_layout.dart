// Lazy Main Layout Widget with Dynamic Page Loading
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/localization_extension.dart';

class LazyMainLayout extends StatefulWidget {
  const LazyMainLayout({super.key});

  @override
  State<LazyMainLayout> createState() => _LazyMainLayoutState();
}

class _LazyMainLayoutState extends State<LazyMainLayout> {
  int _currentIndex = 0;

  // Page builders that will load pages only when needed
  final List<Future<Widget> Function()> _pageBuilders = [
    () => _loadHomePage(),
    () => _loadProductsPage(),
    () => _loadCartPage(),
    () => _loadProfilePage(),
  ];

  // Cache for already loaded pages
  final Map<int, Widget> _loadedPages = {};
  final Map<int, bool> _loadingStates = {};

  static Future<Widget> _loadHomePage() async {
    // Simulate loading time
    await Future.delayed(const Duration(milliseconds: 200));
    // In real implementation, use deferred import here
    final module = await import(
      '../../features/home/presentation/pages/home_page.dart',
    );
    return module.HomePage();
  }

  static Future<Widget> _loadProductsPage() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final module = await import(
      '../../features/products/presentation/pages/products_page.dart',
    );
    return module.ProductsPage();
  }

  static Future<Widget> _loadCartPage() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final module = await import(
      '../../features/cart/presentation/pages/cart_page.dart',
    );
    return module.CartPage();
  }

  static Future<Widget> _loadProfilePage() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final module = await import(
      '../../features/profile/presentation/pages/profile_page.dart',
    );
    return module.ProfilePage();
  }

  // Simulate dynamic import (replace with real deferred imports)
  static Future<dynamic> import(String path) async {
    await Future.delayed(const Duration(milliseconds: 100));

    switch (path) {
      case '../../features/home/presentation/pages/home_page.dart':
        return _HomeModule();
      case '../../features/products/presentation/pages/products_page.dart':
        return _ProductsModule();
      case '../../features/cart/presentation/pages/cart_page.dart':
        return _CartModule();
      case '../../features/profile/presentation/pages/profile_page.dart':
        return _ProfileModule();
      default:
        return _DefaultModule();
    }
  }

  @override
  void initState() {
    super.initState();
    // Pre-load the home page
    _loadPage(0);
  }

  void _loadPage(int index) {
    if (_loadedPages.containsKey(index) || _loadingStates[index] == true) {
      return; // Page already loaded or loading
    }

    setState(() {
      _loadingStates[index] = true;
    });

    _pageBuilders[index]()
        .then((page) {
          if (mounted) {
            setState(() {
              _loadedPages[index] = page;
              _loadingStates[index] = false;
            });
          }
        })
        .catchError((error) {
          if (mounted) {
            setState(() {
              _loadedPages[index] = _ErrorPage(error: error.toString());
              _loadingStates[index] = false;
            });
          }
        });
  }

  void _onTabTapped(int index) {
    if (index != _currentIndex) {
      _loadPage(index); // Start loading if not already loaded
    }
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _getCurrentPage() {
    if (_loadedPages.containsKey(_currentIndex)) {
      return _loadedPages[_currentIndex]!;
    } else if (_loadingStates[_currentIndex] == true) {
      return const _LoadingPage();
    } else {
      // Start loading if not started yet
      _loadPage(_currentIndex);
      return const _LoadingPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _getCurrentPage(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.surfaceDark
            : AppColors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.textSecondaryDark
            : AppColors.textSecondaryLight,
        items: [
          BottomNavigationBarItem(
            icon: _buildTabIcon(Icons.home_outlined, 0),
            activeIcon: _buildTabIcon(Icons.home, 0),
            label: context.tr('home'),
          ),
          BottomNavigationBarItem(
            icon: _buildTabIcon(Icons.shopping_bag_outlined, 1),
            activeIcon: _buildTabIcon(Icons.shopping_bag, 1),
            label: context.tr('products'),
          ),
          BottomNavigationBarItem(
            icon: _buildTabIcon(Icons.shopping_cart_outlined, 2),
            activeIcon: _buildTabIcon(Icons.shopping_cart, 2),
            label: context.tr('cart'),
          ),
          BottomNavigationBarItem(
            icon: _buildTabIcon(Icons.person_outline, 3),
            activeIcon: _buildTabIcon(Icons.person, 3),
            label: context.tr('profile'),
          ),
        ],
      ),
    );
  }

  Widget _buildTabIcon(IconData icon, int index) {
    final isLoading = _loadingStates[index] == true;
    final isLoaded = _loadedPages.containsKey(index);

    return Stack(
      children: [
        Icon(icon),
        if (isLoading && !isLoaded)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}

// Loading page component
class _LoadingPage extends StatelessWidget {
  const _LoadingPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            SizedBox(height: 16.0.h),
            Text(
              context.tr('loading_page'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}

// Error page component
class _ErrorPage extends StatelessWidget {
  final String error;

  const _ErrorPage({required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            SizedBox(height: 16.0.h),
            Text(
              context.tr('error_loading'),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 8.0.h),
            Text(
              error,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Mock modules for testing (replace with actual pages)
class _HomeModule {
  Widget homePage() => const _MockPage('home', Icons.home, Colors.blue);
}

class _ProductsModule {
  Widget productsPage() =>
      const _MockPage('products', Icons.shopping_bag, Colors.green);
}

class _CartModule {
  Widget cartPage() =>
      const _MockPage('cart', Icons.shopping_cart, Colors.orange);
}

class _ProfileModule {
  Widget profilePage() =>
      const _MockPage('profile', Icons.person, Colors.purple);
}

class _DefaultModule {
  Widget defaultPage() => const _MockPage('default', Icons.error, Colors.red);
}

// Mock page for testing
class _MockPage extends StatelessWidget {
  final String titleKey;
  final IconData icon;
  final Color color;

  const _MockPage(this.titleKey, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.tr(titleKey)),
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 120, color: color),
            SizedBox(height: 24.0.h),
            Text(
              '${context.tr(titleKey)} ${context.tr('lazy_loaded')}',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: color),
              ),
              child: Text(
                context.tr('page_lazy_loaded_success'),
                style: TextStyle(
                  fontSize: 14.0.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
