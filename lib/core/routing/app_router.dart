// App Router Configuration
import 'package:flutter/material.dart';

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
          builder: (_) => const Scaffold(
            body: Center(child: Text('Splash Screen')),
          ),
        );
      
      case onboarding:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Onboarding Screen')),
          ),
        );
      
      case login:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Login Screen')),
          ),
        );
      
      case register:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Register Screen')),
          ),
        );
      
      case home:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Home Screen')),
          ),
        );
      
      case products:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Products Screen')),
          ),
        );
      
      case cart:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Cart Screen')),
          ),
        );
      
      case profile:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Profile Screen')),
          ),
        );
      
      case settings:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Settings Screen')),
          ),
        );
      
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Page Not Found'),
            ),
          ),
        );
    }
  }
}
