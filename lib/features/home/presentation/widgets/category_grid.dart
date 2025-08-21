// Category Grid Widget
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key});

  // Mock categories data
  static const List<CategoryModel> _categories = [
    CategoryModel(
      id: '1',
      name: 'الکترونیک',
      icon: Icons.phone_android,
      color: AppColors.primary,
    ),
    CategoryModel(
      id: '2',
      name: 'پوشاک',
      icon: Icons.checkroom,
      color: AppColors.secondary,
    ),
    CategoryModel(
      id: '3',
      name: 'خانه و آشپزخانه',
      icon: Icons.home,
      color: AppColors.accent,
    ),
    CategoryModel(
      id: '4',
      name: 'ورزش و سرگرمی',
      icon: Icons.sports_soccer,
      color: AppColors.success,
    ),
    CategoryModel(
      id: '5',
      name: 'زیبایی و سلامت',
      icon: Icons.spa,
      color: AppColors.warning,
    ),
    CategoryModel(
      id: '6',
      name: 'کتاب و مطالعه',
      icon: Icons.book,
      color: AppColors.info,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          crossAxisSpacing: AppDimensions.paddingS,
          mainAxisSpacing: AppDimensions.paddingS,
        ),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          return _CategoryCard(category: category);
        },
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final CategoryModel category;

  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        // TODO: Navigate to category products
        debugPrint('Category selected: ${category.name}');
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          boxShadow: [
            BoxShadow(
              color: isDark ? AppColors.shadowDark : AppColors.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon Container
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: category.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
              ),
              child: Icon(
                category.icon,
                color: category.color,
                size: AppDimensions.iconL,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingS),
            // Category Name
            Text(
              category.name,
              textAlign: TextAlign.center,
              style: AppTextStyles.labelMedium.copyWith(
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// Category Model
class CategoryModel {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });
}
