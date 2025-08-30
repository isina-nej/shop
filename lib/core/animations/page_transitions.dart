// Page Transition Animations
import 'package:flutter/material.dart';

class PageTransitions {
  // Slide from right to left (default navigation)
  static PageRouteBuilder slideRightToLeft(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 300),
    );
  }

  // Slide from bottom to top (for modals/details)
  static PageRouteBuilder slideBottomToTop(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeOutCubic;

        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 350),
      reverseTransitionDuration: const Duration(milliseconds: 250),
    );
  }

  // Scale transition (for detail pages)
  static PageRouteBuilder scaleTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOutBack;

        var scaleAnimation = Tween<double>(
          begin: 0.8,
          end: 1.0,
        ).chain(CurveTween(curve: curve)).animate(animation);

        var fadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: curve)).animate(animation);

        return ScaleTransition(
          scale: scaleAnimation,
          child: FadeTransition(opacity: fadeAnimation, child: child),
        );
      },
      transitionDuration: const Duration(milliseconds: 450),
      reverseTransitionDuration: const Duration(milliseconds: 300),
    );
  }

  // Fade transition (for overlays/search)
  static PageRouteBuilder fadeTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOut;

        var fadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: curve)).animate(animation);

        return FadeTransition(opacity: fadeAnimation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 200),
    );
  }

  // Zoom transition (for special pages)
  static PageRouteBuilder zoomTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.elasticOut;

        var scaleAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: curve)).animate(animation);

        var fadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeIn)).animate(animation);

        return ScaleTransition(
          scale: scaleAnimation,
          child: FadeTransition(opacity: fadeAnimation, child: child),
        );
      },
      transitionDuration: const Duration(milliseconds: 600),
      reverseTransitionDuration: const Duration(milliseconds: 300),
    );
  }

  // Rotate transition (for fun/special pages)
  static PageRouteBuilder rotateTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOutCubic;

        var rotateAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: curve)).animate(animation);

        var scaleAnimation = Tween<double>(
          begin: 0.8,
          end: 1.0,
        ).chain(CurveTween(curve: curve)).animate(animation);

        return RotationTransition(
          turns: rotateAnimation,
          child: ScaleTransition(scale: scaleAnimation, child: child),
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
      reverseTransitionDuration: const Duration(milliseconds: 350),
    );
  }

  // Combined slide and scale (premium feel)
  static PageRouteBuilder slideAndScaleTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const slideCurve = Curves.easeInOutCubic;
        const scaleCurve = Curves.easeOutBack;

        var slideAnimation = Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: slideCurve)).animate(animation);

        var scaleAnimation = Tween<double>(
          begin: 0.9,
          end: 1.0,
        ).chain(CurveTween(curve: scaleCurve)).animate(animation);

        return SlideTransition(
          position: slideAnimation,
          child: ScaleTransition(scale: scaleAnimation, child: child),
        );
      },
      transitionDuration: const Duration(milliseconds: 450),
      reverseTransitionDuration: const Duration(milliseconds: 300),
    );
  }
}
