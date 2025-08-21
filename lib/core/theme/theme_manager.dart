// Theme Management without BLoC for now
import 'package:flutter/material.dart';

enum ThemeStatus { light, dark, system }

class ThemeManager extends ChangeNotifier {
  ThemeStatus _currentTheme = ThemeStatus.system;

  ThemeStatus get currentTheme => _currentTheme;

  ThemeManager() {
    _loadTheme();
  }

  void _loadTheme() async {
    // TODO: Load theme from storage when dependencies are added
    // For now, use system theme
    _currentTheme = ThemeStatus.system;
    notifyListeners();
  }

  void changeTheme(ThemeStatus theme) async {
    _currentTheme = theme;
    notifyListeners();

    // TODO: Save theme to storage when dependencies are added
  }

  void toggleTheme() {
    if (_currentTheme == ThemeStatus.light) {
      changeTheme(ThemeStatus.dark);
    } else {
      changeTheme(ThemeStatus.light);
    }
  }

  ThemeMode get themeMode {
    switch (_currentTheme) {
      case ThemeStatus.light:
        return ThemeMode.light;
      case ThemeStatus.dark:
        return ThemeMode.dark;
      case ThemeStatus.system:
        return ThemeMode.system;
    }
  }
}

// Provider Widget for ThemeManager
class ThemeManagerProvider extends StatelessWidget {
  final ThemeManager themeManager;
  final Widget child;

  const ThemeManagerProvider({
    super.key,
    required this.themeManager,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return _ThemeManagerInheritedWidget(
      themeManager: themeManager,
      child: child,
    );
  }

  static ThemeManager? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_ThemeManagerInheritedWidget>()
        ?.themeManager;
  }
}

// InheritedWidget for ThemeManager
class _ThemeManagerInheritedWidget extends InheritedWidget {
  final ThemeManager themeManager;

  const _ThemeManagerInheritedWidget({
    required this.themeManager,
    required super.child,
  });

  @override
  bool updateShouldNotify(_ThemeManagerInheritedWidget oldWidget) {
    return themeManager != oldWidget.themeManager;
  }
}
