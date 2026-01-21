import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/rihla_colors.dart';
import '../../../core/ui/glass.dart';

import '../transport/transport_mode.dart';
import '../transport/transport_screen.dart';
import '../hotels/hotels_screen.dart';

class TicketsScreen extends StatelessWidget {
  const TicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [

          Image.asset('assets/backgrounds/tickets_bg.jpg', fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.30),
                  Colors.black.withValues(alpha: 0.10),
                  Colors.black.withValues(alpha: 0.72),
                ],
              ),
            ),
          ),


          Positioned(
            top: -90,
            left: -70,
            child: _BlurBlob(size: 320, color: RihlaColors.accent.withValues(alpha: 0.12)),
          ),
          Positioned(
            bottom: -130,
            right: -90,
            child: _BlurBlob(size: 420, color: RihlaColors.primary.withValues(alpha: 0.12)),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Glass(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    borderRadius: BorderRadius.circular(22),
                    opacity: 0.34,
                    blur: 18,
                    child: Row(
                      children: [
                        const Icon(Icons.confirmation_number_rounded, color: Colors.white, size: 18),
                        const SizedBox(width: 10),
                        Text(
                          'Tickets',
                          style: t.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Book in one place',
                          style: t.labelLarge?.copyWith(
                            color: Colors.white.withValues(alpha: 0.78),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 260.ms).slideY(begin: 0.08, end: 0),

                  const SizedBox(height: 14),

                  Text(
                    'Choose what you want\nto book today',
                    style: t.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      height: 1.05,
                    ),
                  ).animate().fadeIn(delay: 60.ms, duration: 320.ms).slideY(begin: 0.06, end: 0),

                  const SizedBox(height: 8),

                  Text(
                    'Transport (train, bus, flight, car) or Hotels.\nEverything stays inside RIHLA.',
                    style: t.bodyLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.84),
                      fontWeight: FontWeight.w600,
                      height: 1.25,
                    ),
                  ).animate().fadeIn(delay: 120.ms, duration: 320.ms).slideY(begin: 0.06, end: 0),

                  const SizedBox(height: 18),


                  _TicketCard(
                    title: 'Transport',
                    subtitle: 'Compare routes and prices\nTrain • Bus • Flight • Car',
                    icon: Icons.travel_explore_rounded,
                    gradient: RihlaColors.premiumGradient,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TransportScreen(initialMode: TransportMode.train),
                      ),
                    ),
                  ).animate().fadeIn(delay: 160.ms, duration: 320.ms).slideY(begin: 0.08, end: 0),

                  const SizedBox(height: 12),

                  _TicketCard(
                    title: 'Hotels',
                    subtitle: 'Pick dates and discover stays\nRiads • Resorts • City hotels',
                    icon: Icons.hotel_rounded,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF1F6E5C), Color(0xFF0F3D33)],
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const HotelsScreen()),
                    ),
                  ).animate().fadeIn(delay: 220.ms, duration: 320.ms).slideY(begin: 0.08, end: 0),

                  const SizedBox(height: 16),


                  Glass(
                    padding: const EdgeInsets.all(14),
                    borderRadius: BorderRadius.circular(26),
                    opacity: 0.30,
                    blur: 18,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quick transport',
                          style: t.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _QuickMode(
                              icon: Icons.train_rounded,
                              label: 'Train',
                              onTap: () => _openTransport(context, TransportMode.train),
                            ),
                            const SizedBox(width: 10),
                            _QuickMode(
                              icon: Icons.directions_bus_rounded,
                              label: 'Bus',
                              onTap: () => _openTransport(context, TransportMode.bus),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            _QuickMode(
                              icon: Icons.flight_rounded,
                              label: 'Flight',
                              onTap: () => _openTransport(context, TransportMode.flight),
                            ),
                            const SizedBox(width: 10),
                            _QuickMode(
                              icon: Icons.directions_car_rounded,
                              label: 'Car',
                              onTap: () => _openTransport(context, TransportMode.car),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 280.ms, duration: 320.ms).slideY(begin: 0.08, end: 0),

                  const Spacer(),

                  Center(
                    child: Text(
                      'UI prototype — booking is visual only.',
                      style: t.labelLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.70),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ).animate().fadeIn(delay: 340.ms, duration: 320.ms),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void _openTransport(BuildContext context, TransportMode mode) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TransportScreen(initialMode: mode)),
    );
  }
}

class _TicketCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _TicketCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(30),
          boxShadow: const [
            BoxShadow(color: RihlaColors.shadow, blurRadius: 18, offset: Offset(0, 12)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
              ),
              child: Icon(icon, color: Colors.white, size: 26),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: t.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: t.bodyLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.88),
                      fontWeight: FontWeight.w600,
                      height: 1.15,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_rounded, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class _QuickMode extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickMode({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Glass(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          borderRadius: BorderRadius.circular(22),
          opacity: 0.26,
          blur: 18,
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: t.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.white, size: 18),
            ],
          ),
        ),
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
