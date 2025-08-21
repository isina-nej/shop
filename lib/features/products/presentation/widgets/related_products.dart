// Related Products Widget (Placeholder)
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';

class RelatedProducts extends StatelessWidget {
  final String currentProductId;
  final Function(String)? onProductTap;

  const RelatedProducts({
    super.key,
    required this.currentProductId,
    this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(AppDimensions.paddingM),
      margin: const EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.grey200,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: const Center(
        child: Text(
          'Related Products\n(Coming Soon)',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.grey600, fontSize: 16),
        ),
      ),
    );
  }
}
