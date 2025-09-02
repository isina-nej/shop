// Special Offers Widget
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/localization/localization_extension.dart';

class SpecialOffers extends StatelessWidget {
  const SpecialOffers({super.key});

  // Mock special offers data
  static const List<OfferModel> _offers = [
    OfferModel(
      id: '1',
      title: 'electronic_discount',
      description: 'electronic_discount_desc',
      discount: '50%',
      backgroundColor: AppColors.error,
      textColor: AppColors.white,
      imageUrl: 'assets/images/banners/offer_50_percent.png',
      validUntil: '۱۴۰۳/۰۱/۱۵',
    ),
    OfferModel(
      id: '2',
      title: 'free_shipping_offer',
      description: 'free_shipping_desc',
      discount: 'free',
      backgroundColor: AppColors.success,
      textColor: AppColors.white,
      imageUrl: 'assets/images/banners/free_shipping.png',
      validUntil: '۱۴۰۳/۰۲/۳۰',
    ),
    OfferModel(
      id: '3',
      title: 'new_user_discount',
      description: 'new_user_discount_desc',
      discount: '30%',
      backgroundColor: AppColors.primary,
      textColor: AppColors.white,
      imageUrl: 'assets/images/banners/welcome_30.png',
      validUntil: '۱۴۰۳/۰۱/۳۱',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isMobile = screenWidth < 600;
        final isTablet = screenWidth >= 600 && screenWidth < 1024;

        // Responsive card dimensions
        final cardWidth = isMobile
            ? screenWidth *
                  0.85 // 85% of screen width on mobile
            : isTablet
            ? 320
                  .w // Fixed width on tablet
            : 400.w; // Larger on desktop

        final cardHeight = isMobile
            ? AppDimensions.cardHeightM *
                  0.9 // Slightly smaller on mobile
            : AppDimensions.cardHeightM;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Offers List
            SizedBox(
              height: cardHeight,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingM,
                ),
                itemCount: _offers.length,
                itemBuilder: (context, index) {
                  final offer = _offers[index];
                  return Container(
                    width: cardWidth,
                    margin: EdgeInsets.only(
                      left: index < _offers.length - 1
                          ? AppDimensions.paddingM
                          : 0,
                    ),
                    child: _OfferCard(offer: offer),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _OfferCard extends StatelessWidget {
  final OfferModel offer;

  const _OfferCard({required this.offer});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Handle offer tap
        debugPrint('Offer selected: ${offer.title}');
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              offer.backgroundColor,
              offer.backgroundColor.withValues(alpha: 0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          boxShadow: [
            BoxShadow(
              color: offer.backgroundColor.withValues(alpha: 0.3),
              blurRadius: 12.r,
              offset: Offset(0, 4.h),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background Pattern
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.white.withValues(alpha: 0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Content
            ClipRect(
              child: Padding(
                padding: EdgeInsets.all(AppDimensions.paddingS),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Discount Badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.paddingS,
                          vertical: AppDimensions.paddingXS,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusM,
                          ),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          context.tr(offer.discount) != offer.discount
                              ? context.tr(offer.discount)
                              : offer.discount,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: offer.textColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      SizedBox(height: AppDimensions.paddingXS),

                      // Title
                      Text(
                        context.tr(offer.title),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: offer.textColor,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: AppDimensions.paddingXS),

                      // Description
                      Text(
                        context.tr(offer.description),
                        style: AppTextStyles.labelSmall.copyWith(
                          color: offer.textColor.withValues(alpha: 0.9),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: AppDimensions.paddingXS),

                      // Valid Until
                      Row(
                        children: [
                          Icon(
                            Icons.schedule,
                            size: AppDimensions.iconXS,
                            color: offer.textColor.withValues(alpha: 0.8),
                          ),
                          SizedBox(width: AppDimensions.paddingXS),
                          Expanded(
                            child: Text(
                              '${context.tr('valid_until')} ${offer.validUntil}',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: offer.textColor.withValues(alpha: 0.8),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Arrow Icon
            Positioned(
              bottom: AppDimensions.paddingM,
              left: AppDimensions.paddingM,
              child: Container(
                width: 32.w,
                height: 32.h,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1.w,
                  ),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: offer.textColor,
                  size: AppDimensions.iconXS,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Offer Model
class OfferModel {
  final String id;
  final String title;
  final String description;
  final String discount;
  final Color backgroundColor;
  final Color textColor;
  final String imageUrl;
  final String validUntil;

  const OfferModel({
    required this.id,
    required this.title,
    required this.description,
    required this.discount,
    required this.backgroundColor,
    required this.textColor,
    required this.imageUrl,
    required this.validUntil,
  });
}
