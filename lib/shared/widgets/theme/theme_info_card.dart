import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../core/localization/localization_extension.dart';

/// Widget to show current theme info with animation
class ThemeInfoCard extends StatelessWidget {
  const ThemeInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();

    return Obx(
      () => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  themeController.currentTheme.value == ThemeStatus.dark
                      ? Icons.dark_mode
                      : themeController.currentTheme.value == ThemeStatus.light
                      ? Icons.light_mode
                      : Icons.brightness_auto,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 12.0.w),
                Expanded(
                  child: Text(
                    '${context.tr('current_theme')} ${themeController.currentTheme.value.name}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8.0.h),
            Text(
              '${context.tr('theme_mode')}: ${themeController.currentTheme.value.name}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 16.0.h),
            ElevatedButton.icon(
              onPressed: () => themeController.toggleTheme(),
              icon: const Icon(Icons.swap_horiz),
              label: Text(context.tr('toggle_theme')),
            ),
          ],
        ),
      ),
    );
  }
}
