import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/nav/app_router.dart';
import '../../core/theme/rihla_colors.dart';
import '../../core/ui/glass.dart';
import '../../core/ui/primary_button.dart';
import '../../core/ui/rihla_field.dart';

enum TravelerType { local, mre, foreigner }

extension TravelerTypeX on TravelerType {
  String get label {
    switch (this) {
      case TravelerType.local:
        return 'Local';
      case TravelerType.mre:
        return 'MRE';
      case TravelerType.foreigner:
        return 'Étranger';
    }
  }

  IconData get icon {
    switch (this) {
      case TravelerType.local:
        return Icons.location_on_rounded;
      case TravelerType.mre:
        return Icons.flight_takeoff_rounded;
      case TravelerType.foreigner:
        return Icons.public_rounded;
    }
  }

  String get subtitle {
    switch (this) {
      case TravelerType.local:
        return 'Résident au Maroc';
      case TravelerType.mre:
        return 'Marocain à l’étranger';
      case TravelerType.foreigner:
        return 'Touriste international';
    }
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController(text: '');
  final _email = TextEditingController(text: '');
  final _pass = TextEditingController(text: '');
  final _idCtrl = TextEditingController(text: '');

  bool _hide = true;
  bool _agree = true;

  TravelerType _type = TravelerType.local;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _pass.dispose();
    _idCtrl.dispose();
    super.dispose();
  }

  void _goLogin() => Navigator.pop(context);

  String get _idLabel => (_type == TravelerType.foreigner) ? 'Passport' : 'CIN';
  String get _idHint => (_type == TravelerType.foreigner) ? 'e.g. XH928104' : 'e.g. AB123456';
  IconData get _idIcon => (_type == TravelerType.foreigner) ? Icons.badge_rounded : Icons.credit_card_rounded;

  String? _validateName(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'Enter your name';
    if (s.length < 2) return 'Name is too short';
    return null;
  }

  String? _validateEmail(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'Enter your email';
    if (!s.contains('@') || !s.contains('.')) return 'Invalid email';
    return null;
  }

  String? _validatePass(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'Enter a password';
    if (s.length < 6) return 'Min 6 characters';
    return null;
  }

  String? _validateId(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'Enter your $_idLabel';
    if (s.length < 6) return 'Too short (min 6 chars)';
    return null;
  }

