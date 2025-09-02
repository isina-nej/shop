// Responsive Showcase Widgets - خفن‌ترین ویجت‌های ریسپانسیو
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/responsive_utils.dart';

// Responsive Floating Action Hub
class ResponsiveFloatingHub extends StatefulWidget {
  final List<FloatingAction> actions;
  final IconData mainIcon;
  final Color? backgroundColor;
  final bool mini;

  const ResponsiveFloatingHub({
    super.key,
    required this.actions,
    this.mainIcon = Icons.add,
    this.backgroundColor,
    this.mini = false,
  });

  @override
  State<ResponsiveFloatingHub> createState() => _ResponsiveFloatingHubState();
}

class _ResponsiveFloatingHubState extends State<ResponsiveFloatingHub>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  late Animation<double> _rotationAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.75,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Background overlay
        if (_isExpanded)
          GestureDetector(
            onTap: _toggle,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withValues(alpha: 0.3),
            ),
          ),

        // Action buttons
        ...List.generate(widget.actions.length, (index) {
          return AnimatedBuilder(
            animation: _expandAnimation,
            builder: (context, child) {
              final offset = (index + 1) * 70.0 * _expandAnimation.value;
              return Positioned(
                bottom: offset,
                child: Transform.scale(
                  scale: _expandAnimation.value,
                  child: FloatingActionButton(
                    heroTag: "fab_$index",
                    mini: isMobile ? true : widget.mini,
                    backgroundColor: widget.actions[index].backgroundColor,
                    onPressed: () {
                      widget.actions[index].onPressed();
                      _toggle();
                    },
                    child: Icon(
                      widget.actions[index].icon,
                      color: widget.actions[index].iconColor ?? Colors.white,
                    ),
                  ),
                ),
              );
            },
          );
        }),

        // Main FAB
        AnimatedBuilder(
          animation: _rotationAnimation,
          builder: (context, child) {
            return FloatingActionButton(
              heroTag: "main_fab",
              backgroundColor: widget.backgroundColor ?? AppColors.primary,
              onPressed: _toggle,
              child: Transform.rotate(
                angle: _rotationAnimation.value * 2 * 3.14159,
                child: Icon(
                  _isExpanded ? Icons.close : widget.mainIcon,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class FloatingAction {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final String? tooltip;

  const FloatingAction({
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.tooltip,
  });
}

// Responsive Feature Grid
class ResponsiveFeatureGrid extends StatelessWidget {
  final List<FeatureItem> features;
  final EdgeInsets? padding;
  final bool centerContent;

  const ResponsiveFeatureGrid({
    super.key,
    required this.features,
    this.padding,
    this.centerContent = false,
  });

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = ResponsiveUtils.getResponsiveValue(
      context,
      mobile: 2,
      tablet: 3,
      desktop: 4,
    );

    return Container(
      padding: padding ?? ResponsiveUtils.getResponsivePadding(context),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 1.1,
          crossAxisSpacing: AppDimensions.paddingM,
          mainAxisSpacing: AppDimensions.paddingM,
        ),
        itemCount: features.length,
        itemBuilder: (context, index) {
          return _FeatureCard(
            feature: features[index],
            centerContent: centerContent,
          );
        },
      ),
    );
  }
}

class FeatureItem {
  final IconData icon;
  final String title;
  final String description;
  final Color? color;
  final VoidCallback? onTap;

  const FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
    this.color,
    this.onTap,
  });
}

class _FeatureCard extends StatefulWidget {
  final FeatureItem feature;
  final bool centerContent;

  const _FeatureCard({required this.feature, this.centerContent = false});

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
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
    final featureColor = widget.feature.color ?? AppColors.primary;

    return MouseRegion(
      onEnter: (_) {
        setState(() => _isHovered = true);
        _controller.forward();
      },
      onExit: (_) {
        setState(() => _isHovered = false);
        _controller.reverse();
      },
      child: GestureDetector(
        onTap: widget.feature.onTap,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : AppColors.white,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                  border: _isHovered
                      ? Border.all(
                          color: featureColor.withValues(alpha: 0.5),
                          width: 2.w,
                        )
                      : null,
                  boxShadow: [
                    BoxShadow(
                      color: _isHovered
                          ? featureColor.withValues(alpha: 0.2)
                          : (isDark
                                    ? AppColors.shadowDark
                                    : AppColors.shadowLight)
                                .withValues(alpha: 0.1),
                      blurRadius: _isHovered ? 20.r : 10.r,
                      offset: Offset(0, _isHovered ? 10.h : 5.h),
                      spreadRadius: _isHovered ? 2.r : 0,
                    ),
                  ],
                ),
                padding: EdgeInsets.all(AppDimensions.paddingL),
                child: Column(
                  mainAxisAlignment: widget.centerContent
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  crossAxisAlignment: widget.centerContent
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.all(AppDimensions.paddingM),
                      decoration: BoxDecoration(
                        color: _isHovered
                            ? featureColor
                            : featureColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusM,
                        ),
                      ),
                      child: Icon(
                        widget.feature.icon,
                        size: 32.sp,
                        color: _isHovered ? Colors.white : featureColor,
                      ),
                    ),

