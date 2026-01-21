import 'package:flutter/material.dart';

class BottomItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  const BottomItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
}

class BottomItems {
  static const items = <BottomItem>[
    BottomItem(
      label: 'Home',
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
    ),
    BottomItem(
      label: 'Trips',
      icon: Icons.map_outlined,
      activeIcon: Icons.map_rounded,
    ),
    BottomItem(
      label: 'Events',
      icon: Icons.local_activity_outlined,
      activeIcon: Icons.local_activity_rounded,
    ),
    BottomItem(
      label: 'Profile',
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
    ),
  ];
}
