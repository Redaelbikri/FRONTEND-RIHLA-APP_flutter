import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:rihla2026/core/theme/rihla_colors.dart';
import 'package:rihla2026/core/ui/glass.dart';
import 'package:rihla2026/core/ui/primary_button.dart';
import 'package:rihla2026/core/ui/rihla_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _name = TextEditingController(text: 'REDA');
  final _email = TextEditingController(text: 'reda@rihla.app');
  final _city = TextEditingController(text: 'Casablanca');
  final _bio = TextEditingController(text: 'I love premium travel experiences and local discoveries.');

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _city.dispose();
    _bio.dispose();
    super.dispose();
  }

  void _save() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saved (UI only).')),
    );
    Navigator.pop(context);
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
                  Colors.black.withValues(alpha: 0.35),
                  Colors.black.withValues(alpha: 0.55),
                ],
              ),
            ),
          ),
          Positioned(
            top: -70,
            right: -40,
            child: _BlurBlob(size: 240, color: RihlaColors.accent.withValues(alpha: 0.14)),
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
                          'Edit profile',
                          style: t.labelLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(18, 10, 18, 120),
                    child: Glass(
                      padding: const EdgeInsets.all(18),
                      borderRadius: BorderRadius.circular(30),
                      opacity: 0.40,
                      blur: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Personal details',
                            style: t.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Update your identity and preferences.',
                            style: t.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.86), fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 16),

                          RihlaField(label: 'Full name', hint: 'Your name', icon: Icons.person_rounded, controller: _name),
                          const SizedBox(height: 12),
                          RihlaField(
                            label: 'Email',
                            hint: 'you@example.com',
                            icon: Icons.alternate_email_rounded,
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 12),
                          RihlaField(label: 'City', hint: 'City', icon: Icons.location_city_rounded, controller: _city),

                          const SizedBox(height: 12),
                          Text(
                            'Bio',
                            style: t.labelMedium?.copyWith(color: Colors.white.withValues(alpha: 0.78), fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
                            ),
                            child: TextField(
                              controller: _bio,
                              maxLines: 4,
                              style: t.bodyLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(14),
                                hintStyle: t.bodyLarge?.copyWith(color: Colors.white.withValues(alpha: 0.45)),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          PrimaryButton(
                            text: 'Save changes',
                            icon: Icons.check_circle_rounded,
                            onTap: _save,
                          ),
                        ],
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 260.ms)
                        .slideY(begin: 0.10, end: 0, curve: Curves.easeOutCubic),
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

class _BlurBlob extends StatelessWidget {
  final double size;
  final Color color;

  const _BlurBlob({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 26, sigmaY: 26),
      child: Container(width: size, height: size, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
    );
  }
}
