import 'package:flutter/material.dart';
import '../../../core/ui/glass.dart';

class HomeTopGreeting extends StatelessWidget {
  final String userName;
  const HomeTopGreeting({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    return Glass(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      borderRadius: BorderRadius.circular(18),
      opacity: 0.38,
      blur: 18,
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white.withValues(alpha: 0.75),
            child: const Icon(Icons.person_rounded, size: 18, color: Color(0xFF1F6E5C)),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'GOOD MORNING',
                style: t.labelSmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.78),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.6,
                ),
              ),
              Text(
                'Salam, $userName',
                style: t.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.80),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.notifications_none_rounded, color: Color(0xFF1F6E5C)),
          ),
        ],
      ),
    );
  }
}
