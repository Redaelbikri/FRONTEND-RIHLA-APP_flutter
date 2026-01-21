import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/rihla_colors.dart';
import '../../core/ui/glass.dart';
import '../../data/mock.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  IconData _iconFromKey(String key) {
    switch (key) {
      case 'check':
        return Icons.check_circle_rounded;
      case 'bell':
        return Icons.notifications_rounded;
      case 'spark':
        return Icons.auto_awesome_rounded;
      case 'user':
        return Icons.person_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/backgrounds/home_bg.jpg', fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.12),
                  Colors.black.withValues(alpha: 0.06),
                  Colors.black.withValues(alpha: 0.34),
                  Colors.black.withValues(alpha: 0.56),
                ],
              ),
            ),
          ),
          Positioned(
            top: -70,
            left: -40,
            child: _BlurBlob(size: 260, color: RihlaColors.accent.withValues(alpha: 0.14)),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                  child: Row(
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
                          ),
                          child: const Icon(Icons.chevron_left_rounded, color: Colors.white, size: 22),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Glass(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        borderRadius: BorderRadius.circular(18),
                        opacity: 0.30,
                        blur: 18,
                        child: Text(
                          'Notifications',
                          style: t.labelLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(18, 10, 18, 120),
                    itemCount: MockData.notifications.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      final n = MockData.notifications[i];
                      return Glass(
                        padding: const EdgeInsets.all(14),
                        borderRadius: BorderRadius.circular(26),
                        opacity: 0.34,
                        blur: 18,
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                gradient: RihlaColors.premiumGradient,
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Icon(_iconFromKey(n.iconKey), color: Colors.white, size: 22),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    n.title,
                                    style: t.titleMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    n.message,
                                    style: t.bodyMedium?.copyWith(
                                      color: Colors.white.withValues(alpha: 0.84),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              n.time,
                              style: t.labelMedium?.copyWith(
                                color: Colors.white.withValues(alpha: 0.70),
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      )
                          .animate()
                          .fadeIn(delay: (70 * i).ms, duration: 320.ms)
                          .slideY(begin: 0.06, end: 0, curve: Curves.easeOutCubic);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BlurBlob extends StatelessWidget {
  final double size;
  final Color color;

  const _BlurBlob({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 26, sigmaY: 26),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
