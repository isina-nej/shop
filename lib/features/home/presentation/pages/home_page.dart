// Home Page - Responsive E-commerce Homepage
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/banner_slider.dart';
import '../widgets/category_grid.dart';
import '../widgets/featured_products.dart';
import '../widgets/special_offers.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: AppDimensions.paddingXL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              const Padding(
                padding: EdgeInsets.all(AppDimensions.paddingM),
                child: SearchBarWidget(),
              ),

              // Banner Slider
              const BannerSlider(),

              const SizedBox(height: AppDimensions.marginL),

              // Categories Section
              _buildSectionHeader(
                context,
                'دسته‌بندی‌ها', // TODO: Use translation
                onSeeAll: () => _navigateToCategories(),
              ),

              const CategoryGrid(),

              const SizedBox(height: AppDimensions.marginL),

              // Special Offers Section
              _buildSectionHeader(
                context,
                'پیشنهادات ویژه', // TODO: Use translation
                onSeeAll: () => _navigateToSpecialOffers(),
              ),

              const SpecialOffers(),

              const SizedBox(height: AppDimensions.marginL),

              // Featured Products Section
              _buildSectionHeader(
                context,
                'محصولات ویژه', // TODO: Use translation
                onSeeAll: () => _navigateToFeaturedProducts(),
              ),

              const FeaturedProducts(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title, {
    VoidCallback? onSeeAll,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyles.headlineSmall.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (onSeeAll != null)
            TextButton(
              onPressed: onSeeAll,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'مشاهده همه', // TODO: Use translation
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.paddingXS),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: AppDimensions.iconXS,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _onRefresh() async {
    // TODO: Implement refresh logic
    await Future.delayed(const Duration(seconds: 1));
  }

  void _navigateToCategories() {
    // TODO: Navigate to categories page
    debugPrint('Navigate to Categories');
  }

  void _navigateToSpecialOffers() {
    // TODO: Navigate to special offers page
    debugPrint('Navigate to Special Offers');
  }

  void _navigateToFeaturedProducts() {
    // TODO: Navigate to featured products page
    debugPrint('Navigate to Featured Products');
  }
}
