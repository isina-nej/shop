import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/advanced_theme_manager.dart';
import 'core/localization/language_manager.dart';
import 'core/routing/app_router.dart';
import 'shared/widgets/layouts/main_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize theme manager
  final themeManager = AdvancedThemeManager();
  await themeManager.initialize();

  // Initialize language manager
  final languageManager = LanguageManager();
  await languageManager.loadLanguage();

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
              title: 'SinaShop',
              theme: themeManager.getLightTheme(),
              darkTheme: themeManager.getDarkTheme(),
              themeMode: themeManager.themeMode,
              locale: languageManager.locale,
              supportedLocales: LanguageManager.supportedLocales,
              onGenerateRoute: AppRouter.generateRoute,
              builder: (context, child) {
                return Directionality(
                  textDirection: languageManager.textDirection,
                  child: child!,
                );
              },
              home: ThemeProvider(
                themeManager: themeManager,
                child: const MainLayout(),
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
