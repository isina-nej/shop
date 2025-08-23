import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/theme/advanced_theme_manager.dart';
import 'core/localization/language_manager.dart';
import 'core/routing/app_router.dart';
import 'shared/widgets/layouts/main_layout.dart';
import 'core/localization/translation_manager.dart';
import 'shared/widgets/loading/modern_loading_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const InitializingApp());
}

class InitializingApp extends StatefulWidget {
  const InitializingApp({super.key});

  @override
  State<InitializingApp> createState() => _InitializingAppState();
}

class _InitializingAppState extends State<InitializingApp> {
  late Future<AppManagers?> _initializationFuture;

  @override
  void initState() {
    super.initState();
    _initializationFuture = _initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop',
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Poppins'),
      home: ModernLoadingScreen(
        initializationFuture: _initializationFuture.then((_) {}),
        child: FutureBuilder<AppManagers?>(
          future: _initializationFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return MyApp(
                themeManager: snapshot.data!.themeManager,
                languageManager: snapshot.data!.languageManager,
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  Future<AppManagers?> _initializeApp() async {
    try {
      // Initialize translation manager
      await TranslationManager.instance.initialize();

      // Initialize theme manager
      final themeManager = AdvancedThemeManager();
      await themeManager.initialize();

      // Initialize language manager
      final languageManager = LanguageManager();
      await languageManager.loadLanguage();

      // Add minimum loading time for better UX
      await Future.delayed(const Duration(milliseconds: 2000));

      return AppManagers(
        themeManager: themeManager,
        languageManager: languageManager,
      );
    } catch (e) {
      debugPrint('Initialization error: $e');
      return null;
    }
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
