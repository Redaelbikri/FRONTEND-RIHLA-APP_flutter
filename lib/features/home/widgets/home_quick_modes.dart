import 'package:flutter/material.dart';
import '../../../core/ui/glass.dart';

class HomeQuickModes extends StatelessWidget {
  final VoidCallback onTrains;
  final VoidCallback onBuses;
  final VoidCallback onHotels;
  final VoidCallback onFlights;

  const HomeQuickModes({
    super.key,
    required this.onTrains,
    required this.onBuses,
    required this.onHotels,
    required this.onFlights,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _QuickChip(icon: Icons.train_rounded, label: 'Trains', onTap: onTrains),
        _QuickChip(icon: Icons.directions_bus_rounded, label: 'Buses', onTap: onBuses),
        _QuickChip(icon: Icons.hotel_rounded, label: 'Hotels', onTap: onHotels),
        _QuickChip(icon: Icons.flight_rounded, label: 'Flights', onTap: onFlights),
      ],
    );
  }
}

class _QuickChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickChip({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Column(
        children: [
          Glass(
            padding: const EdgeInsets.all(12),
            borderRadius: BorderRadius.circular(18),
            opacity: 0.35,
            blur: 18,
            child: Container(
              width: 26,
              height: 26,
              alignment: Alignment.center,
              child: Icon(icon, color: Colors.white, size: 22),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: t.labelLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.90),
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
