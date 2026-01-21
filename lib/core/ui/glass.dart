import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/rihla_colors.dart';

class Glass extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;
  final double blur;
  final double opacity;
  final Color? tint;
  final bool bordered;

  const Glass({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(14),
    this.borderRadius = const BorderRadius.all(Radius.circular(26)),
    this.blur = 14,
    this.opacity = 0.72,
    this.tint,
    this.bordered = true,
  });

  @override
  Widget build(BuildContext context) {
    final bg = (tint ?? Colors.white).withValues(alpha: opacity);

    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: borderRadius,
            border: bordered
                ? Border.all(
              color: RihlaColors.glassBorder,
              width: 1,
            )
                : null,
            boxShadow: const [
              BoxShadow(
                color: RihlaColors.shadow,
                blurRadius: 24,
                offset: Offset(0, 14),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
