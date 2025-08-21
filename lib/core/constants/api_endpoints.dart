// API Endpoints - All API endpoint constants
class ApiEndpoints {
  // Base endpoints
  static const String auth = '/auth';
  static const String users = '/users';
  static const String products = '/products';
  static const String categories = '/categories';
  static const String orders = '/orders';
  static const String cart = '/cart';
  static const String wishlist = '/wishlist';

  // Auth endpoints
  static const String login = '$auth/login';
  static const String register = '$auth/register';
  static const String refreshToken = '$auth/refresh';
  static const String logout = '$auth/logout';
  static const String forgotPassword = '$auth/forgot-password';
  static const String resetPassword = '$auth/reset-password';

  // User endpoints
  static const String profile = '$users/profile';
  static const String updateProfile = '$users/profile';
  static const String changePassword = '$users/change-password';
  static const String deleteAccount = '$users/delete';

  // Product endpoints
  static const String allProducts = products;
  static const String featuredProducts = '$products/featured';
  static const String searchProducts = '$products/search';
  static const String productDetails = '$products/{id}';
  static const String productReviews = '$products/{id}/reviews';

  // Category endpoints
  static const String allCategories = categories;
  static const String categoryProducts = '$categories/{id}/products';

  // Order endpoints
  static const String userOrders = orders;
  static const String createOrder = orders;
  static const String orderDetails = '$orders/{id}';
  static const String cancelOrder = '$orders/{id}/cancel';

  // Cart endpoints
  static const String getCart = cart;
  static const String addToCart = cart;
  static const String updateCart = '$cart/{id}';
  static const String removeFromCart = '$cart/{id}';
  static const String clearCart = cart;

  // Wishlist endpoints
  static const String getWishlist = wishlist;
  static const String addToWishlist = wishlist;
  static const String removeFromWishlist = '$wishlist/{id}';
}
