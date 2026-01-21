import 'package:flutter/material.dart';

class RihlaTransitions {
  static PageRoute<T> fadeThrough<T>(Widget page, {Duration? duration}) {
    return PageRouteBuilder<T>(
      transitionDuration: duration ?? const Duration(milliseconds: 420),
      reverseTransitionDuration: duration ?? const Duration(milliseconds: 380),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, secondaryAnimation, child) {
        final fade = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        final scale = Tween<double>(begin: 0.98, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        );

        return FadeTransition(
          opacity: fade,
          child: ScaleTransition(scale: scale, child: child),
        );
      },
    );
  }

  static PageRoute<T> slideUp<T>(Widget page, {Duration? duration}) {
    return PageRouteBuilder<T>(
      transitionDuration: duration ?? const Duration(milliseconds: 450),
      reverseTransitionDuration: duration ?? const Duration(milliseconds: 380),
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        final offset = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
            .animate(curved);
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(position: offset, child: child),
        );
      },
    );
  }
}
