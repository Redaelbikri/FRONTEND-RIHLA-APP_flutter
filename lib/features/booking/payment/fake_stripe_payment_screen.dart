import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/rihla_colors.dart';
import '../../../core/ui/glass.dart';
import '../../../core/ui/primary_button.dart';

class FakeStripePaymentScreen extends StatefulWidget {
  final String? reservationId;
  final String merchantName;
  final String title;
  final double amountMad;
  final String subtitle;
  final String meta;

  const FakeStripePaymentScreen({
    super.key,
    this.reservationId,
    required this.merchantName,
    required this.title,
    required this.amountMad,
    required this.subtitle,
    required this.meta,
  });

  @override
  State<FakeStripePaymentScreen> createState() => _FakeStripePaymentScreenState();
}

class _FakeStripePaymentScreenState extends State<FakeStripePaymentScreen> {
  bool _paying = false;

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _cardCtrl = TextEditingController();
  final _expCtrl = TextEditingController();
  final _cvcCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _cardCtrl.dispose();
    _expCtrl.dispose();
    _cvcCtrl.dispose();
    super.dispose();
  }

  bool get _canPay {
    if (_paying) return false;

    final nameOk = _nameCtrl.text.trim().isNotEmpty;
    final email = _emailCtrl.text.trim();
    final emailOk = email.isNotEmpty && email.contains('@') && email.contains('.');
    final cardOk = _cardCtrl.text.replaceAll(' ', '').trim().length >= 12;
    final expOk = _expCtrl.text.trim().length >= 4; // MM/YY
    final cvcOk = _cvcCtrl.text.trim().length >= 3;
    return nameOk && emailOk && cardOk && expOk && cvcOk;
  }

  void _formatCard(String v) {
    final digits = v.replaceAll(RegExp(r'[^0-9]'), '');
    final buf = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i != 0 && i % 4 == 0) buf.write(' ');
      buf.write(digits[i]);
      if (buf.length >= 19) break; // 16 digits + 3 spaces
    }
    final formatted = buf.toString();
    if (formatted != _cardCtrl.text) {
      _cardCtrl.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  void _formatExp(String v) {
    final digits = v.replaceAll(RegExp(r'[^0-9]'), '');
    String out;
    if (digits.length <= 2) {
      out = digits;
    } else {
      final yy = digits.substring(2, digits.length.clamp(2, 4));
      out = '${digits.substring(0, 2)}/$yy';
    }
    if (out.length > 5) out = out.substring(0, 5);
    if (out != _expCtrl.text) {
      _expCtrl.value = TextEditingValue(
        text: out,
        selection: TextSelection.collapsed(offset: out.length),
      );
    }
  }

  Future<void> _payNow() async {
    if (!_canPay) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete valid card details.')),
      );
      return;
    }

    setState(() => _paying = true);

    // ✅ This screen is still "Fake Stripe" (no real Stripe).
    // But we return success + reservationId to previous screen to continue flow.
    await Future<void>.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;
    setState(() => _paying = false);

    await showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (_) => Center(
        child: Glass(
          padding: const EdgeInsets.all(18),
          borderRadius: BorderRadius.circular(26),
          opacity: 0.42,
          blur: 18,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: RihlaColors.premiumGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.check_rounded, color: Colors.white, size: 30),
              ),
              const SizedBox(height: 12),
              Text(
                'Payment confirmed',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Demo payment completed.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.82),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                text: 'Done',
                icon: Icons.check_circle_rounded,
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 220.ms).scale(begin: const Offset(0.98, 0.98)),
      ),
    );

    // ✅ Return success result to caller
    if (!mounted) return;
    Navigator.pop(
      context,
      {
        'paid': true,
        'reservationId': widget.reservationId,
        'amountMad': widget.amountMad,
        'email': _emailCtrl.text.trim(),
      },
    );
  }

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
                  Colors.black.withValues(alpha: 0.12),
                  Colors.black.withValues(alpha: 0.72),
                ],
              ),
            ),
          ),
          Positioned(
            top: -80,
            right: -60,
            child: _BlurBlob(size: 320, color: RihlaColors.accent.withValues(alpha: 0.12)),
          ),
          Positioned(
            bottom: -120,
            left: -80,
            child: _BlurBlob(size: 420, color: RihlaColors.primary.withValues(alpha: 0.12)),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: _paying ? null : () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(18),
                        child: Glass(
                          padding: const EdgeInsets.all(10),
                          borderRadius: BorderRadius.circular(18),
                          opacity: 0.28,
                          blur: 18,
                          child: const Icon(Icons.chevron_left_rounded, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Glass(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          borderRadius: BorderRadius.circular(22),
                          opacity: 0.34,
                          blur: 18,
                          child: Row(
                            children: [
                              const Icon(Icons.lock_rounded, color: Colors.white, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  widget.merchantName,
                                  style: t.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                  ),
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
                                  'Fake Stripe',
                                  style: t.labelLarge?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.92),
                                    fontWeight: FontWeight.w900,
                                  ),
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
                    padding: const EdgeInsets.fromLTRB(16, 6, 16, 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Glass(
                          padding: const EdgeInsets.all(16),
                          borderRadius: BorderRadius.circular(28),
                          opacity: 0.40,
                          blur: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.title,
                                style: t.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                widget.subtitle,
                                style: t.bodyLarge?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.86),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 10),
                              if (widget.meta.trim().isNotEmpty)
                                Text(
                                  widget.meta,
                                  style: t.labelLarge?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.78),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              const SizedBox(height: 14),
                              Container(height: 1, color: Colors.white.withValues(alpha: 0.12)),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Text(
                                    'Total',
                                    style: t.titleMedium?.copyWith(
                                      color: Colors.white.withValues(alpha: 0.90),
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${widget.amountMad.toStringAsFixed(0)} MAD',
                                    style: t.titleLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),

                              _InputGlass(
                                label: 'Cardholder name',
                                hint: 'Name on card',
                                icon: Icons.person_rounded,
                                controller: _nameCtrl,
                                keyboardType: TextInputType.name,
                                onChanged: (_) => setState(() {}),
                              ),
                              const SizedBox(height: 10),
                              _InputGlass(
                                label: 'Email receipt',
                                hint: 'you@example.com',
                                icon: Icons.alternate_email_rounded,
                                controller: _emailCtrl,
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (_) => setState(() {}),
                              ),
                              const SizedBox(height: 10),
                              _InputGlass(
                                label: 'Card number',
                                hint: '1234 5678 9012 3456',
                                icon: Icons.credit_card_rounded,
                                controller: _cardCtrl,
                                keyboardType: TextInputType.number,
                                maxLength: 19,
                                onChanged: (v) {
                                  _formatCard(v);
                                  setState(() {});
                                },
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: _InputGlass(
                                      label: 'Exp (MM/YY)',
                                      hint: '12/34',
                                      icon: Icons.date_range_rounded,
                                      controller: _expCtrl,
                                      keyboardType: TextInputType.number,
                                      maxLength: 5,
                                      onChanged: (v) {
                                        _formatExp(v);
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _InputGlass(
                                      label: 'CVC',
                                      hint: '123',
                                      icon: Icons.lock_rounded,
                                      controller: _cvcCtrl,
                                      keyboardType: TextInputType.number,
                                      maxLength: 4,
                                      onChanged: (_) => setState(() {}),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.10),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.verified_user_rounded, color: Colors.white, size: 18),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'Encrypted & secure (demo).',
                                        style: t.bodyMedium?.copyWith(
                                          color: Colors.white.withValues(alpha: 0.84),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.10),
                                        borderRadius: BorderRadius.circular(999),
                                        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
                                      ),
                                      child: Text(
                                        'VISA • MC',
                                        style: t.labelLarge?.copyWith(
                                          color: Colors.white.withValues(alpha: 0.88),
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 0.6,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        Glass(
                          padding: const EdgeInsets.all(14),
                          borderRadius: BorderRadius.circular(26),
                          opacity: 0.32,
                          blur: 18,
                          child: Row(
                            children: [
                              const Icon(Icons.info_outline_rounded, color: Colors.white, size: 18),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'This payment is simulated for demo purposes.',
                                  style: t.bodyMedium?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.82),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        PrimaryButton(
                          text: _paying ? 'Processing…' : 'Pay now',
                          icon: Icons.lock_rounded,
                          onTap: _canPay ? _payNow : null,
                        ),
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

class _InputGlass extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final int? maxLength;
  final ValueChanged<String>? onChanged;

  const _InputGlass({
    required this.label,
    required this.hint,
    required this.icon,
    required this.controller,
    required this.keyboardType,
    this.maxLength,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            ),
            child: Icon(icon, color: Colors.white.withValues(alpha: 0.90), size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label.toUpperCase(),
                  style: t.labelMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.72),
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  maxLength: maxLength,
                  style: t.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    counterText: '',
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    hintText: hint,
                    hintStyle: t.titleMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.45),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  onChanged: onChanged,
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
