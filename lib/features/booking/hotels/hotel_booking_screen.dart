import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/theme/rihla_colors.dart';
import '../../../core/ui/glass.dart';
import '../../../core/ui/primary_button.dart';
import '../../../data/models/hotel_model.dart';

class HotelBookingScreen extends StatefulWidget {
  final HotelModel hotel;
  const HotelBookingScreen({super.key, required this.hotel});

  @override
  State<HotelBookingScreen> createState() => _HotelBookingScreenState();
}

class _HotelBookingScreenState extends State<HotelBookingScreen> {
  DateTime _checkIn = DateTime.now().add(const Duration(days: 1));
  DateTime _checkOut = DateTime.now().add(const Duration(days: 3));

  int get nights {
    final d = _checkOut.difference(_checkIn).inDays;
    return d <= 0 ? 1 : d;
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    final name = (widget.hotel.nom ?? 'Hotel').trim();
    final city = (widget.hotel.ville ?? 'Unknown').trim();
    final image = (widget.hotel.imageUrl ?? '').trim();
    final hasNetworkImage = image.isNotEmpty && (image.startsWith('http://') || image.startsWith('https://'));
    final pricePerNight = (widget.hotel.prixParNuit ?? 0).toDouble();
    final rating = (widget.hotel.note ?? 0).toDouble();

    final total = pricePerNight * nights; // ✅ plus de null *

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          hasNetworkImage
              ? Image.network(image, fit: BoxFit.cover)
              : Image.asset(image.isNotEmpty ? image : 'assets/hotels/hotel_1.jpg', fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.10),
                  Colors.black.withValues(alpha: 0.10),
                  Colors.black.withValues(alpha: 0.62),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(18),
                        child: Glass(
                          padding: const EdgeInsets.all(10),
                          borderRadius: BorderRadius.circular(18),
                          opacity: 0.26,
                          blur: 18,
                          child: const Icon(Icons.chevron_left_rounded, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Glass(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          borderRadius: BorderRadius.circular(22),
                          opacity: 0.32,
                          blur: 18,
                          child: Text(
                            name,
                            overflow: TextOverflow.ellipsis,
                            style: t.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),

                  Glass(
                    padding: const EdgeInsets.all(16),
                    borderRadius: BorderRadius.circular(28),
                    opacity: 0.40,
                    blur: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(city, style: t.bodyLarge?.copyWith(color: Colors.white.withValues(alpha: 0.86), fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Colors.white, size: 18),
                            const SizedBox(width: 6),
                            Text(rating.toStringAsFixed(1), style: t.labelLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900)),
                            const Spacer(),
                            Text('${pricePerNight.toStringAsFixed(0)} MAD / night', style: t.labelLarge?.copyWith(color: Colors.white.withValues(alpha: 0.9), fontWeight: FontWeight.w900)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(height: 1, color: Colors.white.withValues(alpha: 0.12)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Text('Total ($nights nights)', style: t.titleMedium?.copyWith(color: Colors.white.withValues(alpha: 0.9), fontWeight: FontWeight.w900)),
                            const Spacer(),
                            Text('${total.toStringAsFixed(0)} MAD', style: t.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w900)),
                          ],
                        ),
                        const SizedBox(height: 14),
                        PrimaryButton(
                          text: 'Continue',
                          icon: Icons.arrow_forward_rounded,
                          onTap: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 240.ms).slideY(begin: 0.08, end: 0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
