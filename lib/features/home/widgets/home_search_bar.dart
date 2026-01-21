import 'package:flutter/material.dart';
import '../../../core/ui/glass.dart';

class HomeSearchBar extends StatelessWidget {
  final String hint;
  final VoidCallback onTap;

  const HomeSearchBar({super.key, required this.hint, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Glass(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        borderRadius: BorderRadius.circular(22),
        opacity: 0.38,
        blur: 18,
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.82),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.search_rounded, color: Color(0xFF1F6E5C)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                hint,
                style: t.titleSmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.88),
                  fontWeight: FontWeight.w700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 10),
            Icon(Icons.tune_rounded, color: Colors.white.withValues(alpha: 0.9)),
          ],
        ),
      ),
    );
  }
}
