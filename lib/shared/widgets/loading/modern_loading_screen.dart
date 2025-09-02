import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:math' as math;
import '../../../core/localization/translation_manager.dart';

class ModernLoadingScreen extends StatefulWidget {
  final Widget? child;
  final Future<void>? initializationFuture;
  final String? status;

  const ModernLoadingScreen({
    super.key,
    this.child,
    this.initializationFuture,
    this.status,
  });

  @override
  State<ModernLoadingScreen> createState() => _ModernLoadingScreenState();
}

class _ModernLoadingScreenState extends State<ModernLoadingScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  bool _showContent = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    // Only initialize if we need to wait for something
    if (widget.initializationFuture != null) {
      _initializeApp();
    } else {
      // If no initialization future, check if we have a child to show
      if (widget.child != null) {
        // Show loading for a short time then show child
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) {
            setState(() {
              _showContent = true;
            });
          }
        });
      }
      // If no child, just keep showing loading (controlled externally)
    }
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_rotationController);

    _fadeController.forward();
    _scaleController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      // Wait for the initialization future if provided
      if (widget.initializationFuture != null) {
        await widget.initializationFuture!;
      }

      if (mounted) {
        setState(() {
          _showContent = true;
        });
      }
    } catch (e) {
      // Handle initialization errors
      if (mounted) {
        setState(() {
          _showContent = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_showContent && widget.child != null) {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        child: widget.child,
      );
    }

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0A0A0A)
          : const Color(0xFFF8F9FA),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF0A0A0A),
                    const Color(0xFF1A1A1A),
                    const Color(0xFF2A2A2A),
                  ]
                : [
                    const Color(0xFFF8F9FA),
                    const Color(0xFFE3F2FD),
                    const Color(0xFFBBDEFB),
                  ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Logo/Icon Section
              Expanded(
                flex: 3,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: _buildLogoSection(context, isDark),
                      );
                    },
                  ),
                ),
              ),

              // Loading Animation Section
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLoadingAnimation(isDark),
                    SizedBox(height: 32.0.h),
                    _buildLoadingText(theme),
                  ],
                ),
              ),

              // Bottom Section with App Info
              Expanded(flex: 1, child: _buildBottomSection(theme, isDark)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoSection(BuildContext context, bool isDark) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        const Color(0xFF6366F1),
                        const Color(0xFF8B5CF6),
                        const Color(0xFFA855F7),
                      ]
                    : [
                        const Color(0xFF3B82F6),
                        const Color(0xFF6366F1),
                        const Color(0xFF8B5CF6),
                      ],
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? const Color(0xFF6366F1).withValues(alpha: 0.3)
                      : const Color(0xFF3B82F6).withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: AnimatedBuilder(
              animation: _rotationAnimation,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _rotationAnimation.value * 2 * 3.14159,
                  child: Icon(
                    Icons.shopping_bag_outlined,
                    size: 60,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingAnimation(bool isDark) {
    return Column(
      children: [
        // Modern Spinner
        SpinKitWave(
          color: isDark ? const Color(0xFF6366F1) : const Color(0xFF3B82F6),
          size: 40.0,
          duration: const Duration(milliseconds: 1200),
        ),
        SizedBox(height: 24.0.h),

        // Progress Bar
        Container(
          width: 200,
          height: 4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: isDark ? Colors.grey[800] : Colors.grey[300],
          ),
          child: Shimmer.fromColors(
            baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
            highlightColor: isDark
                ? const Color(0xFF6366F1)
                : const Color(0xFF3B82F6),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingText(ThemeData theme) {
    return Column(
      children: [
        // Show custom status if provided, otherwise show default
        Text(
          widget.status ??
              (TranslationManager.instance.translate('loading') != 'loading'
                  ? TranslationManager.instance.translate('loading')
                  : 'Loading...'),
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.brightness == Brightness.dark
                ? Colors.white
                : Colors.black87,
          ),
        ),
        SizedBox(height: 8.0.h),
        Text(
          TranslationManager.instance.translate('please_wait') != 'please_wait'
              ? TranslationManager.instance.translate('please_wait')
              : 'Please wait...',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.brightness == Brightness.dark
                ? Colors.grey[400]
                : Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomSection(ThemeData theme, bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Loading dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return AnimatedBuilder(
              animation: _rotationController,
              builder: (context, child) {
                double delay = index * 0.3;
                double animValue = (_rotationController.value + delay) % 1;
                double opacity = (1 + math.cos(animValue * 2 * math.pi)) / 2;

                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        (isDark
                                ? const Color(0xFF6366F1)
                                : const Color(0xFF3B82F6))
                            .withValues(alpha: opacity),
                  ),
                );
              },
            );
          }),
        ),
        SizedBox(height: 24.0.h),

        // Version info
        Text(
          'Version 1.0.0',
          style: theme.textTheme.bodySmall?.copyWith(
            color: isDark ? Colors.grey[500] : Colors.grey[400],
          ),
        ),
        SizedBox(height: 16.0.h),
      ],
    );
  }
}
