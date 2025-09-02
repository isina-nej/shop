import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/advanced_theme_manager.dart';
import '../../../core/localization/localization_extension.dart';

class ThemeSettingsSheet extends StatefulWidget {
  final AdvancedThemeManager themeManager;

  const ThemeSettingsSheet({super.key, required this.themeManager});

  @override
  State<ThemeSettingsSheet> createState() => _ThemeSettingsSheetState();
}

class _ThemeSettingsSheetState extends State<ThemeSettingsSheet>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.tr('theme_settings'),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            SizedBox(height: 20.0.h),

            // Theme Mode Section
            Text(
              context.tr('theme_mode'),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12.0.h),
            _buildThemeModeSelector(),
            SizedBox(height: 24.0.h),

            // Color Scheme Section
            Text(
              context.tr('color_scheme'),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12.0.h),
            _buildColorSchemeSelector(),
            SizedBox(height: 24.0.h),

            // Custom Color Section
            Text(
              context.tr('custom_color'),
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 12.0.h),
            _buildCustomColorPicker(),
            SizedBox(height: 20.0.h),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeModeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: AppThemeMode.values.map((mode) {
        final isSelected = widget.themeManager.currentMode == mode;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: OutlinedButton.icon(
                onPressed: () => widget.themeManager.changeThemeMode(mode),
                icon: Icon(_getThemeModeIcon(mode)),
                label: Text(_getThemeModeText(context, mode)),
                style: OutlinedButton.styleFrom(
                  backgroundColor: isSelected
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Colors.transparent,
                  foregroundColor: isSelected
                      ? Theme.of(context).colorScheme.onPrimaryContainer
                      : Theme.of(context).colorScheme.onSurface,
                  side: BorderSide(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildColorSchemeSelector() {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.themeManager.availableColorSchemes.length,
        itemBuilder: (context, index) {
          final colorScheme = widget.themeManager.availableColorSchemes[index];
          final isSelected =
              widget.themeManager.currentColorScheme == colorScheme;

          return Padding(
            padding: EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => widget.themeManager.changeColorScheme(colorScheme),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                    width: 3,
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: colorScheme.isDynamic
                              ? _getDynamicColor()
                              : colorScheme.seedColor,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(8),
                          ),
                        ),
                        child: colorScheme.isDynamic
                            ? const Icon(
                                Icons.auto_awesome,
                                color: Colors.white,
                                size: 24,
                              )
                            : null,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(8),
                        ),
                      ),
                      child: Text(
                        colorScheme.name,
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCustomColorPicker() {
    return SizedBox(
      height: 60,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children:
            [
                  Colors.red,
                  Colors.pink,
                  Colors.purple,
                  Colors.deepPurple,
                  Colors.indigo,
                  Colors.blue,
                  Colors.lightBlue,
                  Colors.cyan,
                  Colors.teal,
                  Colors.green,
                  Colors.lightGreen,
                  Colors.lime,
                  Colors.yellow,
                  Colors.amber,
                  Colors.orange,
                  Colors.deepOrange,
                  Colors.brown,
                  Colors.grey,
                  Colors.blueGrey,
                ]
                .map(
                  (color) => Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => widget.themeManager.setCustomColor(color),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                widget
                                        .themeManager
                                        .currentColorScheme
                                        .seedColor ==
                                    color
                                ? Theme.of(context).colorScheme.onSurface
                                : Colors.transparent,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: color.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child:
                            widget.themeManager.currentColorScheme.seedColor ==
                                color
                            ? const Icon(Icons.check, color: Colors.white)
                            : null,
                      ),
                    ),
                  ),
                )
                .toList(),
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

  String _getThemeModeText(BuildContext context, AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return context.tr('light_theme');
      case AppThemeMode.dark:
        return context.tr('dark_theme');
      case AppThemeMode.system:
        return context.tr('system_theme');
    }
  }

  Color _getDynamicColor() {
    if (widget.themeManager.dynamicLightScheme != null) {
      return widget.themeManager.dynamicLightScheme!.primary;
    }
    return Colors.purple; // Fallback
  }
}
