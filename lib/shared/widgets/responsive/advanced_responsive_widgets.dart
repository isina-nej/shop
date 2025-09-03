// Advanced Responsive Widget Collection
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/responsive_utils.dart';

// Responsive Masonry Grid
class ResponsiveMasonryGrid extends StatelessWidget {
  final List<Widget> children;
  final double spacing;
  final EdgeInsets? padding;

  const ResponsiveMasonryGrid({
    super.key,
    required this.children,
    this.spacing = 16.0,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final columns = ResponsiveUtils.getResponsiveValue(
      context,
      mobile: 2,
      tablet: 3,
      desktop: 4,
    );

    return Container(
      padding: padding ?? ResponsiveUtils.getResponsivePadding(context),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return _buildMasonryLayout(context, constraints, columns);
        },
      ),
    );
  }

  Widget _buildMasonryLayout(
    BuildContext context,
    BoxConstraints constraints,
    int columns,
  ) {
    final columnWidth =
        (constraints.maxWidth - (spacing * (columns - 1))) / columns;
    final columnChildren = List.generate(columns, (index) => <Widget>[]);
    final columnHeights = List.filled(columns, 0.0);

    for (int i = 0; i < children.length; i++) {
      final shortestColumnIndex = columnHeights.indexOf(
        columnHeights.reduce((a, b) => a < b ? a : b),
      );
      columnChildren[shortestColumnIndex].add(children[i]);
      columnHeights[shortestColumnIndex] +=
          ResponsiveUtils.getResponsiveImageHeight(context, baseHeight: 200.0);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        columns,
        (index) => Expanded(
          child: Column(
            children: columnChildren[index].map((child) {
              return Container(
                width: columnWidth,
                margin: EdgeInsets.only(
                  bottom: spacing,
                  right: index < columns - 1 ? spacing / 2 : 0,
                  left: index > 0 ? spacing / 2 : 0,
                ),
                child: child,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

// Responsive Section Header
class ResponsiveSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onSeeAll;
  final Widget? icon;
  final bool centerTitle;

  const ResponsiveSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onSeeAll,
    this.icon,
    this.centerTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return Container(
      padding: ResponsiveUtils.getResponsivePadding(context),
      child: Column(
        crossAxisAlignment: centerTitle || isMobile
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: centerTitle
                ? MainAxisAlignment.center
                : MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: centerTitle
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: [
                    if (icon != null) ...[
                      icon!,
                      SizedBox(width: AppDimensions.paddingS),
                    ],
                    Flexible(
                      child: Text(
                        title,
                        style: ResponsiveUtils.getResponsiveValue(
                          context,
                          mobile: AppTextStyles.headlineSmall,
                          tablet: AppTextStyles.headlineMedium,
                          desktop: AppTextStyles.headlineLarge,
                        ).copyWith(fontWeight: FontWeight.bold),
                        textAlign: centerTitle
                            ? TextAlign.center
                            : TextAlign.start,
                      ),
                    ),
                  ],
                ),
              ),
              if (onSeeAll != null && !centerTitle)
                TextButton(
                  onPressed: onSeeAll,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.paddingM,
                      vertical: AppDimensions.paddingS,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'مشاهده همه',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: AppDimensions.paddingXS),
                      Icon(
                        Icons.arrow_back_ios,
                        size: 14.sp,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
            ],
          ),
          if (subtitle != null) ...[
            SizedBox(height: AppDimensions.marginS),
            Text(
              subtitle!,
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey[600]),
              textAlign: centerTitle ? TextAlign.center : TextAlign.start,
            ),
          ],
          if (onSeeAll != null && centerTitle) ...[
            SizedBox(height: AppDimensions.marginM),
            TextButton(onPressed: onSeeAll, child: Text('مشاهده همه')),
          ],
        ],
      ),
    );
  }
}

// Responsive Product Card
class ResponsiveProductCard extends StatefulWidget {
  final String title;
  final String? subtitle;
  final String price;
  final String? originalPrice;
  final String imageUrl;
  final double? rating;
  final bool isFavorite;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final String? badge;
  final bool isCompact;

  const ResponsiveProductCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.price,
    this.originalPrice,
    required this.imageUrl,
    this.rating,
    this.isFavorite = false,
    this.onTap,
    this.onFavorite,
    this.badge,
    this.isCompact = false,
  });

  @override
  State<ResponsiveProductCard> createState() => _ResponsiveProductCardState();
}

