import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/rihla_colors.dart';
import '../../core/ui/glass.dart';
import '../../core/ui/primary_button.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  int _lang = 0;

  final _langs = const ['English', 'Français', 'العربية'];

  void _save() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved (UI only).')),
    );
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
                  Colors.black.withValues(alpha: 0.58),
                ],
              ),
            ),
          ),
          Positioned(
            top: -70,
            right: -40,
            child: _BlurBlob(size: 250, color: RihlaColors.accent.withValues(alpha: 0.14)),
          ),
          Positioned(
            bottom: -90,
            left: -50,
            child: _BlurBlob(size: 300, color: RihlaColors.primary.withValues(alpha: 0.13)),
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
                          'Settings',
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
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(18, 10, 18, 120),
                    child: Column(
                      children: [
                        Glass(
                          padding: const EdgeInsets.all(18),
                          borderRadius: BorderRadius.circular(30),
                          opacity: 0.40,
                          blur: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Appearance',
                                style: t.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 12),

                              _SettingRow(
                                title: 'Dark mode',
                                subtitle: 'UI-only toggle (no persistence)',
                                trailing: Switch.adaptive(
                                  value: _darkMode,
                                  onChanged: (v) => setState(() => _darkMode = v),
                                  activeColor: Colors.white,
                                  activeTrackColor: RihlaColors.primary.withValues(alpha: 0.7),
                                ),
                              ),

                              const SizedBox(height: 14),

                              Text(
                                'Language',
                                style: t.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 10),

                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(22),
                                  border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.language_rounded, color: Colors.white, size: 18),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<int>(
                                          value: _lang,
                                          dropdownColor: const Color(0xFF1A1A1A),
                                          iconEnabledColor: Colors.white,
                                          items: List.generate(_langs.length, (i) {
                                            return DropdownMenuItem<int>(
                                              value: i,
                                              child: Text(
                                                _langs[i],
                                                style: t.bodyLarge?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            );
                                          }),
                                          onChanged: (v) => setState(() => _lang = v ?? 0),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 16),

                              Text(
                                'About',
                                style: t.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 10),

                              Text(
                                'RIHLA is a premium travel & events UI prototype focused on design quality, smooth transitions, and cultural inspiration.\n\nVersion: 1.0.0',
                                style: t.bodyMedium?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.84),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 16),

                              PrimaryButton(
                                text: 'Save settings',
                                icon: Icons.check_circle_rounded,
                                onTap: _save,
                              ),
                            ],
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 260.ms)
                            .slideY(begin: 0.10, end: 0, curve: Curves.easeOutCubic),

                        const SizedBox(height: 12),

                        Glass(
                          padding: const EdgeInsets.all(16),
                          borderRadius: BorderRadius.circular(28),
                          opacity: 0.30,
                          blur: 18,
                          child: Row(
                            children: [
                              Container(
                                width: 46,
                                height: 46,
                                decoration: BoxDecoration(
                                  gradient: RihlaColors.premiumGradient,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: const Icon(Icons.security_rounded, color: Colors.white, size: 22),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Privacy-first UI prototype — no backend, no tracking, no persistence.',
                                  style: t.bodyMedium?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.84),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                            .animate()
                            .fadeIn(delay: 120.ms, duration: 260.ms)
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

class _SettingRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget trailing;

  const _SettingRow({
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: t.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: t.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.80),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          trailing,
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
