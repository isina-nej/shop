// Product Description Widget (Placeholder)
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/data/models/product_model.dart';

class ProductDescription extends StatelessWidget {
  final ProductModel product;

  const ProductDescription({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingM),
      margin: EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.grey200,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Center(
        child: Text(
          'Product Description\n(Coming Soon)',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.grey600, fontSize: 16.0.sp),
        ),
      ),
    );
  }
}
