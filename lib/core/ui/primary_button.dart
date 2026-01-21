import 'package:flutter/material.dart';
import '../theme/rihla_colors.dart';

class PrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool isSecondary;
  final bool expanded;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onTap,
    this.icon,
    this.isSecondary = false,
    this.expanded = true,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;
    final scale = _pressed ? 0.98 : 1.0;

    final bg = widget.isSecondary
        ? Colors.white.withValues(alpha: 0.80)
        : null;

    final gradient = widget.isSecondary ? null : RihlaColors.premiumGradient;

    final fg = widget.isSecondary ? RihlaColors.primaryDark : Colors.white;

    final child = AnimatedScale(
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOut,
      scale: scale,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: gradient,
          color: bg,
          borderRadius: BorderRadius.circular(18),
          border: widget.isSecondary
              ? Border.all(color: Colors.white.withValues(alpha: 0.6))
              : null,
          boxShadow: [
            if (!widget.isSecondary)
              const BoxShadow(
                color: RihlaColors.shadow,
                blurRadius: 22,
                offset: Offset(0, 12),
              ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, color: fg, size: 18),
                const SizedBox(width: 10),
              ],
              Text(
                widget.text,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: fg,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final tappable = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
      onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
      onTapUp: enabled
          ? (_) {
        setState(() => _pressed = false);
        widget.onTap?.call();
      }
          : null,
      child: Opacity(
        opacity: enabled ? 1 : 0.5,
        child: child,
      ),
    );

    return widget.expanded ? SizedBox(width: double.infinity, child: tappable) : tappable;
  }
}
