import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
export '../../core/theme/dkg_icons.dart';
import '../../core/theme/dkg_icons.dart';

class FeatureIcon extends StatelessWidget {
  final IconData icon;
  final String tone;
  final double size;
  final double iconSize;

  const FeatureIcon({
    super.key,
    required this.icon,
    this.tone = 'blue',
    this.size = 52,
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.tone(tone);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colors[0], colors[0].withOpacity(0.5)],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors[1].withOpacity(0.15), width: 1),
      ),
      child: Center(
        child: Icon(icon, color: colors[1], size: iconSize),
      ),
    );
  }
}
