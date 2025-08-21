// Banner Slider Widget
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';

class BannerSlider extends StatefulWidget {
  const BannerSlider({super.key});

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Mock banner data
  final List<BannerModel> _banners = [
    BannerModel(
      id: '1',
      title: 'تخفیف ویژه ۵۰٪',
      subtitle: 'روی تمام محصولات الکترونیکی',
      imageUrl: 'assets/images/banners/banner1.jpg',
      color: AppColors.primary,
    ),
    BannerModel(
      id: '2',
      title: 'ارسال رایگان',
      subtitle: 'برای سفارش‌های بالای ۱۰۰ هزار تومان',
      imageUrl: 'assets/images/banners/banner2.jpg',
      color: AppColors.secondary,
    ),
    BannerModel(
      id: '3',
      title: 'محصولات جدید',
      subtitle: 'کلکسیون بهاری را کشف کنید',
      imageUrl: 'assets/images/banners/banner3.jpg',
      color: AppColors.accent,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        final nextPage = (_currentPage + 1) % _banners.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        _startAutoScroll();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingM),
      child: Stack(
        children: [
          // Banner PageView
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _banners.length,
            itemBuilder: (context, index) {
              final banner = _banners[index];
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  gradient: LinearGradient(
                    colors: [banner.color, banner.color.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    // Background Pattern
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusM,
                          ),
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.1),
                              Colors.transparent,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),
                    // Content
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.all(AppDimensions.paddingL),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                banner.title,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.paddingS),
                            Flexible(
                              child: Text(
                                banner.subtitle,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.white,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(height: AppDimensions.paddingS),
                            ElevatedButton(
                              onPressed: () {
                                // TODO: Handle banner action
                                debugPrint('Banner clicked: ${banner.title}');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.white,
                                foregroundColor: banner.color,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.radiusS,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppDimensions.paddingM,
                                  vertical: AppDimensions.paddingS,
                                ),
                              ),
                              child: const Text('مشاهده'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Page Indicators
          Positioned(
            bottom: 16,
            right: 16,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: _banners.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => _pageController.animateToPage(
                    entry.key,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  ),
                  child: Container(
                    width: 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(horizontal: 2.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == entry.key
                          ? AppColors.white
                          : AppColors.white.withOpacity(0.4),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

// Banner Model
class BannerModel {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final Color color;

  BannerModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.color,
  });
}
