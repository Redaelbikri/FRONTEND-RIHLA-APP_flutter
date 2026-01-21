import 'package:flutter/material.dart';
import '../theme/rihla_colors.dart';

class RihlaField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final bool obscure;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final Widget? trailing;

  const RihlaField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.labelMedium?.copyWith(color: RihlaColors.textSoft)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.80),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withValues(alpha: 0.65)),
            boxShadow: const [
              BoxShadow(
                color: RihlaColors.shadow,
                blurRadius: 18,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 12),
              Icon(icon, size: 18, color: RihlaColors.primaryDark.withValues(alpha: 0.85)),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  obscureText: obscure,
                  decoration: InputDecoration(
                    hintText: hint,
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              if (trailing != null) ...[
                trailing!,
                const SizedBox(width: 10),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
