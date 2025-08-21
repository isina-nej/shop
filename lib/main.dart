import 'package:flutter/material.dart';
import 'core/theme/theme_manager.dart';
import 'core/theme/app_theme.dart';
import 'shared/widgets/layouts/main_layout.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      themeManager: ThemeManager(),
      child: Builder(
        builder: (context) {
          final themeManager = ThemeProvider.of(context);

          return MaterialApp(
            title: 'SinaShop',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: _getThemeMode(themeManager.currentTheme),
            home: const MainLayout(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }

  ThemeMode _getThemeMode(ThemeStatus themeStatus) {
    switch (themeStatus) {
      case ThemeStatus.light:
        return ThemeMode.light;
      case ThemeStatus.dark:
        return ThemeMode.dark;
      case ThemeStatus.system:
        return ThemeMode.system;
    }
  }
}

// Custom ThemeProvider for theme management
class ThemeProvider extends InheritedWidget {
  final ThemeManager themeManager;

  const ThemeProvider({
    super.key,
    required this.themeManager,
    required super.child,
  });

  static ThemeManager of(BuildContext context) {
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

// Custom Consumer for theme changes
class ThemeConsumer extends StatefulWidget {
  final Widget Function(BuildContext context, ThemeManager themeManager)
  builder;

  const ThemeConsumer({super.key, required this.builder});

  @override
  State<ThemeConsumer> createState() => _ThemeConsumerState();
}

class _ThemeConsumerState extends State<ThemeConsumer> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final themeManager = ThemeProvider.of(context);
    themeManager.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    final themeManager = ThemeProvider.of(context);
    themeManager.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = ThemeProvider.of(context);
    return widget.builder(context, themeManager);
  }
}
