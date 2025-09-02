// Search Bar Widget
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class SearchBarWidget extends StatefulWidget {
  const SearchBarWidget({super.key});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.grey100,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 1,
        ),
      ),
      child: TextField(
        controller: _controller,
        textAlign: TextAlign.right,
        style: AppTextStyles.bodyMedium.copyWith(
          color: isDark
              ? AppColors.textPrimaryDark
              : AppColors.textPrimaryLight,
        ),
        decoration: InputDecoration(
          hintText: 'جستجو در محصولات...', // TODO: Use translation
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: isDark
                ? AppColors.textSecondaryDark
                : AppColors.textSecondaryLight,
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                  onPressed: () {
                    setState(() {
                      _controller.clear();
                    });
                  },
                )
              : Icon(
                  Icons.mic_outlined,
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingM,
            vertical: AppDimensions.paddingM,
          ),
        ),
        onChanged: (value) {
          setState(() {});
        },
        onSubmitted: (value) {
          if (value.trim().isNotEmpty) {
            _performSearch(value.trim());
          }
        },
      ),
    );
  }

  void _performSearch(String query) {
    // TODO: Implement search functionality
    debugPrint('Searching for: $query');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
