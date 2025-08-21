// Home Page - Responsive E-commerce Homepage
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../core/localization/localization_extension.dart';
import '../../../../shared/widgets/theme/theme_info_card.dart';
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
    return ResponsiveLayout(
      mobile: _buildMobileLayout(context),
      desktop: _buildDesktopLayout(context),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
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
                context.tr('categories'),
                onSeeAll: () => _navigateToCategories(),
              ),

              // Theme Info Card
              const ThemeInfoCard(),

              const CategoryGrid(),

              const SizedBox(height: AppDimensions.marginL),

              // Special Offers Section
              _buildSectionHeader(
                context,
                context.tr('specialOffers'),
                onSeeAll: () => _navigateToSpecialOffers(),
              ),

              const SpecialOffers(),

              const SizedBox(height: AppDimensions.marginL),

              // Featured Products Section
              _buildSectionHeader(
                context,
                context.tr('featuredProducts'),
                onSeeAll: () => _navigateToFeaturedProducts(),
              ),

              const FeaturedProducts(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ResponsiveContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppDimensions.marginL),

                // Search Bar with responsive width
                Row(
                  children: [
                    Expanded(flex: 3, child: const SearchBarWidget()),
                    const SizedBox(width: AppDimensions.marginM),
                    Expanded(flex: 1, child: const ThemeInfoCard()),
                  ],
                ),

                const SizedBox(height: AppDimensions.marginXL),

                // Banner Slider
                const BannerSlider(),

                const SizedBox(height: AppDimensions.marginXL),

                // Categories Section
                _buildSectionHeader(
                  context,
                  context.tr('categories'),
                  onSeeAll: () => _navigateToCategories(),
                ),

                const SizedBox(height: AppDimensions.marginL),
                const CategoryGrid(),

                const SizedBox(height: AppDimensions.marginXL),

                // Content Row: Special Offers and Featured Products
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Special Offers Section
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader(
                            context,
                            context.tr('specialOffers'),
                            onSeeAll: () => _navigateToSpecialOffers(),
                          ),
                          const SizedBox(height: AppDimensions.marginL),
                          const SpecialOffers(),
                        ],
                      ),
                    ),

                    const SizedBox(width: AppDimensions.marginXL),

                    // Featured Products Section
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader(
                            context,
                            context.tr('featuredProducts'),
                            onSeeAll: () => _navigateToFeaturedProducts(),
                          ),
                          const SizedBox(height: AppDimensions.marginL),
                          const FeaturedProducts(),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppDimensions.marginXL * 2),
              ],
            ),
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
                    context.tr('seeAll'),
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
    debugPrint('Home: Refreshing content...');
    // TODO: Implement refresh logic
    await Future.delayed(const Duration(seconds: 1));
    debugPrint('Home: Refresh completed');
  }

  void _navigateToCategories() {
    debugPrint('Home: Navigate to Categories');
    // TODO: Navigate to categories page
  }

  void _navigateToSpecialOffers() {
    debugPrint('Home: Navigate to Special Offers');
    // TODO: Navigate to special offers page
  }

  void _navigateToFeaturedProducts() {
    debugPrint('Home: Navigate to Featured Products');
    // TODO: Navigate to featured products page
  }
}
