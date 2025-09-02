// Product Image Gallery Widget (Placeholder)
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';

class ProductImageGallery extends StatelessWidget {
  final List<String> imageUrls;
  final Function(int)? onImageTap;

  const ProductImageGallery({
    super.key,
    required this.imageUrls,
    this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      margin: EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.grey200,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: Center(
        child: Text(
          'Product Image Gallery\n(Coming Soon)',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.grey600, fontSize: 16.0.sp),
        ),
      ),
    );
  }
}
