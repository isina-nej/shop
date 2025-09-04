// Testimonials Section Widget for Landing Page
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/localization/localization_extension.dart';
import '../../../../core/utils/responsive_utils.dart';

class TestimonialsSection extends StatefulWidget {
  final AnimationController animationController;

  const TestimonialsSection({super.key, required this.animationController});

  @override
  State<TestimonialsSection> createState() => _TestimonialsSectionState();
}

class _TestimonialsSectionState extends State<TestimonialsSection> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // Auto-slide testimonials
    Future.delayed(const Duration(seconds: 3), _autoSlide);
  }

  void _autoSlide() {
    if (mounted) {
      final testimonials = _getTestimonials(context);
      _currentPage = (_currentPage + 1) % testimonials.length;

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );

      Future.delayed(const Duration(seconds: 5), _autoSlide);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveUtils.isDesktop(context);
    final isTablet = ResponsiveUtils.isTablet(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80.w : (isTablet ? 40.w : 20.w),
        vertical: 80.h,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary.withOpacity(0.03),
            AppColors.secondary.withOpacity(0.05),
            AppColors.primary.withOpacity(0.03),
          ],
        ),
      ),
      child: Column(
        children: [
          // Section Header
          AnimatedBuilder(
            animation: widget.animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: widget.animationController,
                child: Column(
                  children: [
                    Text(
                      context.tr('what_customers_say'),
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
                      context.tr('testimonials_subtitle'),
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

          // Testimonials Carousel
          _buildTestimonialsCarousel(context, isDesktop),

          SizedBox(height: 30.h),

          // Page Indicators
          _buildPageIndicators(context),
        ],
      ),
    );
  }

  Widget _buildTestimonialsCarousel(BuildContext context, bool isDesktop) {
    final testimonials = _getTestimonials(context);

    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (context, child) {
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
              .animate(
                CurvedAnimation(
                  parent: widget.animationController,
                  curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
                ),
              ),
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: widget.animationController,
              curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
            ),
            child: SizedBox(
              height: isDesktop ? 300.h : 350.h,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: testimonials.length,
                itemBuilder: (context, index) {
                  return _buildTestimonialCard(
                    context,
                    testimonials[index],
                    isDesktop,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTestimonialCard(
    BuildContext context,
    TestimonialData testimonial,
    bool isDesktop,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: isDesktop ? 100.w : 20.w),
      padding: EdgeInsets.all(isDesktop ? 40.w : 30.w),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.surfaceDark
            : Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Quote Icon
          Icon(
            Icons.format_quote,
            size: isDesktop ? 40.sp : 30.sp,
            color: AppColors.primary.withOpacity(0.3),
          ),

          SizedBox(height: 20.h),

          // Testimonial Text
          Text(
            testimonial.text,
            style: isDesktop
                ? AppTextStyles.titleMedium.copyWith(
                    fontStyle: FontStyle.italic,
                    height: 1.6,
                  )
                : AppTextStyles.titleSmall.copyWith(
                    fontStyle: FontStyle.italic,
                    height: 1.6,
                  ),
            textAlign: TextAlign.center,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 30.h),

          // Customer Info
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Avatar
              CircleAvatar(
                radius: isDesktop ? 30.r : 25.r,
                backgroundColor: testimonial.avatarColor,
                child: Text(
                  testimonial.name.substring(0, 1).toUpperCase(),
                  style: AppTextStyles.titleMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(width: 16.w),

              // Name and Rating
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    testimonial.name,
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < testimonial.rating
                            ? Icons.star
                            : Icons.star_border,
                        size: 16.sp,
                        color: AppColors.warning,
                      );
                    }),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicators(BuildContext context) {
    final testimonials = _getTestimonials(context);

    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: widget.animationController,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(testimonials.length, (index) {
              return GestureDetector(
                onTap: () {
                  _pageController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  width: _currentPage == index ? 24.w : 8.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? AppColors.primary
                        : AppColors.primary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  List<TestimonialData> _getTestimonials(BuildContext context) {
    return [
      TestimonialData(
        name: 'علی احمدی',
        text: context.tr('testimonial_1'),
        rating: 5,
        avatarColor: AppColors.primary,
      ),
      TestimonialData(
        name: 'فاطمه محمدی',
        text: context.tr('testimonial_2'),
        rating: 5,
        avatarColor: AppColors.secondary,
      ),
      TestimonialData(
        name: 'حسین رضایی',
        text: context.tr('testimonial_3'),
        rating: 4,
        avatarColor: AppColors.success,
      ),
      TestimonialData(
        name: 'مریم حسینی',
        text: context.tr('testimonial_4'),
        rating: 5,
        avatarColor: AppColors.warning,
      ),
    ];
  }
}

class TestimonialData {
  final String name;
  final String text;
  final int rating;
  final Color avatarColor;

  TestimonialData({
    required this.name,
    required this.text,
    required this.rating,
    required this.avatarColor,
  });
}
