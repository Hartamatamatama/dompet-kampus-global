import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../blocs/account/account_bloc.dart';
import '../../widgets/app_button.dart';
import '../../widgets/feature_icon.dart';
import '../../widgets/success_check.dart';

class SuccessPage extends StatefulWidget {
  final String title;
  final String subtitle;
  final double amount;
  final List<List<String>> lines;

  const SuccessPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.lines,
  });

  @override
  State<SuccessPage> createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _slideUp;

  @override
  void initState() {
    super.initState();
    context.read<AccountBloc>().add(AccountRefreshRequested());
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _slideUp = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOutBack),
    );
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF6D28D9),
              Color(0xFF4C1D95),
              Color(0xFF2E1065),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top decorative area
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),
                    // Success check with gold accent
                    const SuccessCheck(),
                    const SizedBox(height: 20),
                    // Sparkle particles decoration
                    _SparkleRow(),
                    const SizedBox(height: 12),
                    // Title
                    Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    if (widget.subtitle.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        widget.subtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 14.5,
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                    const Spacer(flex: 1),
                  ],
                ),
              ),
              // Bottom card area
              AnimatedBuilder(
                animation: _slideUp,
                builder: (_, __) => Transform.translate(
                  offset: Offset(0, (1 - _slideUp.value) * 120),
                  child: Opacity(
                    opacity: _slideUp.value,
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Amount
                            Text(
                              CurrencyFormatter.format(widget.amount),
                              style: const TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: 34,
                                fontWeight: FontWeight.w800,
                                color: AppColors.ink,
                                letterSpacing: -0.6,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                gradient: AppColors.goldGradient,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text('BERHASIL',
                                  style: TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    letterSpacing: 1.2,
                                  )),
                            ),
                            if (widget.lines.isNotEmpty) ...[
                              const SizedBox(height: 18),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.primarySurface,
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                    color: AppColors.primaryBorder
                                        .withValues(alpha: 0.5),
                                  ),
                                ),
                                child: Column(
                                  children: widget.lines
                                      .asMap()
                                      .entries
                                      .map((e) {
                                    final i = e.key;
                                    final l = e.value;
                                    return Column(
                                      children: [
                                        if (i > 0)
                                          const Divider(
                                              height: 1,
                                              color: AppColors.line),
                                        Padding(
                                          padding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 11),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                            children: [
                                              Text(
                                                l[0],
                                                style: TextStyle(
                                                  fontFamily:
                                                      'PlusJakartaSans',
                                                  fontSize: 13.5,
                                                  color: AppColors.slate500,
                                                ),
                                              ),
                                              Text(
                                                l[1],
                                                textAlign: TextAlign.right,
                                                style: const TextStyle(
                                                  fontFamily:
                                                      'PlusJakartaSans',
                                                  fontSize: 13.5,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColors.ink,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                            const SizedBox(height: 22),
                            AppButton(
                              label: 'Selesai',
                              onPressed: () => context.go('/home'),
                            ),
                            const SizedBox(height: 10),
                            AppButton(
                              label: 'Bagikan bukti transaksi',
                              variant: AppButtonVariant.soft,
                              icon: const Icon(DkgIcons.copy,
                                  size: 18, color: AppColors.primary),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SparkleRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(DkgIcons.star, size: 12, color: AppColors.gold.withValues(alpha: 0.4)),
        const SizedBox(width: 6),
        Icon(DkgIcons.star, size: 18, color: AppColors.gold),
        const SizedBox(width: 6),
        Icon(DkgIcons.star, size: 12, color: AppColors.gold.withValues(alpha: 0.4)),
      ],
    );
  }
}
