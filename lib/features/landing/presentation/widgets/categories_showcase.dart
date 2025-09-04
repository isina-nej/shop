// Categories Showcase Widget for Landing Page
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/localization/localization_extension.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/models/shop_models.dart';

class CategoriesShowcase extends StatelessWidget {
  final AnimationController animationController;

  const CategoriesShowcase({super.key, required this.animationController});

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveUtils.isDesktop(context);
    final isTablet = ResponsiveUtils.isTablet(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80.w : (isTablet ? 40.w : 20.w),
        vertical: 80.h,
      ),
      child: Column(
        children: [
          // Section Header
          AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: animationController,
                child: Column(
                  children: [
                    Text(
                      context.tr('popular_categories'),
                      style: isDesktop
                          ? AppTextStyles.displaySmall.copyWith(
                              fontWeight: FontWeight.bold,
                            )
                          : AppTextStyles.headlineLarge.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      context.tr('categories_subtitle'),
                      style: AppTextStyles.titleMedium.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),

          SizedBox(height: 60.h),

          // Categories Grid
          _buildCategoriesGrid(context, isDesktop, isTablet),

          SizedBox(height: 40.h),

          // View All Button
          AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: animationController,
                child: ElevatedButton(
                  onPressed: () => Get.toNamed('/categories'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 40.w,
                      vertical: 16.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusL,
                      ),
                    ),
                  ),
                  child: Text(context.tr('view_all_categories')),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesGrid(
    BuildContext context,
    bool isDesktop,
    bool isTablet,
  ) {
    final categories = _getCategories(context);

    if (isDesktop) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 0.8,
          crossAxisSpacing: 20.w,
          mainAxisSpacing: 20.h,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return _buildCategoryCard(
            context,
            categories[index],
            index,
            isDesktop: true,
          );
        },
      );
    } else if (isTablet) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.9,
          crossAxisSpacing: 15.w,
          mainAxisSpacing: 15.h,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return _buildCategoryCard(
            context,
            categories[index],
            index,
            isDesktop: false,
          );
        },
      );
    } else {
      return Column(
        children: categories.asMap().entries.map((entry) {
          return Padding(
            padding: EdgeInsets.only(bottom: 15.h),
            child: _buildCategoryCard(
              context,
              entry.value,
              entry.key,
              isDesktop: false,
            ),
          );
        }).toList(),
      );
    }
  }

  Widget _buildCategoryCard(
    BuildContext context,
    CategoryData category,
    int index, {
    required bool isDesktop,
  }) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return SlideTransition(
          position: Tween<Offset>(begin: Offset(0, 0.5), end: Offset.zero)
              .animate(
                CurvedAnimation(
                  parent: animationController,
                  curve: Interval(
                    0.1 + (index * 0.1),
                    0.7 + (index * 0.1),
                    curve: Curves.easeOut,
                  ),
                ),
              ),
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: animationController,
              curve: Interval(
                0.1 + (index * 0.1),
                0.7 + (index * 0.1),
                curve: Curves.easeOut,
              ),
            ),
            child: GestureDetector(
              onTap: () => Get.toNamed(
                '/category-products',
                arguments: {
                  'categoryId': category.id,
                  'categoryName': category.name,
                },
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? AppColors.surfaceDark
                      : Colors.white,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  border: Border.all(
                    color: category.color.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Category Icon/Image
                    Container(
                      width: isDesktop ? 80.w : 60.w,
                      height: isDesktop ? 80.w : 60.w,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            category.color.withOpacity(0.2),
                            category.color.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusL,
                        ),
                      ),
                      child: Icon(
                        category.icon,
                        size: isDesktop ? 40.sp : 30.sp,
                        color: category.color,
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // Category Name
                    Text(
                      category.name,
                      style: isDesktop
                          ? AppTextStyles.titleMedium.copyWith(
                              fontWeight: FontWeight.bold,
                            )
                          : AppTextStyles.titleSmall.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: 8.h),

                    // Products Count
                    Text(
                      '${category.productsCount} ${context.tr('products')}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),

                    SizedBox(height: 12.h),

                    // Explore Button
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: category.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusM,
                        ),
                      ),
                      child: Text(
                        context.tr('explore'),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: category.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<CategoryData> _getCategories(BuildContext context) {
    return [
      CategoryData(
        id: 'electronics',
        name: context.tr('electronics'),
        icon: Icons.devices,
        color: AppColors.primary,
        productsCount: 1250,
      ),
      CategoryData(
        id: 'clothing',
        name: context.tr('clothing'),
        icon: Icons.checkroom,
        color: AppColors.secondary,
        productsCount: 2100,
      ),
      CategoryData(
        id: 'home',
        name: context.tr('homeAndLifestyle'),
        icon: Icons.home,
        color: AppColors.success,
        productsCount: 890,
      ),
      CategoryData(
        id: 'sports',
        name: context.tr('sports_outdoors'),
        icon: Icons.sports_soccer,
        color: AppColors.warning,
        productsCount: 650,
      ),
      CategoryData(
        id: 'books',
        name: context.tr('books_media'),
        icon: Icons.menu_book,
        color: AppColors.info,
        productsCount: 1800,
      ),
      CategoryData(
        id: 'beauty',
        name: context.tr('beauty_cosmetics'),
        icon: Icons.face_retouching_natural,
        color: AppColors.error,
        productsCount: 420,
      ),
      CategoryData(
        id: 'automotive',
        name: context.tr('automotive'),
        icon: Icons.directions_car,
        color: AppColors.primary,
        productsCount: 320,
      ),
      CategoryData(
        id: 'toys',
        name: context.tr('toys_games'),
        icon: Icons.toys,
        color: AppColors.secondary,
        productsCount: 750,
      ),
    ];
  }
}

class CategoryData {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final int productsCount;

  CategoryData({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.productsCount,
  });
}
