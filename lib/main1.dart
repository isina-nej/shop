import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/theme/advanced_theme_manager.dart';
import 'core/localization/language_manager.dart';
import 'core/routing/enhanced_app_router.dart'; // استفاده از router جدید
import 'shared/widgets/layouts/enhanced_main_layout.dart'; // استفاده از layout جدید
import 'core/localization/translation_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize translation manager
  await TranslationManager.instance.initialize();

  // Initialize theme manager
  final themeManager = AdvancedThemeManager();
  await themeManager.initialize();

  // Initialize language manager
  final languageManager = LanguageManager();
  await languageManager.loadLanguage();

  // Preload critical pages for better performance
  // این خط صفحات مهم را از قبل لود می‌کند
  await EnhancedAppRouter.preloadCriticalPages();

  runApp(MyApp(themeManager: themeManager, languageManager: languageManager));
}

class MyApp extends StatelessWidget {
  final AdvancedThemeManager themeManager;
  final LanguageManager languageManager;

  const MyApp({
    super.key,
    required this.themeManager,
    required this.languageManager,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: themeManager),
        ChangeNotifierProvider.value(value: languageManager),
      ],
      child: Consumer2<AdvancedThemeManager, LanguageManager>(
        builder: (context, themeManager, languageManager, child) {
          return AnimatedTheme(
            data:
                themeManager.themeMode == ThemeMode.dark ||
                    (themeManager.themeMode == ThemeMode.system &&
                        MediaQuery.platformBrightnessOf(context) ==
                            Brightness.dark)
                ? themeManager.getDarkTheme()
                : themeManager.getLightTheme(),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: MaterialApp(
              title: TranslationManager.instance.translate('app_name'),
              theme: themeManager.getLightTheme(),
              darkTheme: themeManager.getDarkTheme(),
              themeMode: themeManager.themeMode,
              locale: languageManager.locale,
              supportedLocales: LanguageManager.supportedLocales,
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              // استفاده از Enhanced Router با Lazy Loading
              onGenerateRoute: EnhancedAppRouter.generateRoute,
              builder: (context, child) {
                return Directionality(
                  textDirection: languageManager.textDirection,
                  child: child!,
                );
              },
              // استفاده از Enhanced Main Layout با Lazy Loading
              home: ThemeProvider(
                themeManager: themeManager,
                child: const EnhancedMainLayout(),
              ),
              debugShowCheckedModeBanner: false,
            ),
          );
        },
      ),
    );
  }
}

// Custom ThemeProvider for passing theme manager down the widget tree
class ThemeProvider extends InheritedWidget {
  final AdvancedThemeManager themeManager;

  const ThemeProvider({
    super.key,
    required this.themeManager,
    required super.child,
  });

  static AdvancedThemeManager of(BuildContext context) {
    final ThemeProvider? result = context
        .dependOnInheritedWidgetOfExactType<ThemeProvider>();
    assert(result != null, 'No ThemeProvider found in context');
    return result!.themeManager;
  }

  @override
  bool updateShouldNotify(ThemeProvider oldWidget) {
    return themeManager != oldWidget.themeManager;
  }
}