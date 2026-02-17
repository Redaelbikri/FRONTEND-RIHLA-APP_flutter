import 'package:flutter/material.dart';

import '../../../core/theme/rihla_colors.dart';
import '../../../core/ui/glass.dart';
import '../../../data/models/hotel_model.dart';

class HotelCard extends StatelessWidget {
  final HotelModel hotel;
  final VoidCallback onTap;

  const HotelCard({
    super.key,
    required this.hotel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    final name = (hotel.nom ?? 'Hotel').trim();
    final city = (hotel.ville ?? 'Unknown').trim();
    final image = (hotel.imageUrl ?? '').trim();
    final rating = (hotel.note ?? 0).toDouble();
    final price = (hotel.prixParNuit ?? 0).toDouble();

    final hasNetworkImage = image.isNotEmpty && (image.startsWith('http://') || image.startsWith('https://'));

    return InkWell(
      borderRadius: BorderRadius.circular(26),
      onTap: onTap,
      child: Glass(
        padding: const EdgeInsets.all(12),
        borderRadius: BorderRadius.circular(26),
        opacity: 0.34,
        blur: 18,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                width: 92,
                height: 92,
                child: hasNetworkImage
                    ? Image.network(image, fit: BoxFit.cover)
                    : Image.asset(
                  image.isNotEmpty ? image : 'assets/hotels/hotel_1.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: t.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    city,
                    style: t.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.84),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.white, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        rating.toStringAsFixed(1),
                        style: t.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                        decoration: BoxDecoration(
                          gradient: RihlaColors.premiumGradient,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '${price.toStringAsFixed(0)} MAD',
                          style: t.labelLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
