import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'dart:developer' as developer;
import 'core/theme/advanced_theme_manager.dart';
import 'core/localization/language_controller.dart';
import 'core/theme/theme_controller.dart';
import 'core/routing/app_router.dart';
import 'core/localization/translation_manager.dart';
import 'shared/widgets/splash/splash_screen.dart';
import 'features/auth/presentation/auth_controller.dart';
import 'features/cart/presentation/cart_controller.dart';
import 'features/wishlist/presentation/wishlist_controller.dart';
import 'core/network/network_service.dart';
import 'core/utils/responsive_utils.dart';
import 'features/landing/presentation/pages/landing_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Override debugPrint to suppress DebugService errors
  debugPrint = (String? message, {int? wrapWidth}) {
    if (message != null &&
        (message.contains('DebugService') ||
            message.contains('Cannot send Null') ||
            message.contains('Unsupported operation'))) {
      return; // Suppress these messages
    }
    developer.log(message ?? '', name: 'flutter');
  };

  // Initialize GetX controllers
  Get.put(ThemeController());
  Get.put(LanguageController());
  Get.put(AuthController());
  Get.put(CartController());
  Get.put(WishlistController());

  // Initialize NetworkService
  NetworkService.initialize();

  // Initialize TranslationManager
  await TranslationManager.instance.initialize();

  runApp(const ShopApp());
}

class ShopApp extends StatelessWidget {
  const ShopApp({super.key});

  Widget _getInitialPage() {
    // For web/desktop, show landing page
    // For mobile, show splash screen
    return LayoutBuilder(
      builder: (context, constraints) {
        if (ResponsiveUtils.isDesktop(context)) {
          return const LandingPage();
        } else {
          return const SplashScreen();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final languageController = Get.find<LanguageController>();

    return ScreenUtilInit(
      designSize: Size(375, 812), // iPhone X size as base
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (context, child) {
        return Obx(() {
          return Directionality(
            textDirection: languageController.textDirection,
            child: GetMaterialApp(
              title: TranslationManager.instance.translate('app_name'),
              theme: themeController.currentTheme.value == ThemeStatus.dark
                  ? AdvancedThemeManager().getDarkTheme()
                  : AdvancedThemeManager().getLightTheme(),
              darkTheme: AdvancedThemeManager().getDarkTheme(),
              themeMode: themeController.themeMode,
              locale: languageController.locale.value,
              supportedLocales: LanguageController.supportedLocales,
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              onGenerateRoute: AppRouter.generateRoute,
              home: _getInitialPage(),
              debugShowCheckedModeBanner: false,
            ),
          );
        });
      },
    );
  }
}
