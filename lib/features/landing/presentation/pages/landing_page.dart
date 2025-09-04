// Landing Page for Web Version
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/localization/localization_extension.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../widgets/hero_section.dart';
import '../widgets/features_section.dart';
import '../widgets/categories_showcase.dart';
import '../widgets/testimonials_section.dart';
import '../widgets/stats_section.dart';
import '../widgets/footer_section.dart';
import '../widgets/floating_action_buttons.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  late AnimationController _scrollController;
  late AnimationController _fadeController;
  final ScrollController _pageScrollController = ScrollController();

  bool _showBackToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _pageScrollController.addListener(_scrollListener);

    // Start animations
    _fadeController.forward();
    _scrollController.forward();
  }

  void _scrollListener() {
    if (_pageScrollController.offset > 400) {
      if (!_showBackToTop) {
        setState(() => _showBackToTop = true);
      }
    } else {
      if (_showBackToTop) {
        setState(() => _showBackToTop = false);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fadeController.dispose();
    _pageScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: _buildMobileLayout(),
      tablet: _buildTabletLayout(),
      desktop: _buildDesktopLayout(),
    );
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      body: _buildBody(),
      floatingActionButton: FloatingActionButtons(
        showBackToTop: _showBackToTop,
        onBackToTop: _scrollToTop,
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Scaffold(
      body: _buildBody(),
      floatingActionButton: FloatingActionButtons(
        showBackToTop: _showBackToTop,
        onBackToTop: _scrollToTop,
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Scaffold(
      body: _buildBody(),
      floatingActionButton: FloatingActionButtons(
        showBackToTop: _showBackToTop,
        onBackToTop: _scrollToTop,
      ),
    );
  }

  Widget _buildBody() {
    return CustomScrollView(
      controller: _pageScrollController,
      slivers: [
        // App Bar
        SliverAppBar(
          expandedHeight: 80.h,
          floating: false,
          pinned: true,
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.surfaceDark
              : AppColors.white,
          elevation: 0,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withOpacity(0.1),
                    AppColors.secondary.withOpacity(0.1),
                  ],
                ),
              ),
            ),
          ),
          title: Row(
            children: [
              Icon(Icons.shopping_bag, color: AppColors.primary, size: 28.sp),
              SizedBox(width: 8.w),
              Text(
                context.tr('app_name'),
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          actions: [
            if (ResponsiveUtils.isDesktop(context)) ...[
              TextButton(
                onPressed: () => _scrollToSection(1),
                child: Text(context.tr('features')),
              ),
              TextButton(
                onPressed: () => _scrollToSection(2),
                child: Text(context.tr('categories')),
              ),
              TextButton(
                onPressed: () => _scrollToSection(3),
                child: Text(context.tr('testimonials')),
              ),
              SizedBox(width: AppDimensions.paddingM),
            ],
            TextButton(
              onPressed: () => Get.toNamed('/register'),
              child: Text(context.tr('register')),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                textStyle: AppTextStyles.labelLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            IconButton(
              onPressed: () => Get.toNamed('/login'),
              icon: const Icon(Icons.person),
              tooltip: context.tr('login'),
            ),
            IconButton(
              onPressed: () => Get.toNamed('/cart'),
              icon: const Icon(Icons.shopping_cart),
              tooltip: context.tr('cart'),
            ),
            SizedBox(width: AppDimensions.paddingM),
          ],
        ),

        // Hero Section
        SliverToBoxAdapter(
          child: FadeTransition(
            opacity: _fadeController,
            child: HeroSection(animationController: _scrollController),
          ),
        ),

        // Features Section
        SliverToBoxAdapter(
          child: SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(0, 0.3),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _scrollController,
                    curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
                  ),
                ),
            child: FeaturesSection(animationController: _scrollController),
          ),
        ),

        // Stats Section
        SliverToBoxAdapter(
          child: SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(0, 0.3),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _scrollController,
                    curve: const Interval(0.3, 0.9, curve: Curves.easeOut),
                  ),
                ),
            child: StatsSection(animationController: _scrollController),
          ),
        ),

        // Categories Showcase
        SliverToBoxAdapter(
          child: SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(0, 0.3),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _scrollController,
                    curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
                  ),
                ),
            child: CategoriesShowcase(animationController: _scrollController),
          ),
        ),

        // Testimonials Section
        SliverToBoxAdapter(
          child: SlideTransition(
            position:
                Tween<Offset>(
                  begin: const Offset(0, 0.3),
                  end: Offset.zero,
                ).animate(
                  CurvedAnimation(
                    parent: _scrollController,
                    curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
                  ),
                ),
            child: TestimonialsSection(animationController: _scrollController),
          ),
        ),

        // Footer Section
        SliverToBoxAdapter(
          child: FadeTransition(
            opacity: _fadeController,
            child: FooterSection(),
          ),
        ),
      ],
    );
  }

  void _scrollToTop() {
    _pageScrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  void _scrollToSection(int sectionIndex) {
    double offset = 0;
    switch (sectionIndex) {
      case 1: // Features
        offset = 600.h;
        break;
      case 2: // Categories
        offset = 1200.h;
        break;
      case 3: // Testimonials
        offset = 1800.h;
        break;
    }

    _pageScrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }
}
