// Product Info Section Widget (Placeholder)
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/data/models/product_model.dart';

class ProductInfoSection extends StatelessWidget {
  final ProductModel product;
  final int selectedQuantity;
  final Function(int)? onQuantityChanged;

  const ProductInfoSection({
    super.key,
    required this.product,
    required this.selectedQuantity,
    this.onQuantityChanged,
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
          'Product Info Section\n(Coming Soon)',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.grey600, fontSize: 16),
        ),
      ),
    );
  }
}