                    SizedBox(height: AppDimensions.marginM),

                    Text(
                      widget.feature.title,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: widget.centerContent
                          ? TextAlign.center
                          : TextAlign.start,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: AppDimensions.marginS),

                    Text(
                      widget.feature.description,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.grey[600],
                      ),
                      textAlign: widget.centerContent
                          ? TextAlign.center
                          : TextAlign.start,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
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
}

// Responsive Image Gallery
class ResponsiveImageGallery extends StatefulWidget {
  final List<String> images;
  final double? aspectRatio;
  final int? crossAxisCount;
  final EdgeInsets? padding;
  final Function(String)? onImageTap;

  const ResponsiveImageGallery({
    super.key,
    required this.images,
    this.aspectRatio,
    this.crossAxisCount,
    this.padding,
    this.onImageTap,
  });

  @override
  State<ResponsiveImageGallery> createState() => _ResponsiveImageGalleryState();
}

class _ResponsiveImageGalleryState extends State<ResponsiveImageGallery> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return Container(
      padding: widget.padding ?? ResponsiveUtils.getResponsivePadding(context),
      child: Column(
        children: [
          // Main Image
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: ResponsiveUtils.getResponsiveValue(
              context,
              mobile: 250.h,
              tablet: 350.h,
              desktop: 400.h,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowLight.withValues(alpha: 0.2),
                  blurRadius: 15.r,
                  offset: Offset(0, 8.h),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              child: GestureDetector(
                onTap: () =>
                    widget.onImageTap?.call(widget.images[_selectedIndex]),
                child: Image.asset(
                  widget.images[_selectedIndex],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.grey200,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusL,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.broken_image,
                          size: 64.sp,
                          color: AppColors.grey400,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          SizedBox(height: AppDimensions.marginL),

          // Thumbnail Grid
          SizedBox(
            height: isMobile ? 80.h : 100.h,
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 1.0,
                mainAxisSpacing: AppDimensions.paddingS,
              ),
              itemCount: widget.images.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => setState(() => _selectedIndex = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusM,
                      ),
                      border: _selectedIndex == index
                          ? Border.all(color: AppColors.primary, width: 3.w)
                          : null,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusM,
                      ),
                      child: Image.asset(
                        widget.images[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.grey200,
                            child: Icon(Icons.image, color: AppColors.grey400),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Responsive Action Sheet
class ResponsiveActionSheet {
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    String? subtitle,
    required List<ActionSheetItem<T>> actions,
    bool isDismissible = true,
  }) {
    final isMobile = ResponsiveUtils.isMobile(context);

    if (isMobile) {
      return showModalBottomSheet<T>(
        context: context,
        isDismissible: isDismissible,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => _MobileActionSheet<T>(
          title: title,
          subtitle: subtitle,
          actions: actions,
        ),
      );
    } else {
      return showDialog<T>(
        context: context,
        barrierDismissible: isDismissible,
        builder: (context) => _DesktopActionSheet<T>(
          title: title,
          subtitle: subtitle,
          actions: actions,
        ),
      );
    }
  }
}

class ActionSheetItem<T> {
  final String title;
  final IconData? icon;
  final T value;
  final bool isDestructive;
  final bool isDisabled;

  const ActionSheetItem({
    required this.title,
    required this.value,
    this.icon,
    this.isDestructive = false,
    this.isDisabled = false,
  });
}

class _MobileActionSheet<T> extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<ActionSheetItem<T>> actions;

  const _MobileActionSheet({
    required this.title,
    this.subtitle,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.surfaceDark
            : AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXL),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: EdgeInsets.only(top: AppDimensions.paddingM),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(AppDimensions.paddingL),
            child: Column(
              children: [
                Text(
                  title,
                  style: AppTextStyles.headlineSmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: AppDimensions.marginS),
                  Text(
                    subtitle!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),

          // Actions
          ...actions.map(
            (action) => ListTile(
              leading: action.icon != null
                  ? Icon(
                      action.icon,
                      color: action.isDestructive
                          ? AppColors.error
                          : action.isDisabled
                          ? Colors.grey
                          : null,
                    )
                  : null,
              title: Text(
                action.title,
                style: TextStyle(
                  color: action.isDestructive
                      ? AppColors.error
                      : action.isDisabled
                      ? Colors.grey
                      : null,
                ),
              ),
              enabled: !action.isDisabled,
              onTap: () => Navigator.pop(context, action.value),
            ),
          ),

          SizedBox(height: AppDimensions.paddingXL),
        ],
      ),
    );
  }
}

class _DesktopActionSheet<T> extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<ActionSheetItem<T>> actions;

  const _DesktopActionSheet({
    required this.title,
    this.subtitle,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: subtitle != null ? Text(subtitle!) : null,
      actions: actions
          .map(
            (action) => TextButton(
              onPressed: action.isDisabled
                  ? null
                  : () => Navigator.pop(context, action.value),
              child: Text(
                action.title,
                style: TextStyle(
                  color: action.isDestructive ? AppColors.error : null,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
