import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/rihla_colors.dart';
import '../../core/ui/glass.dart';
import '../../core/ui/primary_button.dart';
import '../../data/mock.dart';

class EventDetailsScreen extends StatelessWidget {
  final dynamic event;

  const EventDetailsScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    final MockEvent e = event is MockEvent
        ? event as MockEvent
        : const MockEvent(
      title: 'Event',
      category: 'Category',
      image: 'assets/backgrounds/home_bg.jpg',
      location: 'City',
      dateLabel: 'Date',
      description: 'Description unavailable.',
    );

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [

          Image.asset(e.image, fit: BoxFit.cover),


          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.15),
                  Colors.black.withValues(alpha: 0.10),
                  Colors.black.withValues(alpha: 0.68),
                ],
              ),
            ),
          ),


          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
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
                  const Spacer(),
                  Glass(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    borderRadius: BorderRadius.circular(18),
                    opacity: 0.30,
                    blur: 18,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.local_activity_rounded, color: Colors.white, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Details',
                          style: t.labelLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),


          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                child: Glass(
                  padding: const EdgeInsets.all(18),
                  borderRadius: BorderRadius.circular(30),
                  opacity: 0.42,
                  blur: 20,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
                        ),
                        child: Text(
                          e.category,
                          style: t.labelLarge?.copyWith(
                            color: Colors.white.withValues(alpha: 0.92),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        e.title,
                        style: t.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),

                      const SizedBox(height: 8),

                      _MetaRow(
                        icon: Icons.place_rounded,
                        text: e.location,
                      ),
                      const SizedBox(height: 6),
                      _MetaRow(
                        icon: Icons.schedule_rounded,
                        text: e.dateLabel,
                      ),

                      const SizedBox(height: 12),

                      Text(
                        e.description,
                        style: t.bodyLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.86),
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 14),

                      Row(
                        children: [
                          Expanded(
                            child: PrimaryButton(
                              text: 'Save to itinerary',
                              icon: Icons.bookmark_add_rounded,
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Saved (UI only).')),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 60,
                            child: PrimaryButton(
                              text: '',
                              icon: Icons.share_rounded,
                              expanded: true,
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Share (UI only).')),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(duration: 260.ms)
                    .slideY(begin: 0.12, end: 0, curve: Curves.easeOutCubic),
              ),
            ),
          ),


          Positioned(
            top: 90,
            right: -70,
            child: _BlurBlob(size: 240, color: RihlaColors.accent.withValues(alpha: 0.14)),
          ),
        ],
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MetaRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(icon, color: Colors.white.withValues(alpha: 0.90), size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: t.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.86),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
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
