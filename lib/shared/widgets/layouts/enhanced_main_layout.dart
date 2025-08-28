// Enhanced Main Layout with Deferred Loading Integration
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routing/deferred_page_loader.dart';

class EnhancedMainLayout extends StatefulWidget {
  const EnhancedMainLayout({super.key});

  @override
  State<EnhancedMainLayout> createState() => _EnhancedMainLayoutState();
}

class _EnhancedMainLayoutState extends State<EnhancedMainLayout>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  late TabController _tabController;

  // Cache for loaded pages
  final Map<int, Widget> _pageCache = {};
  final Map<int, bool> _loadingStates = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    // Preload critical pages
    _preloadCriticalPages();

    // Load home page immediately
    _loadPage(0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _preloadCriticalPages() async {
    try {
      await DeferredPageLoader.preloadCriticalPages();
    } catch (e) {
      debugPrint('Error preloading critical pages: $e');
    }
  }

  void _loadPage(int index) async {
    if (_pageCache.containsKey(index) || _loadingStates[index] == true) {
      return; // Already loaded or loading
    }

    setState(() {
      _loadingStates[index] = true;
    });

    try {
      Widget page;
      switch (index) {
        case 0:
          page = await DeferredPageLoader.loadHomePage();
          break;
        case 1:
          page = await DeferredPageLoader.loadProductsPage();
          break;
        case 2:
          page = await DeferredPageLoader.loadCartPage();
          break;
        case 3:
          page = await DeferredPageLoader.loadProfilePage();
          break;
        default:
          page = const _ErrorPage(message: 'صفحه نامعتبر');
      }

      if (mounted) {
        setState(() {
          _pageCache[index] = page;
          _loadingStates[index] = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _pageCache[index] = _ErrorPage(
            message: 'خطا در بارگیری: $error',
            onRetry: () => _retryLoadPage(index),
          );
          _loadingStates[index] = false;
        });
      }
    }
  }

  void _retryLoadPage(int index) {
    _pageCache.remove(index);
    _loadingStates.remove(index);
    _loadPage(index);
  }

  void _onTabTapped(int index) {
    if (index != _currentIndex) {
      _loadPage(index); // Preload if not already loaded
    }

    setState(() {
      _currentIndex = index;
    });
    _tabController.index = index;
  }

  Widget _getCurrentPage() {
    if (_pageCache.containsKey(_currentIndex)) {
      return _pageCache[_currentIndex]!;
    } else if (_loadingStates[_currentIndex] == true) {
      return _LoadingPage(pageName: _getPageName(_currentIndex));
    } else {
      _loadPage(_currentIndex);
      return _LoadingPage(pageName: _getPageName(_currentIndex));
    }
  }

  String _getPageName(int index) {
    switch (index) {
      case 0:
        return 'خانه';
      case 1:
        return 'محصولات';
      case 2:
        return 'سبد خرید';
      case 3:
        return 'پروفایل';
      default:
        return 'صفحه';
    }
  }

  Widget _buildTabIcon(IconData icon, IconData activeIcon, int index) {
    final isLoading = _loadingStates[index] == true;
    final isLoaded = _pageCache.containsKey(index);
    final isActive = _currentIndex == index;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            isActive ? activeIcon : icon,
            key: ValueKey(isActive),
            color: isActive
                ? Theme.of(context).primaryColor
                : Theme.of(context).brightness == Brightness.dark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
        ),
        if (isLoading && !isLoaded)
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              child: const SizedBox(
                width: 6,
                height: 6,
                child: CircularProgressIndicator(
                  strokeWidth: 1,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
          ),
        if (isLoaded && !isLoading)
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        child: _getCurrentPage(),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.surfaceDark
              : AppColors.white,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.textSecondaryDark
              : AppColors.textSecondaryLight,
          selectedFontSize: 12,
          unselectedFontSize: 11,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: _buildTabIcon(Icons.home_outlined, Icons.home, 0),
              label: 'خانه',
            ),
            BottomNavigationBarItem(
              icon: _buildTabIcon(
                Icons.shopping_bag_outlined,
                Icons.shopping_bag,
                1,
              ),
              label: 'محصولات',
            ),
            BottomNavigationBarItem(
              icon: _buildTabIcon(
                Icons.shopping_cart_outlined,
                Icons.shopping_cart,
                2,
              ),
              label: 'سبد خرید',
            ),
            BottomNavigationBarItem(
              icon: _buildTabIcon(Icons.person_outline, Icons.person, 3),
              label: 'پروفایل',
            ),
          ],
        ),
      ),
    );
  }
}

/// Loading page component
class _LoadingPage extends StatelessWidget {
  final String pageName;

  const _LoadingPage({required this.pageName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'در حال بارگیری $pageName...',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                value: DeferredPageLoader.getLoadingProgress(),
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor.withValues(alpha: 0.7),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'بارگیری کامپوننت‌ها...',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}

/// Error page component
class _ErrorPage extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const _ErrorPage({required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'خطا در بارگیری صفحه',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('تلاش مجدد'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
