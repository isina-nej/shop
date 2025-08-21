// Simple Localization Service - Temporary solution until flutter_localizations works
import 'package:flutter/material.dart';

class AppStrings {
  static const String _defaultLocale = 'fa';

  static final Map<String, Map<String, String>> _strings = {
    'en': {
      // App
      'appTitle': 'Sina Shop',
      'home': 'Home',
      'categories': 'Categories',
      'products': 'Products',
      'profile': 'Profile',
      'search': 'Search',
      'searchInProducts': 'Search in products...',
      'seeAll': 'See All',

      // Home
      'specialOffers': 'Special Offers',
      'featuredProducts': 'Featured Products',
      'freeShipping': 'Free Shipping',
      'freeShippingDesc': 'For purchases over \$100',
      'discount50': '50% Discount',
      'discount50Desc': 'On electronic products',
      'newCustomerDiscount': '30% New Customer Discount',
      'newCustomerDiscountDesc': 'Valid until: 12/31/2023',

      // Categories
      'electronics': 'Electronics',
      'homeAndLifestyle': 'Home & Lifestyle',
      'beautyAndHealth': 'Beauty & Health',
      'sportsAndRecreation': 'Sports & Recreation',
      'booksAndMedia': 'Books & Media',
      'clothing': 'Clothing',

      // Profile
      'profileTitle': 'User Profile',
      'editProfile': 'Edit Profile',
      'myAddresses': 'My Addresses',
      'manageAddresses': 'Manage your addresses',
      'paymentMethods': 'Payment Methods',
      'savedCards': 'Saved payment cards',
      'myOrders': 'My Orders',
      'orderHistory': 'Order history',
      'wishlist': 'Wishlist',
      'savedProducts': 'Saved products',
      'reviews': 'Reviews',
      'yourReviews': 'Your reviews',
      'notifications': 'Notifications',
      'notificationSettings': 'Notification settings',
      'support': 'Support',
      'helpCenter': 'Help center',
      'aboutApp': 'About App',
      'appInfo': 'App information',
      'privacyPolicy': 'Privacy Policy',
      'privacyInfo': 'Privacy information',
      'settings': 'Settings',

      // Theme & Language
      'themeSettings': 'Theme Settings',
      'languageSettings': 'Language Settings',
      'selectLanguage': 'Select Language',
      'english': 'English',
      'persian': 'Persian',
      'lightTheme': 'Light',
      'darkTheme': 'Dark',
      'systemTheme': 'System',
      'dynamicColor': 'Dynamic Color',
      'customColor': 'Custom Color',
      'selectCustomColor': 'Select Custom Color',
      'currentTheme': 'Current Theme',
      'themeMode': 'Theme Mode',
      'colorScheme': 'Color Scheme',
      'systemColors': 'System Colors',
      'customColors': 'Custom Colors',
      'themeAnimated': 'Animated Theme Transitions',

      // Actions
      'cancel': 'Cancel',
      'save': 'Save',
      'apply': 'Apply',
      'close': 'Close',
      'ok': 'OK',
      'viewAll': 'View All',
      'loading': 'Loading...',
      'error': 'Error',
      'retry': 'Retry',
      'noResults': 'No results found',

      // Shopping
      'price': 'Price',
      'addToCart': 'Add to Cart',
      'buyNow': 'Buy Now',
      'inStock': 'In Stock',
      'outOfStock': 'Out of Stock',
      'rating': 'Rating',
      'reviewsCount': 'Reviews',
      'toman': 'Toman',
      'off': 'Off',

      // Products
      'laptop': 'Laptop',
      'macbook': 'MacBook',
      'headphones': 'Headphones',
      'iphone': 'iPhone',
    },
    'fa': {
      // App
      'appTitle': 'سینا شاپ',
      'home': 'خانه',
      'categories': 'دسته‌بندی‌ها',
      'products': 'محصولات',
      'profile': 'پروفایل',
      'search': 'جستجو',
      'searchInProducts': 'جستجو در محصولات...',
      'seeAll': 'مشاهده همه',

      // Home
      'specialOffers': 'پیشنهادات ویژه',
      'featuredProducts': 'محصولات ویژه',
      'freeShipping': 'ارسال رایگان',
      'freeShippingDesc': 'برای سفارش‌های بالای ۱۰۰ هزار تومان',
      'discount50': 'تخفیف ۵۰%',
      'discount50Desc': 'محصولات الکترونیکی',
      'newCustomerDiscount': 'کد تخفیف ویژه کاربران جدید',
      'newCustomerDiscountDesc': 'معتبر تا: ۱۴۰۲/۱۰/۱۰',

      // Categories
      'electronics': 'الکترونیک',
      'homeAndLifestyle': 'خانه و آشپزخانه',
      'beautyAndHealth': 'زیبایی و سلامت',
      'sportsAndRecreation': 'ورزش و تفریحی',
      'booksAndMedia': 'کتاب و مطالعه',
      'clothing': 'پوشاک',

      // Profile
      'profileTitle': 'پروفایل کاربری',
      'editProfile': 'ویرایش پروفایل',
      'myAddresses': 'آدرس‌های من',
      'manageAddresses': 'مدیریت آدرس‌ها',
      'paymentMethods': 'کارت‌های پرداخت',
      'savedCards': 'کارت‌های ذخیره‌شده',
      'myOrders': 'سفارش‌های من',
      'orderHistory': 'تاریخچه سفارش‌ها',
      'wishlist': 'علاقه‌مندی‌ها',
      'savedProducts': 'محصولات ذخیره‌شده',
      'reviews': 'نظرات',
      'yourReviews': 'نظرات شما',
      'notifications': 'اعلانات',
      'notificationSettings': 'تنظیمات اعلانات',
      'support': 'پشتیبانی',
      'helpCenter': 'مرکز راهنمایی',
      'aboutApp': 'درباره اپلیکیشن',
      'appInfo': 'اطلاعات اپلیکیشن',
      'privacyPolicy': 'حریم خصوصی',
      'privacyInfo': 'اطلاعات حریم خصوصی',
      'settings': 'تنظیمات',

      // Theme & Language
      'themeSettings': 'تنظیمات تم',
      'languageSettings': 'تنظیمات زبان',
      'selectLanguage': 'انتخاب زبان',
      'english': 'English',
      'persian': 'فارسی',
      'lightTheme': 'روشن',
      'darkTheme': 'تیره',
      'systemTheme': 'سیستم',
      'dynamicColor': 'رنگ پویا',
      'customColor': 'رنگ دلخواه',
      'selectCustomColor': 'انتخاب رنگ دلخواه',
      'currentTheme': 'تم فعلی',
      'themeMode': 'حالت تم',
      'colorScheme': 'طرح رنگی',
      'systemColors': 'رنگ‌های سیستم',
      'customColors': 'رنگ‌های دلخواه',
      'themeAnimated': 'انیمیشن تغییر تم',

      // Actions
      'cancel': 'لغو',
      'save': 'ذخیره',
      'apply': 'اعمال',
      'close': 'بستن',
      'ok': 'تأیید',
      'viewAll': 'مشاهده همه',
      'loading': 'در حال بارگذاری...',
      'error': 'خطا',
      'retry': 'تلاش مجدد',
      'noResults': 'نتیجه‌ای یافت نشد',

      // Shopping
      'price': 'قیمت',
      'addToCart': 'افزودن به سبد',
      'buyNow': 'خرید فوری',
      'inStock': 'موجود',
      'outOfStock': 'ناموجود',
      'rating': 'امتیاز',
      'reviewsCount': 'نظر',
      'toman': 'تومان',
      'off': 'تخفیف',

      // Products
      'laptop': 'لپ تاپ مک بوک ایر',
      'macbook': 'S24 سامسونگ گلکسی',
      'headphones': 'هدفون بی سیم ایربات',
      'iphone': 'آیفون ۱۵ پرو مکس',
    },
  };

  static String get(String key, {String? locale}) {
    final currentLocale = locale ?? _defaultLocale;
    return _strings[currentLocale]?[key] ??
        _strings[_defaultLocale]?[key] ??
        key;
  }

  static bool isRtl(String locale) {
    return locale == 'fa' || locale == 'ar';
  }
}

// Simple Localization Widget
class AppLocalization extends InheritedWidget {
  final String locale;

  const AppLocalization({
    super.key,
    required this.locale,
    required super.child,
  });

  static AppLocalization of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppLocalization>()!;
  }

  String get(String key) {
    return AppStrings.get(key, locale: locale);
  }

  bool get isRtl {
    return AppStrings.isRtl(locale);
  }

  @override
  bool updateShouldNotify(AppLocalization oldWidget) {
    return locale != oldWidget.locale;
  }
}

// Extension for easier access
extension BuildContextLocalization on BuildContext {
  AppLocalization get l10n => AppLocalization.of(this);
  String tr(String key) => AppLocalization.of(this).get(key);
}
