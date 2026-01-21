import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/nav/app_router.dart';
import '../../core/theme/rihla_colors.dart';
import '../../core/ui/chips_row.dart';
import '../../core/ui/glass.dart';
import '../../core/ui/section_title.dart';
import '../../data/mock.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  int _cat = 0;

  final _cats = const [
    'All',
    'Culture',
    'Food',
    'Music',
    'Art',
    'Nature',
    'Sport',
  ];

  List<MockEvent> _filtered() {
    if (_cat == 0) return MockData.events;
    final c = _cats[_cat];
    return MockData.events.where((e) => e.category == c).toList();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final events = _filtered();

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
                  Colors.black.withValues(alpha: 0.30),
                  Colors.black.withValues(alpha: 0.44),
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
                    padding: const EdgeInsets.fromLTRB(18, 14, 18, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Row(
                          children: [
                            Glass(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              borderRadius: BorderRadius.circular(18),
                              opacity: 0.34,
                              blur: 18,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.local_activity_rounded, color: Colors.white, size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Events',
                                    style: t.labelLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            _RoundIcon(
                              icon: Icons.tune_rounded,
                              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Filters (UI only)')),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        Text(
                          'Curated experiences',
                          style: t.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 260.ms)
                            .slideY(begin: 0.10, end: 0, curve: Curves.easeOutCubic),

                        const SizedBox(height: 6),

                        Text(
                          'Discover premium events, handpicked for culture and comfort.',
                          style: t.bodyLarge?.copyWith(
                            color: Colors.white.withValues(alpha: 0.86),
                            fontWeight: FontWeight.w600,
                          ),
                        )
                            .animate()
                            .fadeIn(delay: 120.ms, duration: 320.ms)
                            .slideY(begin: 0.10, end: 0, curve: Curves.easeOutCubic),

                        const SizedBox(height: 14),


                        ChipsRow(
                          items: _cats,
                          selectedIndex: _cat,
                          onChanged: (i) => setState(() => _cat = i),
                        )
                            .animate()
                            .fadeIn(delay: 200.ms, duration: 320.ms)
                            .slideY(begin: 0.10, end: 0, curve: Curves.easeOutCubic),

                        const SizedBox(height: 18),

                        SectionTitle(
                          title: 'For you',
                          actionText: 'Refresh',
                          onAction: () => ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Refresh (UI only)')),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 120),
                  sliver: SliverList.separated(
                    itemCount: events.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (_, i) {
                      final e = events[i];
                      return _EventCard(
                        event: e,
                        onTap: () => Navigator.pushNamed(
                          context,
                          Routes.eventDetails,
                          arguments: e,
                        ),
                      )
                          .animate()
                          .fadeIn(delay: (70 * i).ms, duration: 360.ms)
                          .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic);
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

class _EventCard extends StatelessWidget {
  final MockEvent event;
  final VoidCallback onTap;

  const _EventCard({required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return InkWell(
      borderRadius: BorderRadius.circular(26),
      onTap: onTap,
      child: Container(
        height: 168,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          boxShadow: const [
            BoxShadow(
              color: RihlaColors.shadow,
              blurRadius: 26,
              offset: Offset(0, 16),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(event.image, fit: BoxFit.cover),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.10),
                      Colors.black.withValues(alpha: 0.58),
                    ],
                  ),
                ),
              ),


              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.24)),
                  ),
                  child: Text(
                    event.category,
                    style: t.labelLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.92),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),


              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    event.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: t.titleLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${event.location} · ${event.dateLabel}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: t.bodyMedium?.copyWith(
                                      color: Colors.white.withValues(alpha: 0.86),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                gradient: RihlaColors.premiumGradient,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoundIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _RoundIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withValues(alpha: 0.20)),
        ),
        child: Icon(icon, color: Colors.white.withValues(alpha: 0.92), size: 20),
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
