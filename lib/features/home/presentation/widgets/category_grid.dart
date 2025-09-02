// Category Grid Widget
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/localization/localization_extension.dart';
import '../../../../core/routing/app_router.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key});

  // Mock categories data
  static List<CategoryModel> _getCategories(BuildContext context) => [
    CategoryModel(
      id: '1',
      name: context.tr('electronics'),
      icon: Icons.phone_android,
      color: AppColors.primary,
    ),
    CategoryModel(
      id: '2',
      name: context.tr('clothing'),
      icon: Icons.checkroom,
      color: AppColors.secondary,
    ),
    CategoryModel(
      id: '3',
      name: context.tr('homeAndLifestyle'),
      icon: Icons.home,
      color: AppColors.accent,
    ),
    CategoryModel(
      id: '4',
      name: context.tr('sportsAndRecreation'),
      icon: Icons.sports_soccer,
      color: AppColors.success,
    ),
    CategoryModel(
      id: '5',
      name: context.tr('beautyAndHealth'),
      icon: Icons.spa,
      color: AppColors.warning,
    ),
    CategoryModel(
      id: '6',
      name: context.tr('booksAndMedia'),
      icon: Icons.book,
      color: AppColors.info,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveUtils.isDesktop(context);
    final crossAxisCount = ResponsiveUtils.getResponsiveValue(
      context,
      mobile: 2,
      tablet: 3,
      desktop: 6,
    );

    return Container(
      height: isDesktop ? 120.h : 200.h,
      padding: ResponsiveUtils.getResponsivePadding(context),
      child: isDesktop
          ? _buildDesktopGrid(context, crossAxisCount)
          : _buildMobileGrid(context, crossAxisCount),
    );
  }

  Widget _buildMobileGrid(BuildContext context, int crossAxisCount) {
    final categories = _getCategories(context);

    return SizedBox(
      height: 200.h,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.0,
          crossAxisSpacing: AppDimensions.paddingS,
          mainAxisSpacing: AppDimensions.paddingS,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return _CategoryCard(category: category);
        },
      ),
    );
  }

  Widget _buildDesktopGrid(BuildContext context, int crossAxisCount) {
    final categories = _getCategories(context);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 1.2,
        crossAxisSpacing: AppDimensions.paddingM,
        mainAxisSpacing: AppDimensions.paddingM,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return _CategoryCard(category: category, isCompact: true);
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final bool isCompact;

  const _CategoryCard({required this.category, this.isCompact = false});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconSize = isCompact ? 32.0.sp : 48.0.sp;
    final containerSize = isCompact ? 40.0.w : 48.0.w;

    return GestureDetector(
      onTap: () {
        // Navigate to category products
        Navigator.pushNamed(
          context,
          AppRouter.categoryProducts,
          arguments: {'categoryId': category.id, 'categoryName': category.name},
        );
        debugPrint('Category selected: ${category.name}');
      },
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
          boxShadow: [
            BoxShadow(
              color: isDark ? AppColors.shadowDark : AppColors.shadowLight,
              blurRadius: 8.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon Container
            Container(
              width: containerSize,
              height: containerSize,
              decoration: BoxDecoration(
                color: category.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
              ),
              child: Icon(category.icon, color: category.color, size: iconSize),
            ),
            SizedBox(
              height: isCompact
                  ? AppDimensions.paddingXS
                  : AppDimensions.paddingS,
            ),
            // Category Name
            Flexible(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0),
                child: Text(
                  category.name,
                  textAlign: TextAlign.center,
                  style:
                      (isCompact
                              ? AppTextStyles.labelSmall
                              : AppTextStyles.labelMedium)
                          .copyWith(
                            color: isDark
                                ? AppColors.textPrimaryDark
                                : AppColors.textPrimaryLight,
                            fontWeight: FontWeight.w600,
                          ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
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
