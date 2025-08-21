// Special Offers Widget
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_text_styles.dart';

class SpecialOffers extends StatelessWidget {
  const SpecialOffers({super.key});

  // Mock special offers data
  static const List<OfferModel> _offers = [
    OfferModel(
      id: '1',
      title: 'تخفیف 50% محصولات الکترونیکی',
      description: 'تا پایان هفته فرصت استفاده از این تخفیف را دارید',
      discount: '50%',
      backgroundColor: AppColors.error,
      textColor: AppColors.white,
      imageUrl:
          'https://via.placeholder.com/400x200/EF4444/FFFFFF?text=50%+OFF',
      validUntil: '۱۴۰۳/۰۱/۱۵',
    ),
    OfferModel(
      id: '2',
      title: 'ارسال رایگان برای خرید بالای ۵ میلیون',
      description: 'بدون هزینه اضافی محصولات خود را دریافت کنید',
      discount: 'رایگان',
      backgroundColor: AppColors.success,
      textColor: AppColors.white,
      imageUrl:
          'https://via.placeholder.com/400x200/10B981/FFFFFF?text=FREE+SHIPPING',
      validUntil: '۱۴۰۳/۰۲/۳۰',
    ),
    OfferModel(
      id: '3',
      title: 'کد تخفیف ویژه کاربران جدید',
      description: 'با کد WELCOME30 از 30% تخفیف بهره‌مند شوید',
      discount: '30%',
      backgroundColor: AppColors.primary,
      textColor: AppColors.white,
      imageUrl:
          'https://via.placeholder.com/400x200/667EEA/FFFFFF?text=WELCOME30',
      validUntil: '۱۴۰۳/۰۱/۳۱',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Offers List
          SizedBox(
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingM,
              ),
              itemCount: _offers.length,
              itemBuilder: (context, index) {
                final offer = _offers[index];
                return Container(
                  width: 320,
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
      ),
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
              offer.backgroundColor.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          boxShadow: [
            BoxShadow(
              color: offer.backgroundColor.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
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
                        Colors.white.withOpacity(0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(AppDimensions.paddingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Discount Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingM,
                      vertical: AppDimensions.paddingS,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusXL,
                      ),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      offer.discount,
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: offer.textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: AppDimensions.paddingM),

                  // Title
                  Text(
                    offer.title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: offer.textColor,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: AppDimensions.paddingS),

                  // Description
                  Expanded(
                    child: Text(
                      offer.description,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: offer.textColor.withOpacity(0.9),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Valid Until
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: 16,
                        color: offer.textColor.withOpacity(0.8),
                      ),
                      const SizedBox(width: AppDimensions.paddingXS),
                      Text(
                        'معتبر تا: ${offer.validUntil}',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: offer.textColor.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Arrow Icon
            Positioned(
              bottom: AppDimensions.paddingM,
              left: AppDimensions.paddingM,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: offer.textColor,
                  size: 16,
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
