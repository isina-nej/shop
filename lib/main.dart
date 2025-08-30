import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'core/theme/advanced_theme_manager.dart';
import 'core/localization/language_controller.dart';
import 'core/theme/theme_controller.dart';
import 'core/routing/app_router.dart';
import 'shared/widgets/layouts/main_layout.dart';
import 'core/localization/translation_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetX controllers
  Get.put(ThemeController());
  Get.put(LanguageController());

  // Initialize TranslationManager
  await TranslationManager.instance.initialize();

  runApp(const ShopApp());
}

class ShopApp extends StatelessWidget {
  const ShopApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final languageController = Get.find<LanguageController>();

    return Obx(() {
      return GetMaterialApp(
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
        builder: (context, child) {
          return Directionality(
            textDirection: languageController.textDirection,
            child: child!,
          );
        },
        home: const MainLayout(),
        debugShowCheckedModeBanner: false,
      );
    });
  }
}
