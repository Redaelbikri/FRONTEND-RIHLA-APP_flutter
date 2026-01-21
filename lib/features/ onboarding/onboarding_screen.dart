import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/nav/app_router.dart';
import '../../core/theme/rihla_colors.dart';
import '../../core/ui/glass.dart';
import '../../core/ui/primary_button.dart';
import 'onboarding_model.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goLogin() {
    Navigator.pushReplacementNamed(context, Routes.login);
  }

  void _next() {
    if (_index < OnboardingModel.items.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
      );
    } else {
      _goLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final items = OnboardingModel.items;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 520),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: _BlurredBackground(
              key: ValueKey(items[_index].image),
              image: items[_index].image,
            ),
          ),


          const _CinematicOverlay(),


          Positioned(
            top: -70,
            left: -50,
            child: _BlurBlob(size: 260, color: RihlaColors.accent.withValues(alpha: 0.18)),
          ),
          Positioned(
            bottom: -90,
            right: -60,
            child: _BlurBlob(size: 300, color: RihlaColors.primary.withValues(alpha: 0.16)),
          ),

          SafeArea(
            child: Column(
              children: [

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    children: [
                      Glass(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        borderRadius: BorderRadius.circular(18),
                        opacity: 0.28,
                        blur: 18,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 18),
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
                      const Spacer(),
                      TextButton(
                        onPressed: _goLogin,
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          backgroundColor: Colors.white.withValues(alpha: 0.10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        ),
                        child: Text('Skip', style: t.labelLarge?.copyWith(fontWeight: FontWeight.w900)),
                      ),
                    ],
                  ),
                ),


                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: items.length,
                    onPageChanged: (i) => setState(() => _index = i),
                    itemBuilder: (_, i) => _OnboardingPageDesigned(
                      model: items[i],
                      index: i,
                      activeIndex: _index,
                      controller: _controller,
                    ),
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 12, 18, 22),
                  child: Column(
                    children: [
                      _PremiumIndicator(count: items.length, index: _index),
                      const SizedBox(height: 14),

                      Row(
                        children: [
                          Expanded(
                            child: Glass(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              borderRadius: BorderRadius.circular(22),
                              opacity: 0.24,
                              blur: 18,
                              child: Row(
                                children: [
                                  Icon(Icons.bolt_rounded, color: Colors.white.withValues(alpha: 0.92), size: 18),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      _index == 0
                                          ? 'Transport + hotel booking'
                                          : _index == 1
                                          ? 'Curated events discovery'
                                          : 'AI trip planning',
                                      style: t.labelLarge?.copyWith(
                                        color: Colors.white.withValues(alpha: 0.92),
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                            width: 144,
                            child: PrimaryButton(
                              text: _index == items.length - 1 ? 'Get Started' : 'Next',
                              icon: _index == items.length - 1
                                  ? Icons.arrow_forward_rounded
                                  : Icons.chevron_right_rounded,
                              onTap: _next,
                              expanded: true,
                            ),
                          ),
                        ],
                      )
                          .animate()
                          .fadeIn(duration: 240.ms)
                          .slideY(begin: 0.10, end: 0, curve: Curves.easeOutCubic),
                    ],
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

class _BlurredBackground extends StatelessWidget {
  final String image;
  const _BlurredBackground({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(image, fit: BoxFit.cover),
        ImageFiltered(
          imageFilter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
          child: Image.asset(image, fit: BoxFit.cover),
        ),
        Container(color: Colors.black.withValues(alpha: 0.18)),
      ],
    );
  }
}

class _CinematicOverlay extends StatelessWidget {
  const _CinematicOverlay();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0, -0.2),
              radius: 1.15,
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.46),
              ],
            ),
          ),
        ),

        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.08),
                Colors.black.withValues(alpha: 0.12),
                Colors.black.withValues(alpha: 0.60),
              ],
            ),
          ),
        ),
      ],
    );
  }
}


class _OnboardingPageDesigned extends StatelessWidget {
  final OnboardingModel model;
  final int index;
  final int activeIndex;
  final PageController controller;

  const _OnboardingPageDesigned({
    required this.model,
    required this.index,
    required this.activeIndex,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final isActive = index == activeIndex;

    return LayoutBuilder(
      builder: (context, c) {
        final h = c.maxHeight;
        final heroH = (h * 0.56).clamp(320.0, 520.0);
        final gap = 14.0;

        return AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            double page = activeIndex.toDouble();
            try {
              if (controller.hasClients && controller.page != null) page = controller.page!;
            } catch (_) {}

            final delta = (page - index).clamp(-1.0, 1.0);
            final parallax = delta * 18;

            return Padding(
              padding: const EdgeInsets.fromLTRB(18, 6, 18, 6),
              child: Column(
                children: [
                  const Spacer(),

                  Transform.translate(
                    offset: Offset(parallax, 0),
                    child: Container(
                      height: heroH,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(34),
                        boxShadow: const [
                          BoxShadow(
                            color: RihlaColors.shadow,
                            blurRadius: 30,
                            offset: Offset(0, 18),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            model.image,
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                          ),

                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.black.withValues(alpha: 0.08),
                                  Colors.black.withValues(alpha: 0.10),
                                  Colors.black.withValues(alpha: 0.22),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                      .animate(target: isActive ? 1 : 0)
                      .fadeIn(duration: 420.ms)
                      .scale(
                    begin: const Offset(0.98, 0.98),
                    end: const Offset(1, 1),
                    duration: 520.ms,
                    curve: Curves.easeOutCubic,
                  ),

                  SizedBox(height: gap),


                  Align(
                    alignment: Alignment.center,
                    child: Glass(
                      padding: const EdgeInsets.all(18),
                      borderRadius: BorderRadius.circular(30),
                      opacity: 0.42,
                      blur: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _Chip(text: model.chip)
                              .animate(target: isActive ? 1 : 0)
                              .fadeIn(duration: 320.ms)
                              .slideY(begin: 0.14, end: 0, duration: 420.ms, curve: Curves.easeOutCubic),

                          const SizedBox(height: 12),

                          Text(
                            model.title,
                            style: t.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          )
                              .animate(target: isActive ? 1 : 0)
                              .fadeIn(delay: 90.ms, duration: 360.ms)
                              .slideY(begin: 0.14, end: 0, duration: 460.ms, curve: Curves.easeOutCubic),

                          const SizedBox(height: 10),

                          Text(
                            model.subtitle,
                            style: t.bodyLarge?.copyWith(
                              color: Colors.white.withValues(alpha: 0.88),
                              fontWeight: FontWeight.w600,
                              height: 1.25,
                            ),
                          )
                              .animate(target: isActive ? 1 : 0)
                              .fadeIn(delay: 150.ms, duration: 360.ms)
                              .slideY(begin: 0.16, end: 0, duration: 520.ms, curve: Curves.easeOutCubic),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _Chip extends StatelessWidget {
  final String text;
  const _Chip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Colors.white.withValues(alpha: 0.92),
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _PremiumIndicator extends StatelessWidget {
  final int count;
  final int index;

  const _PremiumIndicator({required this.count, required this.index});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          width: active ? 22 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.white.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(99),
            boxShadow: [
              if (active)
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.18),
                  blurRadius: 12,
                  offset: const Offset(0, 8),
                ),
            ],
          ),
        );
      }),
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
