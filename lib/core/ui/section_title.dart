import 'package:flutter/material.dart';
import '../theme/rihla_colors.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onAction;

  const SectionTitle({
    super.key,
    required this.title,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Row(
      children: [
        Text(title, style: t.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
        const Spacer(),
        if (actionText != null)
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onAction,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Text(
                actionText!,
                style: t.labelLarge?.copyWith(
                  color: RihlaColors.primaryDark,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
