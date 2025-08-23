import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/theme/advanced_theme_manager.dart';
import 'core/localization/language_manager.dart';
import 'core/routing/app_router.dart';
import 'shared/widgets/layouts/main_layout.dart';
import 'core/localization/translation_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ShopApp());
}

class ShopApp extends StatefulWidget {
  const ShopApp({super.key});

  @override
  State<ShopApp> createState() => _ShopAppState();
}

class _ShopAppState extends State<ShopApp> {
  AppManagers? _appManagers;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Initialize all managers in the background
      await TranslationManager.instance.initialize();

      final themeManager = AdvancedThemeManager();
      await themeManager.initialize();

      final languageManager = LanguageManager();
      await languageManager.loadLanguage();

      _appManagers = AppManagers(
        themeManager: themeManager,
        languageManager: languageManager,
      );

      if (mounted) {
        setState(() {
          // This will trigger showing the main app
        });
      }
    } catch (e) {
      debugPrint('Initialization error: $e');

      // Still try to create managers with defaults
      _appManagers = AppManagers(
        themeManager: AdvancedThemeManager(),
        languageManager: LanguageManager(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show a minimal loading widget until managers are ready
    if (_appManagers == null) {
      return MaterialApp(
        title: 'SinaShop',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const Scaffold(
          body: Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
      );
    }

    // Show the actual app
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _appManagers!.themeManager),
        ChangeNotifierProvider.value(value: _appManagers!.languageManager),
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

class AppManagers {
  final AdvancedThemeManager themeManager;
  final LanguageManager languageManager;

  AppManagers({required this.themeManager, required this.languageManager});
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
