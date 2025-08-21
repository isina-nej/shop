import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fa.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fa'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'SinaShop'**
  String get appTitle;

  /// Home page title
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Products page title
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// Categories page title
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// Cart page title
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// Profile page title
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Search label
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Search products placeholder
  ///
  /// In en, this message translates to:
  /// **'Search products...'**
  String get search_products;

  /// Sort products button
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort_products;

  /// Filter button
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// Price label
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// Rating label
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// Brand label
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get brand;

  /// Category label
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// Add to cart button
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get add_to_cart;

  /// Buy now button
  ///
  /// In en, this message translates to:
  /// **'Buy Now'**
  String get buy_now;

  /// Featured products section title
  ///
  /// In en, this message translates to:
  /// **'Featured Products'**
  String get featured_products;

  /// Best sellers section title
  ///
  /// In en, this message translates to:
  /// **'Best Sellers'**
  String get best_sellers;

  /// New arrivals section title
  ///
  /// In en, this message translates to:
  /// **'New Arrivals'**
  String get new_arrivals;

  /// Special offers section title
  ///
  /// In en, this message translates to:
  /// **'Special Offers'**
  String get special_offers;

  /// View all button
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get view_all;

  /// Message when no products are found
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get no_products_found;

  /// Loading message
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Error message
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Try again button
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get try_again;

  /// Welcome message
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// Sign in button
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signin;

  /// Sign up button
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Username field label
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// Phone field label
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// Address field label
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// Total amount label
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// Subtotal amount label
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// Shipping cost label
  ///
  /// In en, this message translates to:
  /// **'Shipping'**
  String get shipping;

  /// Tax amount label
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get tax;

  /// Discount amount label
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// Quantity label
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// Remove button
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// Update button
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// Save button
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// OK button
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Yes button
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No button
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fa'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fa':
      return AppLocalizationsFa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
