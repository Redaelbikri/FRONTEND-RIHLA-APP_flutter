import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/rihla_colors.dart';
import '../../../core/ui/glass.dart';
import '../../../core/ui/primary_button.dart';
import 'transport_models.dart';
import '../payment/fake_stripe_payment_screen.dart';


class TransportBookingDetailsScreen extends StatefulWidget {
  final TransportResult result;
  const TransportBookingDetailsScreen({super.key, required this.result});

  @override
  State<TransportBookingDetailsScreen> createState() => _TransportBookingDetailsScreenState();
}

class _TransportBookingDetailsScreenState extends State<TransportBookingDetailsScreen> {
  int passengers = 1;
  bool baggage = false;

  String cabin = 'Standard';
  final phoneCtrl = TextEditingController();
  final noteCtrl = TextEditingController();

  @override
  void dispose() {
    phoneCtrl.dispose();
    noteCtrl.dispose();
    super.dispose();
  }

  int get total => widget.result.priceMad * passengers;

  void _goPay() {
    if (phoneCtrl.text
        .trim()
        .isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a phone number.')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            FakeStripePaymentScreen(
              merchantName: 'RIHLA Pay',
              // ✅ obligatoire
              title: 'Transport payment',
              amountMad: total.toDouble(),
              // ✅ int -> double
              subtitle:
              '${widget.result.brand} • ${widget.result.fromStation} → ${widget
                  .result.toStation}',
              meta: '$passengers passenger(s) • $cabin${baggage
                  ? ' • Baggage'
                  : ''}',
            ),
      ),
    );
  }

    @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final r = widget.result;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/backgrounds/transport_bg.png', fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.28),
                  Colors.black.withValues(alpha: 0.10),
                  Colors.black.withValues(alpha: 0.70),
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
            child: _BlurBlob(size: 320, color: RihlaColors.primary.withValues(alpha: 0.13)),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(18),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
                          ),
                          child: const Icon(Icons.chevron_left_rounded, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Glass(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          borderRadius: BorderRadius.circular(22),
                          opacity: 0.36,
                          blur: 18,
                          child: Row(
                            children: [
                              const Icon(Icons.confirmation_number_rounded, color: Colors.white, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Booking details',
                                  style: t.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
                                ),
                                child: Text(
                                  '$total MAD',
                                  style: t.labelLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Glass(
                          padding: const EdgeInsets.all(16),
                          borderRadius: BorderRadius.circular(28),
                          opacity: 0.40,
                          blur: 20,
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  gradient: RihlaColors.premiumGradient,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Icon(r.icon, color: Colors.white, size: 24),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      r.brand,
                                      style: t.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${r.fromStation} → ${r.toStation}',
                                      style: t.bodyLarge?.copyWith(
                                        color: Colors.white.withValues(alpha: 0.84),
                                        fontWeight: FontWeight.w700,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${r.operatorName} • ${r.meta}',
                                      style: t.labelLarge?.copyWith(
                                        color: Colors.white.withValues(alpha: 0.72),
                                        fontWeight: FontWeight.w700,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ).animate().fadeIn(duration: 220.ms).slideY(begin: 0.06, end: 0),

                        const SizedBox(height: 14),

                        _SectionTitle(icon: Icons.people_rounded, title: 'Passengers'),
                        const SizedBox(height: 10),

                        Glass(
                          padding: const EdgeInsets.all(14),
                          borderRadius: BorderRadius.circular(26),
                          opacity: 0.36,
                          blur: 18,
                          child: Row(
                            children: [
                              Text('How many?', style: t.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w900)),
                              const Spacer(),
                              _Counter(
                                value: passengers,
                                onMinus: () => setState(() => passengers = (passengers <= 1) ? 1 : passengers - 1),
                                onPlus: () => setState(() => passengers = passengers + 1),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 14),

                        _SectionTitle(icon: Icons.workspace_premium_rounded, title: 'Cabin'),
                        const SizedBox(height: 10),

                        Glass(
                          padding: const EdgeInsets.all(14),
                          borderRadius: BorderRadius.circular(26),
                          opacity: 0.36,
                          blur: 18,
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: ['Standard', 'Comfort', 'Premium'].map((c) {
                              final on = cabin == c;
                              return InkWell(
                                onTap: () => setState(() => cabin = c),
                                borderRadius: BorderRadius.circular(999),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: on ? Colors.white.withValues(alpha: 0.20) : Colors.white.withValues(alpha: 0.10),
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: on ? 0.22 : 0.14),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        on ? Icons.check_circle_rounded : Icons.circle_outlined,
                                        color: Colors.white.withValues(alpha: 0.92),
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        c,
                                        style: t.labelLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),

                        const SizedBox(height: 14),

                        _SectionTitle(icon: Icons.luggage_rounded, title: 'Extras'),
                        const SizedBox(height: 10),

                        Glass(
                          padding: const EdgeInsets.all(14),
                          borderRadius: BorderRadius.circular(26),
                          opacity: 0.36,
                          blur: 18,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Add baggage',
                                  style: t.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                                ),
                              ),
                              Switch(
                                value: baggage,
                                onChanged: (v) => setState(() => baggage = v),
                                activeColor: Colors.white,
                                activeTrackColor: RihlaColors.primary.withValues(alpha: 0.85),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 14),

                        _SectionTitle(icon: Icons.phone_rounded, title: 'Contact'),
                        const SizedBox(height: 10),

                        Glass(
                          padding: const EdgeInsets.all(14),
                          borderRadius: BorderRadius.circular(26),
                          opacity: 0.36,
                          blur: 18,
                          child: Column(
                            children: [
                              _Input(
                                controller: phoneCtrl,
                                hint: 'Phone number',
                                icon: Icons.call_rounded,
                                keyboard: TextInputType.phone,
                              ),
                              const SizedBox(height: 10),
                              _Input(
                                controller: noteCtrl,
                                hint: 'Note (optional)',
                                icon: Icons.edit_note_rounded,
                                keyboard: TextInputType.text,
                                maxLines: 3,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom fixed CTA
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.85),
                        Colors.black.withValues(alpha: 0.00),
                      ],
                    ),
                  ),
                  child: PrimaryButton(
                    text: 'Validate booking',
                    icon: Icons.verified_rounded,
                    onTap: _goPay,
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

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SectionTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Row(
      children: [
        Icon(icon, color: Colors.white.withValues(alpha: 0.90), size: 18),
        const SizedBox(width: 8),
        Text(title, style: t.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900)),
      ],
    );
  }
}

class _Counter extends StatelessWidget {
  final int value;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  const _Counter({required this.value, required this.onMinus, required this.onPlus});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    Widget btn(IconData i, VoidCallback tap) => InkWell(
      onTap: tap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
        ),
        child: Icon(i, color: Colors.white, size: 18),
      ),
    );

    return Row(
      children: [
        btn(Icons.remove_rounded, onMinus),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
          ),
          child: Text('$value', style: t.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w900)),
        ),
        const SizedBox(width: 10),
        btn(Icons.add_rounded, onPlus),
      ],
    );
  }
}

class _Input extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType keyboard;
  final int maxLines;

  const _Input({
    required this.controller,
    required this.hint,
    required this.icon,
    required this.keyboard,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Row(
        crossAxisAlignment: maxLines > 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white.withValues(alpha: 0.86), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboard,
              maxLines: maxLines,
              style: t.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w800),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: t.titleMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.45),
                  fontWeight: FontWeight.w800,
                ),
                isDense: true,
              ),
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