  void _create() {
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    if (!_agree) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the privacy terms.')),
      );
      return;
    }

    // UI only (backend later)
    Navigator.pushNamedAndRemoveUntil(context, Routes.shell, (r) => false);
  }

  void _setType(TravelerType t) {
    if (_type == t) return;
    setState(() {
      _type = t;
      _idCtrl.clear(); // important: avoid mixing CIN/Passport
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/backgrounds/auth_bg.jpg', fit: BoxFit.cover),

          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.28),
                  Colors.black.withValues(alpha: 0.14),
                  Colors.black.withValues(alpha: 0.60),
                ],
              ),
            ),
          ),

          Positioned(
            top: -70,
            right: -40,
            child: _BlurBlob(size: 240, color: RihlaColors.accent.withValues(alpha: 0.16)),
          ),
          Positioned(
            bottom: -90,
            left: -50,
            child: _BlurBlob(size: 280, color: RihlaColors.primary.withValues(alpha: 0.14)),
          ),

          SafeArea(
            child: Column(
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                  child: Row(
                    children: [
                      _BackPill(onTap: _goLogin, label: 'Login'),
                      const Spacer(),
                      Glass(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        borderRadius: BorderRadius.circular(18),
                        opacity: 0.30,
                        blur: 18,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset('assets/brand/logo_mark.png', width: 18, height: 18),
                            const SizedBox(width: 8),
                            Text(
                              'RIHLA',
                              style: t.labelLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 520),
                        child: Glass(
                          padding: const EdgeInsets.all(18),
                          borderRadius: BorderRadius.circular(30),
                          opacity: 0.42,
                          blur: 20,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Create your account',
                                  style: t.headlineMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Choose your traveler profile for a better Moroccan experience.',
                                  style: t.bodyMedium?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.86),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // Traveler type (chips)
                                _TravelerTypeCard(
                                  value: _type,
                                  onChanged: _setType,
                                ),

                                const SizedBox(height: 12),

                                RihlaField(
                                  label: 'Full name',
                                  hint: 'Your name',
                                  icon: Icons.person_rounded,
                                  controller: _name,
                                  keyboardType: TextInputType.name,
                                  validator: _validateName,
                                ),
                                const SizedBox(height: 12),

                                RihlaField(
                                  label: 'Email',
                                  hint: 'you@example.com',
                                  icon: Icons.alternate_email_rounded,
                                  controller: _email,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: _validateEmail,
                                ),
                                const SizedBox(height: 12),

                                // CIN / Passport
                                Glass(
                                  padding: const EdgeInsets.all(14),
                                  borderRadius: BorderRadius.circular(26),
                                  opacity: 0.28,
                                  blur: 18,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(_idIcon, color: Colors.white.withValues(alpha: 0.92), size: 18),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              'Identity verification',
                                              style: t.titleMedium?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withValues(alpha: 0.14),
                                              borderRadius: BorderRadius.circular(999),
                                              border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
                                            ),
                                            child: Text(
                                              _idLabel,
                                              style: t.labelLarge?.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        (_type == TravelerType.foreigner)
                                            ? 'We use Passport to secure bookings & prevent fraud.'
                                            : 'We use CIN to secure bookings & enable local/MRE offers.',
                                        style: t.bodyMedium?.copyWith(
                                          color: Colors.white.withValues(alpha: 0.82),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      RihlaField(
                                        label: _idLabel,
                                        hint: _idHint,
                                        icon: _idIcon,
                                        controller: _idCtrl,
                                        keyboardType: TextInputType.text,
                                        validator: _validateId,
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 12),

                                RihlaField(
                                  label: 'Password',
                                  hint: '••••••••',
                                  icon: Icons.lock_rounded,
                                  controller: _pass,
                                  obscure: _hide,
                                  validator: _validatePass,
                                  trailing: IconButton(
                                    onPressed: () => setState(() => _hide = !_hide),
                                    icon: Icon(
                                      _hide ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                                      color: RihlaColors.primaryDark.withValues(alpha: 0.85),
                                      size: 20,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 12),

                                // Privacy checkbox (simple)
                                InkWell(
                                  borderRadius: BorderRadius.circular(18),
                                  onTap: () => setState(() => _agree = !_agree),
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        value: _agree,
                                        onChanged: (v) => setState(() => _agree = v ?? true),
                                        activeColor: const Color(0xFFFFD58A),
                                        checkColor: Colors.black,
                                      ),
                                      Expanded(
                                        child: Text(
                                          'I agree to privacy & security terms (UI only).',
                                          style: t.labelLarge?.copyWith(
                                            color: Colors.white.withValues(alpha: 0.86),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 10),

                                PrimaryButton(
                                  text: 'Create account',
                                  icon: Icons.check_circle_rounded,
                                  onTap: _create,
                                ),

                                const SizedBox(height: 12),

                                PrimaryButton(
                                  text: 'I already have an account',
                                  icon: Icons.login_rounded,
                                  isSecondary: true,
                                  onTap: _goLogin,
                                ),
                              ],
                            ),
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 260.ms)
                            .slideY(begin: 0.10, end: 0, curve: Curves.easeOutCubic),
                      ),
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

class _TravelerTypeCard extends StatelessWidget {
  final TravelerType value;
  final ValueChanged<TravelerType> onChanged;

  const _TravelerTypeCard({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final items = TravelerType.values;

    return Glass(
      padding: const EdgeInsets.all(14),
      borderRadius: BorderRadius.circular(26),
      opacity: 0.28,
      blur: 18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.badge_rounded, color: Colors.white, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Traveler type',
                  style: t.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                'Choose one',
                style: t.labelLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.70),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: items.map((e) {
              final active = e == value;
              return InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: () => onChanged(e),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: active ? Colors.white.withValues(alpha: 0.18) : Colors.white.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: active ? Colors.white.withValues(alpha: 0.30) : Colors.white.withValues(alpha: 0.18),
                    ),
                    boxShadow: [
                      if (active)
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.18),
                          blurRadius: 14,
                          offset: const Offset(0, 10),
                        ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(e.icon, color: Colors.white.withValues(alpha: 0.92), size: 16),
                      const SizedBox(width: 8),
                      Text(
                        e.label,
                        style: t.labelLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.92),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '· ${e.subtitle}',
                        style: t.labelLarge?.copyWith(
                          color: Colors.white.withValues(alpha: 0.72),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _BackPill extends StatelessWidget {
  final VoidCallback onTap;
  final String label;

  const _BackPill({required this.onTap, required this.label});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.chevron_left_rounded, color: Colors.white, size: 18),
            const SizedBox(width: 6),
            Text(
              label,
              style: t.labelLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
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
      imageFilter: ImageFilter.blur(sigmaX: 26, sigmaY: 26),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
