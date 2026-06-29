import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/dkg_icons.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool light;
  final bool withText;

  const AppLogo({super.key, this.size = 56, this.light = false, this.withText = false});

  @override
  Widget build(BuildContext context) {
    const fontFamily = 'PlusJakartaSans';

    Widget icon = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: light
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.goldLight, AppColors.gold, Color(0xFFB8943F)],
              )
            : AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(size * 0.22),
      ),
      child: Center(
        child: Icon(
          DkgIcons.wallet,
          size: size * 0.5,
          color: Colors.white,
        ),
      ),
    );

    if (!withText) return icon;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        const SizedBox(width: 12),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dompet Kampus',
              style: TextStyle(
                fontFamily: fontFamily,
                fontSize: size * 0.3,
                fontWeight: FontWeight.w800,
                color: light ? Colors.white : AppColors.ink,
                letterSpacing: -0.3,
                height: 1.05,
              ),
            ),
            Text(
              'GLOBAL',
              style: TextStyle(
                fontFamily: fontFamily,
                fontSize: size * 0.205,
                fontWeight: FontWeight.w700,
                color: light ? Colors.white.withValues(alpha: 0.85) : AppColors.primary,
                letterSpacing: 1.5,
                height: 1.05,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
