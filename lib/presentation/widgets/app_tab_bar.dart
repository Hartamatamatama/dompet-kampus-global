import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/dkg_icons.dart';

class AppTabBar extends StatelessWidget {
  final String active;
  final ValueChanged<String> onTab;
  final VoidCallback? onScan;

  const AppTabBar({
    super.key,
    required this.active,
    required this.onTab,
    this.onScan,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64 + MediaQuery.of(context).padding.bottom,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.line2, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            _TabItem(icon: DkgIcons.home, label: 'Home', tabKey: 'home', active: active, onTap: onTab),
            _TabItem(icon: DkgIcons.history, label: 'Riwayat', tabKey: 'history', active: active, onTap: onTab),
            // Center scan button — elevated
            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: onScan,
                  child: Container(
                    width: 52,
                    height: 52,
                    margin: const EdgeInsets.only(bottom: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primaryLight,
                          AppColors.primary,
                          AppColors.primaryDark,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(DkgIcons.scan, color: Colors.white, size: 24),
                  ),
                ),
              ),
            ),
            _TabItem(icon: DkgIcons.gift, label: 'Promo', tabKey: 'promo', active: active, onTap: onTab),
            _TabItem(icon: DkgIcons.user, label: 'Akun', tabKey: 'akun', active: active, onTap: onTab),
          ],
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String tabKey;
  final String active;
  final ValueChanged<String> onTap;

  const _TabItem({
    required this.icon,
    required this.label,
    required this.tabKey,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = active == tabKey;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(tabKey),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primarySurface : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 22,
                color: isActive ? AppColors.primary : AppColors.slate400,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive ? AppColors.primary : AppColors.slate400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
