import 'package:flutter/material.dart';

import '../home/home_screen.dart';
import '../trips/trips_screen.dart';
import '../events/events_screen.dart';
import '../profile/profile_screen.dart';
import '../booking/booking_hub_screen.dart';

class BottomShell extends StatefulWidget {
  const BottomShell({super.key});

  @override
  State<BottomShell> createState() => _BottomShellState();
}

class _BottomShellState extends State<BottomShell> {
  int _index = 0;


  final _pages = <Widget>[
    const HomeScreen(),
    const TripsScreen(),
    const BookingHubScreen(),
    const EventsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.85),
          border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.12))),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: _NavItem(
                    icon: Icons.home_rounded,
                    label: 'Home',
                    active: _index == 0,
                    onTap: () => setState(() => _index = 0),
                  ),
                ),
                Expanded(
                  child: _NavItem(
                    icon: Icons.auto_awesome_rounded,
                    label: 'Trips',
                    active: _index == 1,
                    onTap: () => setState(() => _index = 1),
                  ),
                ),

                Expanded(
                  child: _NavItem(
                    icon: Icons.confirmation_number_rounded,
                    label: 'Ticket',
                    active: _index == 2,
                    onTap: () => setState(() => _index = 2),
                  ),
                ),

                Expanded(
                  child: _NavItem(
                    icon: Icons.event_rounded,
                    label: 'Events',
                    active: _index == 3,
                    onTap: () => setState(() => _index = 3),
                  ),
                ),
                Expanded(
                  child: _NavItem(
                    icon: Icons.person_rounded,
                    label: 'Profile',
                    active: _index == 4,
                    onTap: () => setState(() => _index = 4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = active ? Colors.white : Colors.white.withValues(alpha: 0.50);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: c, size: 24),
            const SizedBox(height: 5),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                maxLines: 1,
                style: TextStyle(
                  color: c,
                  fontSize: 10,
                  fontWeight: active ? FontWeight.w800 : FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
