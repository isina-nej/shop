// Home App Bar Widget
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/theme/theme_manager.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      elevation: 0,
      scrolledUnderElevation: 1,
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {
          // TODO: Open drawer
        },
      ),
      title: Row(
        children: [
          Container(
            height: 32,
            width: 32,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_bag,
              color: AppColors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: AppDimensions.paddingS),
          Text(
            'سینا شاپ', // TODO: Use translation
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
            ),
          ),
        ],
      ),
      actions: [
        // Theme Toggle Button
        IconButton(
          icon: Icon(
            Theme.of(context).brightness == Brightness.dark
                ? Icons.light_mode
                : Icons.dark_mode,
          ),
          onPressed: () {
            final themeManager = _Provider.of<ThemeManager>(context);
            themeManager.changeTheme(
              Theme.of(context).brightness == Brightness.dark
                  ? ThemeStatus.light
                  : ThemeStatus.dark,
            );
          },
        ),
        // Notifications Button
        IconButton(
          icon: Stack(
            children: [
              const Icon(Icons.notifications_outlined),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          onPressed: () {
            // TODO: Navigate to notifications
          },
        ),
        const SizedBox(width: AppDimensions.paddingXS),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// Provider helper (temporary)
class _Provider<T extends ChangeNotifier> {
  static T of<T extends ChangeNotifier>(BuildContext context) {
    final provider = context
        .dependOnInheritedWidgetOfExactType<_ProviderWidget<T>>();
    assert(provider != null, 'No Provider<$T> found in context');
    return provider!.notifier;
  }
}

class _ProviderWidget<T extends ChangeNotifier> extends InheritedWidget {
  final T notifier;

  const _ProviderWidget({required this.notifier, required Widget child})
    : super(child: child);

  @override
  bool updateShouldNotify(covariant _ProviderWidget<T> oldWidget) {
    return notifier != oldWidget.notifier;
  }
}
