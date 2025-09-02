// Enhanced Home Widget with Modern Responsive Components
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../shared/widgets/responsive/responsive_card_grid.dart';
import '../../../../shared/widgets/responsive/advanced_responsive_widgets.dart';
import '../../../../shared/widgets/responsive/responsive_showcase_widgets.dart';

class EnhancedHomeContent extends StatelessWidget {
  const EnhancedHomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          // Hero Section
          ResponsiveHeroSection(
            title: 'سینا شاپ',
            subtitle: 'بهترین محصولات با کیفیت برتر',
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            actions: [
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.shopping_bag, size: 20.sp),
                label: Text('شروع خرید'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingL,
                    vertical: AppDimensions.paddingM,
                  ),
                ),
              ),
              SizedBox(width: AppDimensions.marginM),
              OutlinedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.explore, size: 20.sp),
                label: Text('کاوش محصولات'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingL,
                    vertical: AppDimensions.paddingM,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: AppDimensions.marginXL),

          // Stats Section
          ResponsiveSectionHeader(
            title: 'آمار فروشگاه',
            subtitle: 'عملکرد ما در یک نگاه',
            icon: Icon(Icons.analytics, color: AppColors.primary),
          ),

          SizedBox(height: AppDimensions.marginL),

          ResponsiveCardGrid(
            cards: [
              ResponsiveStatsCard(
                title: 'کل محصولات',
                value: '12,450',
                icon: Icons.inventory,
                color: AppColors.primary,
                subtitle: '+5% نسبت به ماه گذشته',
              ),
              ResponsiveStatsCard(
                title: 'مشتریان فعال',
                value: '8,290',
                icon: Icons.people,
                color: AppColors.success,
                subtitle: '+12% رشد ماهانه',
              ),
              ResponsiveStatsCard(
                title: 'سفارشات امروز',
                value: '156',
                icon: Icons.shopping_cart,
                color: AppColors.warning,
                subtitle: 'در حال پردازش',
              ),
            ],
          ),

          SizedBox(height: AppDimensions.marginXXL),

          // Features Section
          ResponsiveSectionHeader(
            title: 'امکانات ویژه',
            subtitle: 'تجربه خرید بهتر با ما',
            icon: Icon(Icons.star, color: AppColors.primary),
          ),

          SizedBox(height: AppDimensions.marginL),

          ResponsiveFeatureGrid(
            features: [
              FeatureItem(
                icon: Icons.local_shipping,
                title: 'ارسال سریع',
                description: 'ارسال رایگان برای سفارشات بالای ۵۰۰ هزار تومان',
                color: AppColors.primary,
              ),
              FeatureItem(
                icon: Icons.support_agent,
                title: 'پشتیبانی ۲۴/۷',
                description: 'تیم پشتیبانی ما همیشه آماده کمک به شما',
                color: AppColors.success,
              ),
              FeatureItem(
                icon: Icons.verified_user,
                title: 'ضمانت کیفیت',
                description: 'تضمین کیفیت و اصالت تمام محصولات',
                color: AppColors.info,
              ),
              FeatureItem(
                icon: Icons.payment,
                title: 'پرداخت امن',
                description: 'درگاه پرداخت امن و معتبر',
                color: AppColors.warning,
              ),
              FeatureItem(
                icon: Icons.refresh,
                title: 'بازگشت آسان',
                description: 'امکان بازگشت کالا تا ۷ روز پس از خرید',
                color: AppColors.secondary,
              ),
              FeatureItem(
                icon: Icons.discount,
                title: 'تخفیفات ویژه',
                description: 'تخفیفات و پیشنهادات ویژه برای اعضای VIP',
                color: AppColors.error,
              ),
            ],
            centerContent: true,
          ),

          SizedBox(height: AppDimensions.marginXXL),

          // Popular Products with Advanced Cards
          ResponsiveSectionHeader(
            title: 'محصولات پرطرفدار',
            subtitle: 'پرفروش‌ترین محصولات هفته',
            icon: Icon(Icons.trending_up, color: AppColors.primary),
            onSeeAll: () {
              // Navigate to products page
            },
          ),

          SizedBox(height: AppDimensions.marginL),

          ResponsiveCardGrid(
            cards: [
              ResponsiveProductCard(
                title: 'آیفون ۱۵ پرو',
                subtitle: 'Apple',
                price: '۵۲,۹۰۰,۰۰۰ تومان',
                originalPrice: '۵۵,۰۰۰,۰۰۰ تومان',
                imageUrl: 'assets/images/products/iphone15.png',
                rating: 4.8,
                badge: '۵٪',
                onTap: () {
                  // Navigate to product details
                },
              ),
              ResponsiveProductCard(
                title: 'لپ‌تاپ مک‌بوک ایر M2',
                subtitle: 'Apple',
                price: '۶۵,۰۰۰,۰۰۰ تومان',
                imageUrl: 'assets/images/products/macbook.png',
                rating: 4.9,
                onTap: () {
                  // Navigate to product details
                },
              ),
              ResponsiveProductCard(
                title: 'ایرپاد پرو',
                subtitle: 'Apple',
                price: '۱۲,۵۰۰,۰۰۰ تومان',
                originalPrice: '۱۳,۰۰۰,۰۰۰ تومان',
                imageUrl: 'assets/images/products/airpods.png',
                rating: 4.7,
                badge: '۴٪',
                onTap: () {
                  // Navigate to product details
                },
              ),
              ResponsiveProductCard(
                title: 'گلکسی S24 اولترا',
                subtitle: 'Samsung',
                price: '۴۸,۰۰۰,۰۰۰ تومان',
                imageUrl: 'assets/images/products/galaxy.png',
                rating: 4.6,
                onTap: () {
                  // Navigate to product details
                },
                isCompact: true,
              ),
            ],
          ),

          SizedBox(height: AppDimensions.marginXXL),

          // Image Gallery Section
          ResponsiveSectionHeader(
            title: 'گالری تصاویر',
            subtitle: 'نمونه‌ای از محصولات ما',
          ),

          SizedBox(height: AppDimensions.marginL),

          ResponsiveImageGallery(
            images: [
              'assets/images/products/gallery1.jpg',
              'assets/images/products/gallery2.jpg',
              'assets/images/products/gallery3.jpg',
              'assets/images/products/gallery4.jpg',
              'assets/images/products/gallery5.jpg',
            ],
            onImageTap: (imagePath) {
              // Show full-screen image
              _showFullScreenImage(context, imagePath);
            },
          ),

          SizedBox(height: AppDimensions.marginXXL * 2),
        ],
      ),
    );
  }

  void _showFullScreenImage(BuildContext context, String imagePath) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                child: Image.asset(imagePath, fit: BoxFit.contain),
              ),
            ),
            Positioned(
              top: 40,
              right: 20,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close, color: Colors.white, size: 32.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Enhanced Floating Action Hub for Home
class HomeFloatingHub extends StatelessWidget {
  const HomeFloatingHub({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveFloatingHub(
      actions: [
        FloatingAction(
          icon: Icons.search,
          backgroundColor: AppColors.primary,
          onPressed: () {
            // Open search
          },
          tooltip: 'جستجو',
        ),
        FloatingAction(
          icon: Icons.shopping_cart,
          backgroundColor: AppColors.success,
          onPressed: () {
            // Open cart
          },
          tooltip: 'سبد خرید',
        ),
        FloatingAction(
          icon: Icons.favorite,
          backgroundColor: AppColors.error,
          onPressed: () {
            // Open favorites
          },
          tooltip: 'علاقه‌مندی‌ها',
        ),
        FloatingAction(
          icon: Icons.chat,
          backgroundColor: AppColors.warning,
          onPressed: () {
            // Open chat support
            _showSupportChat(context);
          },
          tooltip: 'پشتیبانی',
        ),
      ],
    );
  }

  void _showSupportChat(BuildContext context) {
    ResponsiveActionSheet.show<String>(
      context: context,
      title: 'پشتیبانی',
      subtitle: 'چگونه می‌توانیم کمکتان کنیم؟',
      actions: [
        ActionSheetItem(
          title: 'چت زنده',
          icon: Icons.chat_bubble,
          value: 'live_chat',
        ),
        ActionSheetItem(
          title: 'تماس تلفنی',
          icon: Icons.phone,
          value: 'phone_call',
        ),
        ActionSheetItem(title: 'ایمیل', icon: Icons.email, value: 'email'),
        ActionSheetItem(title: 'سوالات متداول', icon: Icons.help, value: 'faq'),
      ],
    ).then((result) {
      if (result != null) {
        // Handle support option selection
        debugPrint('Selected support option: $result');
      }
    });
  }
}
