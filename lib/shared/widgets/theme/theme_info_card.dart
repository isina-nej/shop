import 'package:flutter/material.dart';
import '../../../core/theme/advanced_theme_manager.dart';
import '../../../main.dart';

/// Widget to show current theme info with animation
class ThemeInfoCard extends StatelessWidget {
  const ThemeInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = ThemeProvider.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: themeManager.currentColorScheme.seedColor,
              shape: BoxShape.circle,
            ),
            child: themeManager.currentColorScheme.isDynamic
                ? const Icon(Icons.auto_awesome, color: Colors.white, size: 20)
                : Icon(
                    _getThemeModeIcon(themeManager.currentMode),
                    color: Colors.white,
                    size: 20,
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تم فعلی: ${themeManager.currentColorScheme.name}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'حالت: ${_getThemeModeText(themeManager.currentMode)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onPrimaryContainer.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => themeManager.toggleTheme(),
            icon: Icon(
              Icons.brightness_6,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getThemeModeIcon(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return Icons.light_mode;
      case AppThemeMode.dark:
        return Icons.dark_mode;
      case AppThemeMode.system:
        return Icons.settings_brightness;
    }
  }

  String _getThemeModeText(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return 'روشن';
      case AppThemeMode.dark:
        return 'تیره';
      case AppThemeMode.system:
        return 'سیستم';
    }
  }
}
