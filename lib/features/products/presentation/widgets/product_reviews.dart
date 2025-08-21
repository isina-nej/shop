// Product Reviews Widget (Placeholder)
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';

class ProductReviews extends StatelessWidget {
  final double rating;
  final int reviewCount;
  final VoidCallback? onViewAllReviews;

  const ProductReviews({
    super.key,
    required this.rating,
    required this.reviewCount,
    this.onViewAllReviews,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      margin: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.grey200,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: const Center(
        child: Text(
          'Product Reviews\n(Coming Soon)',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.grey600, fontSize: 16),
        ),
      ),
    );
  }
}
