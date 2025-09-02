// Related Products Widget (Placeholder)
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      padding: EdgeInsets.all(AppDimensions.paddingM),
      margin: EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: AppColors.grey200,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child:  Center(
        child: Text(
          'Related Products\n(Coming Soon)',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.grey600, fontSize: 16.0.sp),
        ),
      ),
    );
  }
}
