import 'package:flutter/material.dart';
import '../theme/rihla_colors.dart';

class ChipsRow extends StatelessWidget {
  final List<String> items;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const ChipsRow({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 2),
        itemBuilder: (_, i) {
          final selected = i == selectedIndex;
          return GestureDetector(
            onTap: () => onChanged(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: selected
                    ? RihlaColors.primary.withValues(alpha: 0.14)
                    : Colors.white.withValues(alpha: 0.70),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: selected
                      ? RihlaColors.primary.withValues(alpha: 0.35)
                      : Colors.white.withValues(alpha: 0.6),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: RihlaColors.shadow,
                    blurRadius: 14,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  items[i],
                  style: t.labelLarge?.copyWith(
                    color: selected ? RihlaColors.primaryDark : RihlaColors.textSoft,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemCount: items.length,
      ),
    );
  }
}
