import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/rihla_colors.dart';
import '../../core/ui/glass.dart';
import '../../core/ui/primary_button.dart';

import '../../data/models/event_model.dart';
import '../../data/repositories/reservations_repository.dart';
import '../../data/api/reservations_api.dart';
import '../../data/services/api_client.dart';

import '../booking/payment/fake_stripe_payment_screen.dart';

class EventDetailsScreen extends StatefulWidget {
  final EventModel event;
  const EventDetailsScreen({super.key, required this.event});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  int _qty = 1;
  bool _loading = false;

  late final ReservationsRepository _reservations;

  EventModel get e => widget.event;

  @override
  void initState() {
    super.initState();
    _reservations = ReservationsRepository(ReservationsApi());
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _book() async {
    if (_loading) return;

    setState(() => _loading = true);
    try {
      final reservation = await _reservations.reserveEvent(
        eventId: e.id,
        quantity: _qty,
      );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => FakeStripePaymentScreen(
            merchantName: e.nom,
            title: 'Event tickets',
            subtitle: '${e.lieu} • $_qty ticket(s)',
            amountMad: (e.prix * _qty).toDouble(),
            meta: 'reservationId=${reservation.id}',
            reservationId: reservation.id,
          ),
        ),
      );
    } catch (err) {
      if (!mounted) return;
      final msg = err is ApiException ? err.message : 'Booking failed';
      _toast(msg);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final img = e.imageUrl.isNotEmpty ? e.imageUrl : 'assets/events/event_1.jpg';

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            img,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Image.asset(
              'assets/events/event_1.jpg',
              fit: BoxFit.cover,
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(color: Colors.black.withOpacity(0.35)),
          ),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const Spacer(),
                  ],
                ),
                const SizedBox(height: 10),
                Glass(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        e.nom,
                        style: t.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${e.categorie} • ${e.lieu}',
                        style: t.bodyMedium?.copyWith(color: Colors.white70),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        e.description,
                        style: t.bodyMedium?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Text('Tickets', style: t.bodyMedium?.copyWith(color: Colors.white70)),
                          const Spacer(),
                          IconButton(
                            onPressed: (_qty > 1 && !_loading) ? () => setState(() => _qty--) : null,
                            icon: const Icon(Icons.remove_circle_outline, color: Colors.white),
                          ),
                          Text('$_qty', style: t.titleMedium?.copyWith(color: Colors.white)),
                          IconButton(
                            onPressed: !_loading ? () => setState(() => _qty++) : null,
                            icon: const Icon(Icons.add_circle_outline, color: Colors.white),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // ✅ FIX: PrimaryButton API (text/icon/onTap) to match your project
                      Opacity(
                        opacity: _loading ? 0.75 : 1,
                        child: PrimaryButton(
                          text: _loading
                              ? 'Processing...'
                              : 'Book now • ${(e.prix * _qty).toStringAsFixed(0)} MAD',
                          icon: Icons.confirmation_number_rounded,
                          onTap: _loading ? null : _book,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // optional small hint (keeps UI style)
                      Text(
                        'Secure payment via backend reservation.',
                        style: t.labelMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.65),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 250.ms).slideY(begin: .06, end: 0),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
