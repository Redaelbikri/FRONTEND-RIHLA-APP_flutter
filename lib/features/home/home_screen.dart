import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/nav/app_router.dart';
import '../../core/theme/rihla_colors.dart';
import '../../core/ui/glass.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final searchCtrl = TextEditingController();

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
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
                  Colors.black.withValues(alpha: 0.22),
                  Colors.black.withValues(alpha: 0.10),
                  Colors.black.withValues(alpha: 0.78),
                ],
              ),
            ),
          ),

          Positioned(
            top: -90,
            left: -70,
            child: _BlurBlob(size: 340, color: RihlaColors.accent.withValues(alpha: 0.12)),
          ),
          Positioned(
            bottom: -140,
            right: -90,
            child: _BlurBlob(size: 460, color: RihlaColors.primary.withValues(alpha: 0.12)),
          ),

          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Glass(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              borderRadius: BorderRadius.circular(22),
                              opacity: 0.34,
                              blur: 18,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 34,
                                    height: 34,
                                    decoration: BoxDecoration(
                                      gradient: RihlaColors.premiumGradient,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: RihlaColors.shadow,
                                          blurRadius: 14,
                                          offset: Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(Icons.travel_explore_rounded, color: Colors.white, size: 18),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'RIHLA',
                                    style: t.titleMedium?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                            ).animate().fadeIn(duration: 220.ms).slideX(begin: -0.06, end: 0),

                            const Spacer(),

                            InkWell(
                              onTap: () => Navigator.pushNamed(context, Routes.notifications),
                              borderRadius: BorderRadius.circular(18),
                              child: Glass(
                                padding: const EdgeInsets.all(10),
                                borderRadius: BorderRadius.circular(18),
                                opacity: 0.30,
                                blur: 18,
                                child: Stack(
                                  children: [
                                    const Icon(Icons.notifications_rounded, color: Colors.white, size: 20),
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFFFFD58A),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ).animate().fadeIn(duration: 220.ms).slideX(begin: 0.06, end: 0),

                            const SizedBox(width: 10),


                            InkWell(
                              onTap: () => Navigator.pushNamed(context, Routes.profile),
                              borderRadius: BorderRadius.circular(18),
                              child: Glass(
                                padding: const EdgeInsets.all(10),
                                borderRadius: BorderRadius.circular(18),
                                opacity: 0.30,
                                blur: 18,
                                child: const Icon(Icons.person_rounded, color: Colors.white, size: 20),
                              ),
                            ).animate().fadeIn(duration: 220.ms).slideX(begin: 0.06, end: 0),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Text(
                          'Where to next?',
                          style: t.headlineLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            height: 1.05,
                            letterSpacing: -0.6,
                          ),
                        ).animate().fadeIn(delay: 40.ms, duration: 260.ms).slideY(begin: 0.06, end: 0),

                        const SizedBox(height: 8),

                        Text(
                          'Plan trips, book tickets, and discover events in Morocco — all in one premium flow.',
                          style: t.bodyLarge?.copyWith(
                            color: Colors.white.withValues(alpha: 0.84),
                            fontWeight: FontWeight.w600,
                            height: 1.25,
                          ),
                        ).animate().fadeIn(delay: 90.ms, duration: 260.ms).slideY(begin: 0.06, end: 0),

                        const SizedBox(height: 16),

                        Glass(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          borderRadius: BorderRadius.circular(26),
                          opacity: 0.40,
                          blur: 18,
                          child: Row(
                            children: [
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
                                ),
                                child: const Icon(Icons.search_rounded, color: Colors.white),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: searchCtrl,
                                  style: t.titleSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Search destinations, events, hotels...',
                                    hintStyle: t.titleSmall?.copyWith(
                                      color: Colors.white.withValues(alpha: 0.60),
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Search is UI-only')),
                                  );
                                },
                                borderRadius: BorderRadius.circular(18),
                                child: Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    gradient: RihlaColors.premiumGradient,
                                    borderRadius: BorderRadius.circular(18),
                                    boxShadow: const [
                                      BoxShadow(color: RihlaColors.shadow, blurRadius: 16, offset: Offset(0, 10)),
                                    ],
                                  ),
                                  child: const Icon(Icons.arrow_forward_rounded, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(delay: 140.ms, duration: 260.ms).slideY(begin: 0.06, end: 0),

                        const SizedBox(height: 18),


                        Row(
                          children: [
                            Expanded(
                              child: _QuickAction(
                                title: 'Plan Trip',
                                subtitle: 'AI itinerary + budget',
                                icon: Icons.map_rounded,
                                onTap: () => Navigator.pushNamed(context, Routes.trips),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _QuickAction(
                                title: 'Transport',
                                subtitle: 'Train • Bus • Flight',
                                icon: Icons.confirmation_number_rounded,
                                onTap: () => Navigator.pushNamed(context, Routes.bookingHub),
                              ),
                            ),
                          ],
                        ).animate().fadeIn(delay: 180.ms, duration: 260.ms).slideY(begin: 0.06, end: 0),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Expanded(
                              child: _QuickAction(
                                title: 'Hotels',
                                subtitle: 'Pick dates & book',
                                icon: Icons.hotel_rounded,
                                onTap: () => Navigator.pushNamed(context, Routes.hotels),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _QuickAction(
                                title: 'Events',
                                subtitle: 'Festivals • Sports',
                                icon: Icons.local_activity_rounded,
                                onTap: () => Navigator.pushNamed(context, Routes.events),
                              ),
                            ),
                          ],
                        ).animate().fadeIn(delay: 220.ms, duration: 260.ms).slideY(begin: 0.06, end: 0),

                        const SizedBox(height: 18),

                        _SectionHeader(
                          title: 'Recommended for you',
                          action: 'See all',
                          onTap: () {},
                        ),

                        const SizedBox(height: 10),

                        SizedBox(
                          height: 168,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (_, i) => _FeaturedCard(
                              title: _featured[i].title,
                              subtitle: _featured[i].subtitle,
                              image: _featured[i].image,
                              tag: _featured[i].tag,
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Open: ${_featured[i].title} (UI only)')),
                                );
                              },
                            ),
                            separatorBuilder: (_, __) => const SizedBox(width: 12),
                            itemCount: _featured.length,
                          ),
                        ).animate().fadeIn(delay: 240.ms, duration: 260.ms).slideY(begin: 0.06, end: 0),

                        const SizedBox(height: 18),

                        _SectionHeader(
                          title: 'Top reviews',
                          action: 'Trusted',
                          onTap: () {},
                        ),

                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 110),
                  sliver: SliverList.separated(
                    itemBuilder: (_, i) =>
                        _ReviewCard(r: _reviews[i]).animate().fadeIn(duration: 220.ms).slideY(begin: 0.05, end: 0),
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemCount: _reviews.length,
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

class _QuickAction extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickAction({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: Glass(
        padding: const EdgeInsets.all(14),
        borderRadius: BorderRadius.circular(28),
        opacity: 0.38,
        blur: 18,
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: RihlaColors.premiumGradient,
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(color: RihlaColors.shadow, blurRadius: 16, offset: Offset(0, 10)),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: t.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: t.labelLarge?.copyWith(color: Colors.white.withValues(alpha: 0.78), fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String action;
  final VoidCallback onTap;

  const _SectionHeader({required this.title, required this.action, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Row(
      children: [
        Text(
          title,
          style: t.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
        ),
        const Spacer(),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            ),
            child: Text(
              action,
              style: t.labelLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
            ),
          ),
        ),
      ],
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;
  final String tag;
  final VoidCallback onTap;

  const _FeaturedCard({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.tag,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(26),
      child: SizedBox(
        width: 240,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(image, fit: BoxFit.cover),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.15),
                      Colors.black.withValues(alpha: 0.60),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
                      ),
                      child: Text(
                        tag,
                        style: t.labelLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      title,
                      style: t.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900, height: 1.05),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: t.bodyLarge?.copyWith(color: Colors.white.withValues(alpha: 0.84), fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final _Review r;
  const _ReviewCard({required this.r});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Glass(
      padding: const EdgeInsets.all(14),
      borderRadius: BorderRadius.circular(26),
      opacity: 0.36,
      blur: 18,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            ),
            child: const Icon(Icons.person_rounded, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        r.name,
                        style: t.labelLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                      ),
                    ),
                    const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      r.rating.toStringAsFixed(1),
                      style: t.labelLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      r.timeAgo,
                      style: t.labelLarge?.copyWith(color: Colors.white.withValues(alpha: 0.70), fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  r.comment,
                  style: t.bodyLarge?.copyWith(color: Colors.white.withValues(alpha: 0.84), fontWeight: FontWeight.w600, height: 1.25),
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
      imageFilter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}

/* ------------------ Mock data (UI only) ------------------ */

class _Featured {
  final String title;
  final String subtitle;
  final String image;
  final String tag;

  const _Featured({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.tag,
  });
}

const _featured = <_Featured>[
  _Featured(
    title: 'Marrakech',
    subtitle: 'Riads, food & culture',
    image: 'assets/destinations/marrakech.jpg',
    tag: 'Trending',
  ),
  _Featured(
    title: 'Chefchaouen',
    subtitle: 'Blue streets & calm',
    image: 'assets/destinations/chefchaouen.jpg',
    tag: 'Relax',
  ),
  _Featured(
    title: 'Essaouira',
    subtitle: 'Ocean breeze & music',
    image: 'assets/destinations/essaouira.jpg',
    tag: 'Weekend',
  ),
];

class _Review {
  final String name;
  final double rating;
  final String comment;
  final String timeAgo;

  const _Review({required this.name, required this.rating, required this.comment, required this.timeAgo});
}

const _reviews = <_Review>[
  _Review(
    name: 'Yassine',
    rating: 4.9,
    comment: 'The itinerary flow feels premium. Everything is organized and clean.',
    timeAgo: '1d ago',
  ),
  _Review(
    name: 'Salma',
    rating: 4.7,
    comment: 'Loved the events discovery. Great suggestions and beautiful UI.',
    timeAgo: '3d ago',
  ),
  _Review(
    name: 'Omar',
    rating: 4.8,
    comment: 'Transport search is smooth. The cards look like a real store app.',
    timeAgo: '1w ago',
  ),
];
