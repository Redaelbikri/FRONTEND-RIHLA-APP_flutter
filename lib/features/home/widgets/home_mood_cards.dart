import 'package:flutter/material.dart';
import '../../../core/ui/glass.dart';

class HomeMoodCards extends StatelessWidget {
  const HomeMoodCards({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    Widget card({
      required String title,
      required String subtitle,
      required IconData icon,
      required Color tint,
    }) {
      return SizedBox(
        width: 180,
        child: Glass(
          padding: const EdgeInsets.all(14),
          borderRadius: BorderRadius.circular(26),
          opacity: 0.44,
          blur: 18,
          child: Container(
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: tint.withValues(alpha: 0.22),
              border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
            ),
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: Colors.white, size: 28),
                const Spacer(),
                Text(
                  title,
                  style: t.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: t.labelLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.82),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 175,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          card(
            title: 'Adventure',
            subtitle: 'Mood',
            icon: Icons.explore_rounded,
            tint: const Color(0xFF1F6E5C),
          ),
          const SizedBox(width: 12),
          card(
            title: 'Relax',
            subtitle: 'Calm stays',
            icon: Icons.spa_rounded,
            tint: const Color(0xFFC9A227),
          ),
          const SizedBox(width: 12),
          card(
            title: 'Culture',
            subtitle: 'Local gems',
            icon: Icons.museum_rounded,
            tint: const Color(0xFF2C3E50),
          ),
        ],
      ),
    );
  }
}
