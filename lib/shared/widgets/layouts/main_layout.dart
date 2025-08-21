// Main Layout Widget
import 'package:flutter/material.dart';
import '../../../features/home/presentation/pages/home_page.dart';
import '../../../features/products/presentation/pages/products_page.dart';
import '../../../features/cart/presentation/pages/cart_page.dart';
import '../../../features/profile/presentation/pages/profile_page.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/routing/app_router.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const ProductsPage(),
    const CartPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.surfaceDark
            : AppColors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.textSecondaryDark
            : AppColors.textSecondaryLight,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'خانه', // TODO: Use translation
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            activeIcon: Icon(Icons.shopping_bag),
            label: 'محصولات', // TODO: Use translation
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: 'سبد خرید', // TODO: Use translation
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'پروفایل', // TODO: Use translation
          ),
        ],
      ),
    );
  }
}
