import 'package:flutter/material.dart';
import 'core/theme/advanced_theme_manager.dart';
import 'core/localization/app_strings.dart';
import 'shared/widgets/layouts/main_layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize theme manager
  final themeManager = AdvancedThemeManager();
  await themeManager.initialize();

  runApp(MyApp(themeManager: themeManager));
}

class MyApp extends StatelessWidget {
  final AdvancedThemeManager themeManager;

  const MyApp({super.key, required this.themeManager});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeManager,
      builder: (context, child) {
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
          child: Builder(
            builder: (context) {
              return MaterialApp(
                title: 'SinaShop',
                theme: themeManager.getLightTheme(),
                darkTheme: themeManager.getDarkTheme(),
                themeMode: themeManager.themeMode,
                // TODO: Add localization delegates after generation
                // localizationsDelegates: const [
                //   AppLocalizations.delegate,
                //   GlobalMaterialLocalizations.delegate,
                //   GlobalWidgetsLocalizations.delegate,
                //   GlobalCupertinoLocalizations.delegate,
                // ],
                // supportedLocales: const [
                //   Locale('en'),
                //   Locale('fa'),
                // ],
                home: AppLocalization(
                  locale: 'fa', // Default to Persian
                  child: ThemeProvider(
                    themeManager: themeManager,
                    child: const MainLayout(),
                  ),
                ),
                debugShowCheckedModeBanner: false,
              );
            },
          ),
        );
      },
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