class _ResponsiveProductCardState extends State<ResponsiveProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          widget.onTap?.call();
        },
        onTapCancel: () => _controller.reverse(),
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : AppColors.white,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  border: _isHovered
                      ? Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          width: 2.w,
                        )
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: _isHovered
                          ? (isDark
                                    ? AppColors.shadowDark
                                    : AppColors.shadowLight)
                                .withValues(alpha: 0.15)
                          : (isDark
                                    ? AppColors.shadowDark
                                    : AppColors.shadowLight)
                                .withValues(alpha: 0.08),
                      blurRadius: _isHovered ? 20.r : 10.r,
                      offset: Offset(0, _isHovered ? 10.h : 5.h),
                      spreadRadius: _isHovered ? 2.r : 0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image Section
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(
                              ResponsiveUtils.getResponsiveBorderRadius(
                                context,
                                baseRadius: AppDimensions.radiusM,
                              ),
                            ),
                          ),
                          child: Container(
                            height: widget.isCompact
                                ? ResponsiveUtils.getResponsiveImageHeight(
                                    context,
                                    baseHeight: 120.0,
                                  )
                                : ResponsiveUtils.getResponsiveImageHeight(
                                    context,
                                    baseHeight: 180.0,
                                  ),
                            width: double.infinity,
                            color: AppColors.grey100,
                            child: widget.imageUrl.isNotEmpty
                                ? Image.asset(
                                    widget.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return _buildPlaceholder();
                                    },
                                  )
                                : _buildPlaceholder(),
                          ),
                        ),

                        // Badge
                        if (widget.badge != null)
                          Positioned(
                            top: AppDimensions.paddingS,
                            right: AppDimensions.paddingS,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppDimensions.paddingS,
                                vertical: AppDimensions.paddingXS,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.error,
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusS,
                                ),
                              ),
                              child: Text(
                                widget.badge!,
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                        // Favorite Button
                        Positioned(
                          top: AppDimensions.paddingS,
                          left: AppDimensions.paddingS,
                          child: GestureDetector(
                            onTap: widget.onFavorite,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: EdgeInsets.all(AppDimensions.paddingS),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.9),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 4.r,
                                    offset: Offset(0, 2.h),
                                  ),
                                ],
                              ),
                              child: Icon(
                                widget.isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: 18.sp,
                                color: widget.isFavorite
                                    ? AppColors.error
                                    : AppColors.grey600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Content Section
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(AppDimensions.paddingM),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              widget.title,
                              style:
                                  (widget.isCompact
                                          ? AppTextStyles.bodyMedium
                                          : AppTextStyles.bodyLarge)
                                      .copyWith(fontWeight: FontWeight.w600),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),

                            if (widget.subtitle != null) ...[
                              SizedBox(height: AppDimensions.paddingXS),
                              Text(
                                widget.subtitle!,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.grey600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],

                            const Spacer(),

                            // Rating
                            if (widget.rating != null) ...[
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    size: 16.sp,
                                    color: AppColors.warning,
                                  ),
                                  SizedBox(width: AppDimensions.paddingXS),
                                  Text(
                                    widget.rating!.toStringAsFixed(1),
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.grey600,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: AppDimensions.paddingS),
                            ],

                            // Price
                            Row(
                              children: [
                                Text(
                                  widget.price,
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (widget.originalPrice != null) ...[
                                  SizedBox(width: AppDimensions.paddingS),
                                  Text(
                                    widget.originalPrice!,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.grey600,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.grey200, AppColors.grey100],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 48.sp,
          color: AppColors.grey400,
        ),
      ),
    );
  }
}

// Responsive Stats Card
class ResponsiveStatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? color;
  final String? subtitle;
  final VoidCallback? onTap;

  const ResponsiveStatsCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.color,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? AppColors.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(AppDimensions.paddingL),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [cardColor, cardColor.withValues(alpha: 0.8)],
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          boxShadow: [
            BoxShadow(
              color: cardColor.withValues(alpha: 0.3),
              blurRadius: 15.r,
              offset: Offset(0, 8.h),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(AppDimensions.paddingS),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                  child: Icon(icon, color: Colors.white, size: 24.sp),
                ),
              ],
            ),

            SizedBox(height: AppDimensions.marginM),

            Text(
              value,
              style: ResponsiveUtils.getResponsiveValue(
                context,
                mobile: AppTextStyles.headlineMedium,
                tablet: AppTextStyles.headlineLarge,
                desktop: AppTextStyles.displaySmall,
              ).copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),

            if (subtitle != null) ...[
              SizedBox(height: AppDimensions.marginS),
              Text(
                subtitle!,
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
