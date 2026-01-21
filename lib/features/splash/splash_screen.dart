import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/nav/app_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _revealController;
  late AnimationController _pulseController;
  Timer? _navTimer;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) _revealController.forward();
    });

    _navTimer = Timer(const Duration(milliseconds: 3800), () {
      if (!mounted) return;
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      Navigator.pushReplacementNamed(context, Routes.onboarding);
    });
  }

  @override
  void dispose() {
    _revealController.dispose();
    _pulseController.dispose();
    _navTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF2D9C75);
    const secondaryTeal = Color(0xFF1F7A8C);
    const glassWhite = Color(0x20FFFFFF);

    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [

          Positioned.fill(
            child: Image.asset(
              'assets/backgrounds/home_bg.jpg',
              fit: BoxFit.cover,
            ).animate().scale(
              begin: const Offset(1.1, 1.1),
              end: const Offset(1.0, 1.0),
              duration: 4.seconds,
            ),
          ),

          AnimatedBuilder(
            animation: _revealController,
            builder: (context, child) {
              double apertureSize = _revealController.value * (size.height * 1.5);

              return ClipPath(
                clipper: _ApertureClipper(holeRadius: apertureSize),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                  ),
                ),
              );
            },
          ),

          Center(
            child: AnimatedBuilder(
              animation: _revealController,
              builder: (context, child) {
                final slideUp = _revealController.value * -150;
                final opacity = (1.0 - _revealController.value * 1.5).clamp(0.0, 1.0);

                return Transform.translate(
                  offset: Offset(0, slideUp),
                  child: Opacity(
                    opacity: opacity,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [primaryGreen, secondaryTeal],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: primaryGreen.withOpacity(0.4),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.public,
                            color: Colors.white,
                            size: 40,
                          ),
                        ).animate(
                          onPlay: (c) => c.repeat(reverse: true),
                        ).scale(
                          begin: const Offset(1, 1),
                          end: const Offset(1.05, 1.05),
                          duration: 1.5.seconds,
                        ),

                        const SizedBox(height: 16),


                        Text(
                          "RIHLA",
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                            color: Colors.white,
                            letterSpacing: 2.0,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                        ),


                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: glassWhite,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withOpacity(0.1)),
                          ),
                          child: Text(
                            "Premium Travel Flow",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),


          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: AnimatedBuilder(
                animation: _revealController,
                builder: (context, child) {
                  if (_revealController.value > 0.1) return const SizedBox();

                  return SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      color: primaryGreen,
                      strokeWidth: 3,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ApertureClipper extends CustomClipper<Path> {
  final double holeRadius;

  _ApertureClipper({required this.holeRadius});

  @override
  Path getClip(Size size) {
    final path = Path();

    path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    if (holeRadius > 0) {
      path.addOval(Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: holeRadius,
      ));
      path.fillType = PathFillType.evenOdd;
    }

    return path;
  }

  @override
  bool shouldReclip(_ApertureClipper oldClipper) => oldClipper.holeRadius != holeRadius;
}