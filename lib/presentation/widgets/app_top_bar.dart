import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/dkg_icons.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final Widget? trailing;

  const AppTopBar({
    super.key,
    required this.title,
    this.onBack,
    this.actions,
    this.trailing,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 8);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: onBack != null
          ? IconButton(
              icon: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(DkgIcons.arrowLeft, size: 18, color: AppColors.primary),
              ),
              onPressed: onBack,
            )
          : null,
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'PlusJakartaSans',
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
      ),
      centerTitle: true,
      actions: actions,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: Container(
          height: 0,
          color: AppColors.line2,
        ),
      ),
    );
  }
}
