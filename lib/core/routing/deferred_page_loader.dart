// Real Deferred Loading Implementation for Flutter Web
// This file demonstrates how to implement actual deferred loading using Dart's deferred imports

// Deferred imports - these will be loaded only when needed
import '../../features/home/presentation/pages/home_page.dart'
    deferred as home_page;
import '../../features/categories/presentation/pages/categories_page.dart'
    deferred as categories_page;
import '../../features/products/presentation/pages/products_page.dart'
    deferred as products_page;
import '../../features/products/presentation/pages/product_details_page.dart'
    deferred as product_details_page;
import '../../features/cart/presentation/pages/cart_page.dart'
    deferred as cart_page;
import '../../features/profile/presentation/pages/profile_page.dart'
    deferred as profile_page;
import '../../features/profile/presentation/pages/edit_profile_page.dart'
    deferred as edit_profile_page;
import '../../features/profile/presentation/pages/addresses_page.dart'
    deferred as addresses_page;
import '../../features/profile/presentation/pages/security_settings_page.dart'
    deferred as security_settings_page;
import '../../features/profile/presentation/pages/payment_methods_page.dart'
    deferred as payment_methods_page;
import '../../features/profile/presentation/pages/reviews_page.dart'
    deferred as reviews_page;
import '../../features/profile/presentation/pages/notifications_settings_page.dart'
    deferred as notifications_page;
import '../../features/profile/presentation/pages/faq_page.dart'
    deferred as faq_page;
import '../../features/profile/presentation/pages/support_page.dart'
    deferred as support_page;
import '../../features/profile/presentation/pages/about_page.dart'
    deferred as about_page;
import '../../features/profile/presentation/pages/privacy_policy_page.dart'
    deferred as privacy_page;
import '../../features/profile/presentation/pages/settings_page.dart'
    deferred as settings_page;

import 'package:flutter/material.dart';

class DeferredPageLoader {
  // Cache for loaded libraries
  static final Map<String, bool> _loadedLibraries = {};

  /// Load home page with deferred loading
  static Future<Widget> loadHomePage() async {
    await _loadLibrary('home', () => home_page.loadLibrary());
    return home_page.HomePage();
  }

  /// Load categories page with deferred loading
  static Future<Widget> loadCategoriesPage() async {
    await _loadLibrary('categories', () => categories_page.loadLibrary());
    return categories_page.CategoriesPage();
  }

  /// Load products page with deferred loading
  static Future<Widget> loadProductsPage({
    String? categoryId,
    String? categoryName,
    String? searchQuery,
  }) async {
    await _loadLibrary('products', () => products_page.loadLibrary());
    return products_page.ProductsPage(
      categoryId: categoryId,
      categoryName: categoryName,
      searchQuery: searchQuery,
    );
  }

  /// Load product details page with deferred loading
  static Future<Widget> loadProductDetailsPage({
    required String productId,
  }) async {
    await _loadLibrary(
      'product_details',
      () => product_details_page.loadLibrary(),
    );
    return product_details_page.ProductDetailsPage(productId: productId);
  }

  /// Load cart page with deferred loading
  static Future<Widget> loadCartPage() async {
    await _loadLibrary('cart', () => cart_page.loadLibrary());
    return cart_page.CartPage();
  }

  /// Load profile page with deferred loading
  static Future<Widget> loadProfilePage() async {
    await _loadLibrary('profile', () => profile_page.loadLibrary());
    return profile_page.ProfilePage();
  }

  /// Load edit profile page with deferred loading
  static Future<Widget> loadEditProfilePage() async {
    await _loadLibrary('edit_profile', () => edit_profile_page.loadLibrary());
    return edit_profile_page.EditProfilePage();
  }

  /// Load addresses page with deferred loading
  static Future<Widget> loadAddressesPage() async {
    await _loadLibrary('addresses', () => addresses_page.loadLibrary());
    return addresses_page.AddressesPage();
  }

  /// Load security settings page with deferred loading
  static Future<Widget> loadSecuritySettingsPage() async {
    await _loadLibrary(
      'security_settings',
      () => security_settings_page.loadLibrary(),
    );
    return security_settings_page.SecuritySettingsPage();
  }

  /// Load payment methods page with deferred loading
  static Future<Widget> loadPaymentMethodsPage() async {
    await _loadLibrary(
      'payment_methods',
      () => payment_methods_page.loadLibrary(),
    );
    return payment_methods_page.PaymentMethodsPage();
  }

  /// Load reviews page with deferred loading
  static Future<Widget> loadReviewsPage() async {
    await _loadLibrary('reviews', () => reviews_page.loadLibrary());
    return reviews_page.ReviewsPage();
  }

  /// Load notifications settings page with deferred loading
  static Future<Widget> loadNotificationsPage() async {
    await _loadLibrary('notifications', () => notifications_page.loadLibrary());
    return notifications_page.NotificationsSettingsPage();
  }

  /// Load FAQ page with deferred loading
  static Future<Widget> loadFAQPage() async {
    await _loadLibrary('faq', () => faq_page.loadLibrary());
    return faq_page.FAQPage();
  }

  /// Load support page with deferred loading
  static Future<Widget> loadSupportPage() async {
    await _loadLibrary('support', () => support_page.loadLibrary());
    return support_page.SupportPage();
  }

  /// Load about page with deferred loading
  static Future<Widget> loadAboutPage() async {
    await _loadLibrary('about', () => about_page.loadLibrary());
    return about_page.AboutPage();
  }

  /// Load privacy policy page with deferred loading
  static Future<Widget> loadPrivacyPolicyPage() async {
    await _loadLibrary('privacy', () => privacy_page.loadLibrary());
    return privacy_page.PrivacyPolicyPage();
  }

  /// Load settings page with deferred loading
  static Future<Widget> loadSettingsPage() async {
    await _loadLibrary('settings', () => settings_page.loadLibrary());
    return settings_page.SettingsPage();
  }

  /// Helper method to load library only once
  static Future<void> _loadLibrary(
    String key,
    Future<void> Function() loader,
  ) async {
    if (_loadedLibraries[key] == true) {
      return; // Already loaded
    }

    try {
      await loader();
      _loadedLibraries[key] = true;
    } catch (e) {
      print('Error loading library $key: $e');
      rethrow;
    }
  }

  /// Pre-load specific pages for better performance
  static Future<void> preloadCriticalPages() async {
    // Pre-load home and profile pages as they're most commonly used
    final futures = <Future>[
      _loadLibrary('home', () => home_page.loadLibrary()),
      _loadLibrary('profile', () => profile_page.loadLibrary()),
    ];

    try {
      await Future.wait(futures, eagerError: false);
    } catch (e) {
      print('Error preloading critical pages: $e');
    }
  }

  /// Check if a library is already loaded
  static bool isLibraryLoaded(String key) {
    return _loadedLibraries[key] == true;
  }

  /// Get loading progress as percentage
  static double getLoadingProgress() {
    const totalLibraries = 16; // Total number of deferred libraries
    final loadedCount = _loadedLibraries.values
        .where((loaded) => loaded)
        .length;
    return loadedCount / totalLibraries;
  }

  /// Clear loaded libraries cache (useful for testing)
  static void clearCache() {
    _loadedLibraries.clear();
  }
}
