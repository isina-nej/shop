// Responsive Card Grid Widget - Professional & Modern
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimensions.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/responsive_utils.dart';

class ResponsiveCardGrid extends StatelessWidget {
  final List<Widget> cards;
  final double? maxWidth;
  final EdgeInsets? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final double spacing;
  final double runSpacing;

  const ResponsiveCardGrid({
    super.key,
    required this.cards,
    this.maxWidth = 1200,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
    this.spacing = 16.0,
    this.runSpacing = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final isTablet = ResponsiveUtils.isTablet(context);

    // Dynamic columns based on screen size
    final columns = isMobile
        ? 1
        : isTablet
        ? 2
        : 3;

    // Dynamic spacing based on screen size
    final dynamicSpacing = ResponsiveUtils.getResponsiveValue(
      context,
      mobile: spacing,
      tablet: spacing * 1.2,
      desktop: spacing * 1.5,
    );

    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth ?? double.infinity),
      padding: padding ?? ResponsiveUtils.getResponsivePadding(context),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return _buildStaggeredGrid(
            context,
            constraints,
            columns,
            dynamicSpacing,
          );
        },
      ),
    );
  }

  Widget _buildStaggeredGrid(
    BuildContext context,
    BoxConstraints constraints,
    int columns,
    double spacing,
  ) {
    final itemWidth =
        (constraints.maxWidth - (spacing * (columns - 1))) / columns;

    return Wrap(
      spacing: spacing,
      runSpacing: runSpacing,
      children: cards.map((card) {
        return SizedBox(
          width: itemWidth,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: card,
          ),
        );
      }).toList(),
    );
  }
}

// Professional Card Widget
class ProfessionalCard extends StatefulWidget {
  final Widget child;
  final Color? backgroundColor;
  final double? elevation;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final bool enableHover;
  final bool enableAnimation;

  const ProfessionalCard({
    super.key,
    required this.child,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.padding,
    this.onTap,
    this.enableHover = true,
    this.enableAnimation = true,
  });

  @override
  State<ProfessionalCard> createState() => _ProfessionalCardState();
}

class _ProfessionalCardState extends State<ProfessionalCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: widget.enableHover ? (_) => _onHover(true) : null,
      onExit: widget.enableHover ? (_) => _onHover(false) : null,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: widget.enableAnimation ? _scaleAnimation.value : 1.0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color:
                      widget.backgroundColor ??
                      (isDark ? AppColors.surfaceDark : AppColors.white),
                  borderRadius:
                      widget.borderRadius ??
                      BorderRadius.circular(AppDimensions.radiusL),
                  boxShadow: [
                    BoxShadow(
                      color: _isHovered
                          ? (isDark
                                    ? AppColors.shadowDark
                                    : AppColors.shadowLight)
                                .withValues(alpha: 0.2)
                          : (isDark
                                    ? AppColors.shadowDark
                                    : AppColors.shadowLight)
                                .withValues(alpha: 0.1),
                      blurRadius: _isHovered ? 16.r : 12.r,
                      offset: Offset(0, _isHovered ? 8.h : 4.h),
                      spreadRadius: _isHovered ? 2.r : 0,
                    ),
                  ],
                  border: _isHovered
                      ? Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          width: 1.w,
                        )
                      : null,
                ),
                padding:
                    widget.padding ?? EdgeInsets.all(AppDimensions.paddingM),
                child: widget.child,
              ),
            );
          },
        ),
      ),
    );
  }

  void _onHover(bool isHovered) {
    if (!mounted) return;
    setState(() {
      _isHovered = isHovered;
    });

    if (widget.enableAnimation) {
      if (isHovered) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }
}

// Responsive Hero Section
class ResponsiveHeroSection extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? backgroundImage;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final EdgeInsets? padding;

  const ResponsiveHeroSection({
    super.key,
    required this.title,
    this.subtitle,
    this.backgroundImage,
    this.actions,
    this.backgroundColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: ResponsiveUtils.getResponsiveValue(
          context,
          mobile: 250.h,
          tablet: 350.h,
          desktop: 450.h,
        ),
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppDimensions.radiusXL),
          bottomRight: Radius.circular(AppDimensions.radiusXL),
        ),
      ),
      child: Stack(
        children: [
          // Background Image
          if (backgroundImage != null)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(AppDimensions.radiusXL),
                  bottomRight: Radius.circular(AppDimensions.radiusXL),
                ),
                child: backgroundImage!,
              ),
            ),

          // Content Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.3),
                  Colors.black.withValues(alpha: 0.6),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(AppDimensions.radiusXL),
                bottomRight: Radius.circular(AppDimensions.radiusXL),
              ),
            ),
          ),

          // Content
          Positioned.fill(
            child: Container(
              padding: padding ?? ResponsiveUtils.getResponsivePadding(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: isMobile
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style:
                        ResponsiveUtils.getResponsiveValue(
                          context,
                          mobile: AppTextStyles.displayMedium,
                          tablet: AppTextStyles.displayLarge,
                          desktop: AppTextStyles.displayLarge,
                        ).copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: isMobile ? TextAlign.center : TextAlign.start,
                  ),

                  if (subtitle != null) ...[
                    SizedBox(height: AppDimensions.marginM),
                    Text(
                      subtitle!,
                      style: ResponsiveUtils.getResponsiveValue(
                        context,
                        mobile: AppTextStyles.bodyLarge,
                        tablet: AppTextStyles.headlineSmall,
                        desktop: AppTextStyles.headlineSmall,
                      ).copyWith(color: Colors.white.withValues(alpha: 0.9)),
                      textAlign: isMobile ? TextAlign.center : TextAlign.start,
                    ),
                  ],

                  if (actions != null && actions!.isNotEmpty) ...[
                    SizedBox(height: AppDimensions.marginXL),
                    isMobile
                        ? Column(children: actions!)
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: actions!,
                          ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
