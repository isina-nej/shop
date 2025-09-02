// Main Layout Widget
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../features/home/presentation/pages/home_page.dart';
import '../../../features/products/presentation/pages/products_page.dart';
import '../../../features/cart/presentation/pages/cart_page.dart';
import '../../../features/profile/presentation/pages/profile_page.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/localization_extension.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  final FocusNode _focusNode = FocusNode();

  final List<Widget> _pages = [
    const HomePage(),
    const ProductsPage(),
    const CartPage(),
    const ProfilePage(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKey(KeyEvent event) {
    if (event is KeyDownEvent) {
      // اگر فوکوس روی فیلد ورودی است، فوکوس رو برداره و سپس جابجا کنه
      if (FocusManager.instance.primaryFocus?.context
                  ?.findAncestorWidgetOfExactType<TextField>() !=
              null ||
          FocusManager.instance.primaryFocus?.context
                  ?.findAncestorWidgetOfExactType<TextFormField>() !=
              null) {
        FocusManager.instance.primaryFocus?.unfocus();
        // کمی تاخیر بده تا فوکوس برداشته بشه
        Future.delayed(const Duration(milliseconds: 10), () {
          _performNavigation(event);
        });
        return;
      }

      _performNavigation(event);
    }
  }

  void _performNavigation(KeyEvent event) {
    int newIndex;
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      newIndex = (_currentIndex - 1).clamp(0, _pages.length - 1);
    } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      newIndex = (_currentIndex + 1).clamp(0, _pages.length - 1);
    } else {
      return;
    }

    int diff = (newIndex - _currentIndex).abs();
    Duration duration = Duration(milliseconds: (diff * 150).clamp(200, 600));
    Curve curve = diff == 1 ? Curves.easeInOut : Curves.fastOutSlowIn;

    _pageController.animateToPage(newIndex, duration: duration, curve: curve);
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: _handleKey,
      child: Scaffold(
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: _pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            int diff = (index - _currentIndex).abs();
            Duration duration = Duration(
              milliseconds: (diff * 150).clamp(200, 600),
            );
            Curve curve = diff == 1 ? Curves.easeInOut : Curves.fastOutSlowIn;

            _pageController.animateToPage(
              index,
              duration: duration,
              curve: curve,
            );
          },
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
              icon: const Icon(Icons.home_outlined),
              activeIcon: const Icon(Icons.home),
              label: context.tr('home'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.shopping_bag_outlined),
              activeIcon: const Icon(Icons.shopping_bag),
              label: context.tr('products'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.shopping_cart_outlined),
              activeIcon: const Icon(Icons.shopping_cart),
              label: context.tr('cart'),
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline),
              activeIcon: const Icon(Icons.person),
              label: context.tr('profile'),
            ),
          ],
        ),
      ),
    );
  }
}
