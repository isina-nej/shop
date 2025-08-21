// App Constants - Global constants for the application
class AppConstants {
  // API Configuration
  static const String baseUrl = 'https://api.yourdomain.com';
  static const String apiVersion = 'v1';
  static const Duration requestTimeout = Duration(seconds: 30);

  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String languageKey = 'app_language';
  static const String themeKey = 'app_theme';
  static const String cartKey = 'user_cart';
  static const String wishlistKey = 'user_wishlist';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 400);
  static const Duration longAnimationDuration = Duration(milliseconds: 600);

  // Image Configurations
  static const double imageQuality = 0.8;
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 32;
  static const int maxUsernameLength = 30;
}
