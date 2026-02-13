import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/nav/app_router.dart';
import '../../core/theme/rihla_colors.dart';
import '../../core/ui/glass.dart';
import '../../core/ui/primary_button.dart';

class BookingHubScreen extends StatelessWidget {
  const BookingHubScreen({super.key});

  void _go(BuildContext context, String route) => Navigator.pushNamed(context, route);

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
                  Colors.black.withValues(alpha: 0.10),
                  Colors.black.withValues(alpha: 0.05),
                  Colors.black.withValues(alpha: 0.26),
                  Colors.black.withValues(alpha: 0.46),
                ],
              ),
            ),
          ),

          Positioned(
            top: -70,
            left: -40,
            child: _BlurBlob(size: 260, color: RihlaColors.accent.withValues(alpha: 0.14)),
          ),
          Positioned(
            bottom: -90,
            right: -50,
            child: _BlurBlob(size: 300, color: RihlaColors.primary.withValues(alpha: 0.13)),
          ),

          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 14, 18, 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       
                        Glass(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          borderRadius: BorderRadius.circular(18),
                          opacity: 0.30,
                          blur: 18,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.confirmation_number_rounded, color: Colors.white, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'Tickets & Booking',
                                style: t.labelLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        Text(
                          'Book transport\n& hotels in one place',
                          style: t.displaySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            height: 1.02,
                            letterSpacing: -0.6,
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 240.ms)
                            .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),

                        const SizedBox(height: 10),

                        Text(
                          'Choose what you want to book — transport or hotels — then browse curated results.',
                          style: t.bodyLarge?.copyWith(
                            color: Colors.white.withValues(alpha: 0.86),
                            fontWeight: FontWeight.w600,
                            height: 1.25,
                          ),
                        )
                            .animate()
                            .fadeIn(delay: 80.ms, duration: 320.ms)
                            .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),

                        const SizedBox(height: 16),


                        Row(
                          children: [
                            Expanded(
                              child: PrimaryButton(
                                text: 'Book Transport',
                                icon: Icons.directions_transit_rounded,
                                onTap: () => _go(context, Routes.transport),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: PrimaryButton(
                                text: 'Book Hotel',
                                icon: Icons.hotel_rounded,
                                isSecondary: true,
                                onTap: () => _go(context, Routes.hotels),
                              ),
                            ),
                          ],
                        )
                            .animate()
                            .fadeIn(delay: 140.ms, duration: 320.ms)
                            .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),

                        const SizedBox(height: 18),


                        _SectionHeader(
                          title: 'Transport',
                          subtitle: 'Choose a mode to book',
                          icon: Icons.directions_transit_rounded,
                        ),
                        const SizedBox(height: 12),

                        _ModeGrid(
                          onTapMode: (_) => _go(context, Routes.transport),
                        )
                            .animate()
                            .fadeIn(delay: 210.ms, duration: 320.ms)
                            .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),

                        const SizedBox(height: 18),

                        _SectionHeader(
                          title: 'Hotels',
                          subtitle: 'Top stays with ratings',
                          icon: Icons.hotel_rounded,
                          actionText: 'Open',
                          onAction: () => _go(context, Routes.hotels),
                        ),
                        const SizedBox(height: 12),

                        const _HotelCarousel()
                            .animate()
                            .fadeIn(delay: 270.ms, duration: 320.ms)
                            .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),

                        const SizedBox(height: 18),


                        _SectionHeader(
                          title: 'Reviews',
                          subtitle: 'What travelers say',
                          icon: Icons.star_rounded,
                        ),
                        const SizedBox(height: 12),

                        const _Reviews()
                            .animate()
                            .fadeIn(delay: 340.ms, duration: 320.ms)
                            .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),


                      ],
                    ),
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


class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String? actionText;
  final VoidCallback? onAction;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: t.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
              ),
              Text(
                subtitle,
                style: t.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.78),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        if (actionText != null && onAction != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              backgroundColor: Colors.white.withValues(alpha: 0.10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Text(
              actionText!,
              style: t.labelLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
          ),
      ],
    );
  }
}

class _ModeGrid extends StatelessWidget {
  final void Function(String mode) onTapMode;
  const _ModeGrid({required this.onTapMode});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    final items = const [
      ('Flight', Icons.flight_rounded),
      ('Car', Icons.directions_car_rounded),
      ('Train', Icons.train_rounded),
      ('Bus', Icons.directions_bus_rounded),
    ];

    return GridView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.1,
      ),
      itemBuilder: (_, i) {
        return InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => onTapMode(items[i].$1),
          child: Glass(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            borderRadius: BorderRadius.circular(24),
            opacity: 0.30,
            blur: 18,
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: RihlaColors.premiumGradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(items[i].$2, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    items[i].$1,
                    style: t.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: Colors.white.withValues(alpha: 0.7)),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HotelCarousel extends StatelessWidget {
  const _HotelCarousel();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    final hotels = const [
      ('Riad Noir', 'Marrakech', 4.8, 'From 620 MAD'),
      ('Atlas View', 'Ifrane', 4.7, 'From 540 MAD'),
      ('Essaouira Bay', 'Essaouira', 4.6, 'From 480 MAD'),
    ];

    return SizedBox(
      height: 128,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: hotels.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final h = hotels[i];
          return Glass(
            padding: const EdgeInsets.all(14),
            borderRadius: BorderRadius.circular(26),
            opacity: 0.32,
            blur: 18,
            child: SizedBox(
              width: 240,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          h.$1,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: t.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.star_rounded, color: Colors.white.withValues(alpha: 0.92), size: 16),
                            const SizedBox(width: 6),
                            Text(
                              h.$3.toStringAsFixed(1),
                              style: t.labelLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    h.$2,
                    style: t.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.80),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    h.$4,
                    style: t.titleMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.92),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Reviews extends StatelessWidget {
  const _Reviews();

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    const items = [
      ('Yasmine', 'Transport comparison is super fast.', 5),
      ('Omar', 'Hotel list feels premium and clear.', 5),
      ('Sara', 'One app for everything in Morocco.', 4),
    ];

    return Column(
      children: items.map((e) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Glass(
            padding: const EdgeInsets.all(14),
            borderRadius: BorderRadius.circular(26),
            opacity: 0.28,
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
                  child: const Icon(Icons.person_rounded, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              e.$1,
                              style: t.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                            ),
                          ),
                          Row(
                            children: List.generate(
                              e.$3,
                                  (_) => Icon(Icons.star_rounded, color: Colors.white.withValues(alpha: 0.9), size: 16),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        e.$2,
                        style: t.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.82),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
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
