import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/rihla_colors.dart';
import '../../../core/ui/glass.dart';
import 'transport_models.dart';

class TransportResultCard extends StatelessWidget {
  final TransportResult r;
  final VoidCallback onSelect;

  const TransportResultCard({super.key, required this.r, required this.onSelect});

  String _fmt(TimeOfDay t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String _dur(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    if (h <= 0) return '${m}m';
    return '${h}h ${m}m';
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Glass(
      padding: const EdgeInsets.all(14),
      borderRadius: BorderRadius.circular(26),
      opacity: 0.42,
      blur: 18,
      child: Column(
        children: [
          Row(
            children: [

              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
                ),
                child: Icon(r.icon, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          r.brand,
                          style: t.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (r.badge.isNotEmpty) _Badge(text: r.badge),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${r.operatorName} • ${r.meta}',
                      style: t.labelLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.82),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${r.priceMad}',
                    style: t.titleLarge?.copyWith(
                      color: Colors.lightBlue.shade50,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    'MAD',
                    style: t.labelLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.80),
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.0,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _TimePill(
                  title: _fmt(r.depart),
                  sub: r.fromStation,
                  icon: Icons.trip_origin_rounded,
                ),
              ),
              const SizedBox(width: 10),
              _MidPill(
                text: _dur(r.duration),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _TimePill(
                  title: _fmt(r.arrive),
                  sub: r.toStation,
                  icon: Icons.location_on_rounded,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              if (r.perks.isNotEmpty) ...[
                Icon(Icons.wifi_rounded, color: Colors.white.withValues(alpha: 0.70), size: 16),
                const SizedBox(width: 6),
                Text(
                  r.perks.first,
                  style: t.labelLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.76),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
              const Spacer(),
              TextButton(
                onPressed: onSelect,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  backgroundColor: Colors.white.withValues(alpha: 0.12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Select', style: t.labelLarge?.copyWith(fontWeight: FontWeight.w900)),
                    const SizedBox(width: 6),
                    const Icon(Icons.arrow_forward_rounded, size: 18),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 260.ms).slideY(begin: 0.06, end: 0);
  }
}

class _Badge extends StatelessWidget {
  final String text;
  const _Badge({required this.text});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    Color bg;
    if (text.contains('FAST')) {
      bg = const Color(0xFF2ECC71);
    } else if (text.contains('ECON') || text.contains('CHEAP')) {
      bg = const Color(0xFFF39C12);
    } else {
      bg = RihlaColors.accent;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: Text(
        text,
        style: t.labelSmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class _TimePill extends StatelessWidget {
  final String title;
  final String sub;
  final IconData icon;

  const _TimePill({required this.title, required this.sub, required this.icon});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white.withValues(alpha: 0.70), size: 16),
              const SizedBox(width: 6),
              Text(
                title,
                style: t.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            sub,
            style: t.labelLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.72),
              fontWeight: FontWeight.w700,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _MidPill extends StatelessWidget {
  final String text;
  const _MidPill({required this.text});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: Text(
        text,
        style: t.labelLarge?.copyWith(
          color: Colors.white.withValues(alpha: 0.78),
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
