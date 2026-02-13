import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/ui/glass.dart';
import 'hotel_models.dart';

class HotelCard extends StatelessWidget {
  final Hotel h;
  final VoidCallback onTap;

  const HotelCard({super.key, required this.h, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(26),
      child: Glass(
        padding: const EdgeInsets.all(12),
        borderRadius: BorderRadius.circular(26),
        opacity: 0.42,
        blur: 18,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                h.image,
                width: 92,
                height: 92,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 92,
                  height: 92,
                  color: Colors.white.withValues(alpha: 0.12),
                  alignment: Alignment.center,
                  child: const Icon(Icons.hotel_rounded, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    h.name,
                    style: t.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    h.city,
                    style: t.labelLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.78),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: h.tags.take(3).map((tag) => _Tag(text: tag)).toList(),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        '${h.rating.toStringAsFixed(1)}',
                        style: t.labelLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '(${h.reviewsCount})',
                        style: t.labelLarge?.copyWith(color: Colors.white.withValues(alpha: 0.70), fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      Text(
                        '${h.priceMadPerNight} MAD',
                        style: t.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '/night',
                        style: t.labelLarge?.copyWith(color: Colors.white.withValues(alpha: 0.70), fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 6),
            const Icon(Icons.chevron_right_rounded, color: Colors.white),
          ],
        ),
      ).animate().fadeIn(duration: 240.ms).slideY(begin: 0.06, end: 0),
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  const _Tag({required this.text});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Text(
        text,
        style: t.labelMedium?.copyWith(
          color: Colors.white.withValues(alpha: 0.86),
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
