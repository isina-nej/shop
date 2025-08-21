import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Enum for different theme modes
enum AppThemeMode {
  light('light'),
  dark('dark'),
  system('system');

  const AppThemeMode(this.value);
  final String value;

  static AppThemeMode fromString(String value) {
    return AppThemeMode.values.firstWhere(
      (mode) => mode.value == value,
      orElse: () => AppThemeMode.system,
    );
  }
}

/// Custom color scheme configuration
class CustomColorScheme {
  final String name;
  final Color seedColor;
  final bool isDynamic;

  const CustomColorScheme({
    required this.name,
    required this.seedColor,
    this.isDynamic = false,
  });
}

/// Advanced Theme Manager with animation and custom colors
class AdvancedThemeManager extends ChangeNotifier {
  AppThemeMode _currentMode = AppThemeMode.system;
  CustomColorScheme _currentColorScheme = _defaultColorSchemes[0];
  ColorScheme? _dynamicLightScheme;
  ColorScheme? _dynamicDarkScheme;

  static const String _themeModeKey = 'theme_mode';
  static const String _colorSchemeKey = 'color_scheme';
  static const String _customColorKey = 'custom_color';

  AppThemeMode get currentMode => _currentMode;
  CustomColorScheme get currentColorScheme => _currentColorScheme;
  ColorScheme? get dynamicLightScheme => _dynamicLightScheme;
  ColorScheme? get dynamicDarkScheme => _dynamicDarkScheme;

  /// Predefined color schemes
  static const List<CustomColorScheme> _defaultColorSchemes = [
    CustomColorScheme(name: 'Material Purple', seedColor: Colors.purple),
    CustomColorScheme(name: 'Ocean Blue', seedColor: Colors.blue),
    CustomColorScheme(name: 'Nature Green', seedColor: Colors.green),
    CustomColorScheme(name: 'Sunset Orange', seedColor: Colors.orange),
    CustomColorScheme(name: 'Rose Pink', seedColor: Colors.pink),
    CustomColorScheme(name: 'Deep Teal', seedColor: Colors.teal),
    CustomColorScheme(name: 'Royal Indigo', seedColor: Colors.indigo),
    CustomColorScheme(name: 'Warm Amber', seedColor: Colors.amber),
    CustomColorScheme(
      name: 'Dynamic',
      seedColor: Colors.purple,
      isDynamic: true,
    ),
  ];

  List<CustomColorScheme> get availableColorSchemes => _defaultColorSchemes;

  /// Initialize theme manager
  Future<void> initialize() async {
    await _loadSettings();
    await _loadDynamicColors();
  }

  /// Load saved settings
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    // Load theme mode
    final modeValue = prefs.getString(_themeModeKey);
    if (modeValue != null) {
      _currentMode = AppThemeMode.fromString(modeValue);
    }

    // Load color scheme
    final colorSchemeIndex = prefs.getInt(_colorSchemeKey) ?? 0;
    if (colorSchemeIndex < _defaultColorSchemes.length) {
      _currentColorScheme = _defaultColorSchemes[colorSchemeIndex];
    }

    // Load custom color if exists
    final customColorValue = prefs.getInt(_customColorKey);
    if (customColorValue != null) {
      _currentColorScheme = CustomColorScheme(
        name: 'Custom',
        seedColor: Color(customColorValue),
      );
    }
  }

  /// Load dynamic colors from system
  Future<void> _loadDynamicColors() async {
    try {
      final corePalette = await DynamicColorPlugin.getCorePalette();
      if (corePalette != null) {
        _dynamicLightScheme = corePalette.toColorScheme();
        _dynamicDarkScheme = corePalette.toColorScheme(
          brightness: Brightness.dark,
        );
      }
    } catch (e) {
      // Dynamic colors not available, use fallback
      debugPrint('Dynamic colors not available: $e');
    }
  }

  /// Change theme mode with animation
  Future<void> changeThemeMode(AppThemeMode mode) async {
    if (_currentMode != mode) {
      _currentMode = mode;
      notifyListeners();
      await _saveSettings();
    }
  }

  /// Change color scheme
  Future<void> changeColorScheme(CustomColorScheme colorScheme) async {
    if (_currentColorScheme != colorScheme) {
      _currentColorScheme = colorScheme;
      notifyListeners();
      await _saveSettings();
    }
  }

  /// Set custom color
  Future<void> setCustomColor(Color color) async {
    _currentColorScheme = CustomColorScheme(name: 'Custom', seedColor: color);
    notifyListeners();
    await _saveCustomColor(color);
  }

  /// Save settings to preferences
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, _currentMode.value);

    final colorSchemeIndex = _defaultColorSchemes.indexOf(_currentColorScheme);
    if (colorSchemeIndex != -1) {
      await prefs.setInt(_colorSchemeKey, colorSchemeIndex);
      await prefs.remove(_customColorKey); // Remove custom color
    }
  }

  /// Save custom color
  Future<void> _saveCustomColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_customColorKey, color.value);
    await prefs.remove(_colorSchemeKey); // Remove predefined scheme
  }

  /// Get light theme
  ThemeData getLightTheme() {
    ColorScheme colorScheme;

    if (_currentColorScheme.isDynamic && _dynamicLightScheme != null) {
      colorScheme = _dynamicLightScheme!;
    } else {
      colorScheme = ColorScheme.fromSeed(
        seedColor: _currentColorScheme.seedColor,
        brightness: Brightness.light,
      );
    }

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
      ),
    );
  }

  /// Get dark theme
  ThemeData getDarkTheme() {
    ColorScheme colorScheme;

    if (_currentColorScheme.isDynamic && _dynamicDarkScheme != null) {
      colorScheme = _dynamicDarkScheme!;
    } else {
      colorScheme = ColorScheme.fromSeed(
        seedColor: _currentColorScheme.seedColor,
        brightness: Brightness.dark,
      );
    }

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
      ),
    );
  }

  /// Get current theme mode for MaterialApp
  ThemeMode get themeMode {
    switch (_currentMode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  /// Toggle between light and dark
  Future<void> toggleTheme() async {
    switch (_currentMode) {
      case AppThemeMode.light:
        await changeThemeMode(AppThemeMode.dark);
        break;
      case AppThemeMode.dark:
        await changeThemeMode(AppThemeMode.light);
        break;
      case AppThemeMode.system:
        // Toggle to opposite of current system theme
        await changeThemeMode(AppThemeMode.light);
        break;
    }
  }
}
