import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/dkg_icons.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../domain/entities/transaction_entity.dart';
import '../../blocs/account/account_bloc.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../widgets/app_avatar.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/feature_icon.dart';
import '../../widgets/transaction_row.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _hideBalance = false;

  @override
  void initState() {
    super.initState();
    context.read<AccountBloc>().add(AccountLoadRequested());
    context.read<AuthBloc>().add(AuthCheckRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final user = authState is AuthAuthenticated ? authState.user : null;
        final firstName = user?.firstName ?? 'Kamu';
        final fullName = user?.name ?? 'User';

        return Scaffold(
          backgroundColor: AppColors.bg,
          body: BlocBuilder<AccountBloc, AccountState>(
            builder: (context, accountState) {
              final balance = accountState is AccountLoaded ? accountState.account.balance : 0.0;
              final txns =
                  accountState is AccountLoaded ? accountState.transactions : <TransactionEntity>[];
              final loading = accountState is AccountLoading;

              return RefreshIndicator(
                onRefresh: () async => context.read<AccountBloc>().add(AccountRefreshRequested()),
                color: AppColors.primary,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      _buildHeader(fullName, firstName, balance, loading),
                      const SizedBox(height: 16),
                      _buildFeatureSection(),
                      const SizedBox(height: 16),
                      _buildDeeplinkBanner(),
                      const SizedBox(height: 22),
                      _buildTransactions(txns),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildHeader(String fullName, String firstName, double balance, bool loading) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 12, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: avatar + greeting + notifications
          Row(
            children: [
              AppAvatar(name: fullName, size: 44, bg: Colors.white.withValues(alpha: 0.25)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Selamat siang,',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.7),
                        )),
                    Text('$firstName ',
                        style: const TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.2,
                        )),
                  ],
                ),
              ),
              // Notification bell badge
              Stack(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(DkgIcons.bell, size: 20, color: Colors.white),
                  ),
                  Positioned(
                    top: 9,
                    right: 10,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.gold,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Balance — langsung di gradient (gak ada white card)
          Row(
            children: [
              const Icon(DkgIcons.wallet, size: 18, color: Colors.white70),
              const SizedBox(width: 8),
              const Text('Saldo DKG',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white70,
                  )),
              const Spacer(),
              GestureDetector(
                onTap: () => context.go('/topup'),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                  ),
                  child: const Row(
                    children: [
                      Icon(DkgIcons.plus, size: 14, color: Colors.white),
                      SizedBox(width: 4),
                      Text('Isi Saldo',
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Large balance amount
          Row(
            children: [
              Text(
                _hideBalance ? '••••••••' : CurrencyFormatter.format(balance),
                style: const TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: Icon(
                  _hideBalance ? DkgIcons.eyeOff : DkgIcons.eye,
                  size: 20,
                  color: Colors.white70,
                ),
                onPressed: () => setState(() => _hideBalance = !_hideBalance),
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Quick action pills — langsung di header, gak pake card
          Row(
            children: [
              _actionPill(icon: DkgIcons.topup, label: 'Top Up', onTap: () => context.go('/topup')),
              const SizedBox(width: 10),
              _actionPill(icon: DkgIcons.send, label: 'Transfer', onTap: () => context.go('/transfer')),
              const SizedBox(width: 10),
              _actionPill(icon: DkgIcons.qris, label: 'Bayar', onTap: () => context.go('/payment')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionPill({required IconData icon, required String label, required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: Column(
            children: [
              Icon(icon, color: Colors.white, size: 22),
              const SizedBox(height: 4),
              Text(label,
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.9),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureSection() {
    final features = [
      {'icon': DkgIcons.bill, 'label': 'Pembayaran', 'tone': 'violet'},
      {'icon': DkgIcons.pulsa, 'label': 'Pulsa', 'tone': 'green'},
      {'icon': DkgIcons.phone, 'label': 'Paket Data', 'tone': 'blue'},
      {'icon': DkgIcons.food, 'label': 'Makanan', 'tone': 'amber'},
      {'icon': DkgIcons.store, 'label': 'Merchant', 'tone': 'red', 'route': '/merchant'},
      {'icon': DkgIcons.splitBill, 'label': 'Split Bill', 'tone': 'slate'},
      {'icon': DkgIcons.star, 'label': 'Promo', 'tone': 'gold', 'route': '/promo'},
      {'icon': DkgIcons.more, 'label': 'Lainnya', 'tone': 'slate'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppColors.shadowSoft,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(DkgIcons.more, size: 18, color: AppColors.slate600),
                const SizedBox(width: 8),
                const Text('Fitur Unggulan',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    )),
              ],
            ),
            const SizedBox(height: 16),
            // 4-column grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.9,
              ),
              itemCount: features.length,
              itemBuilder: (context, index) {
                final f = features[index];
                return GestureDetector(
                  onTap: () => context.go(f['route'] as String? ?? '/'),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FeatureIcon(
                          icon: f['icon'] as IconData,
                          tone: f['tone'] as String,
                          size: 48,
                          iconSize: 22),
                      const SizedBox(height: 6),
                      Text(f['label'] as String,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.slate600,
                          )),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeeplinkBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () => context.go('/merchant'),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0E1726), Color(0xFF21314D)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(DkgIcons.store, size: 22, color: AppColors.gold),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Belanja di Merchant',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        )),
                    SizedBox(height: 3),
                    Text('Bayar langsung pakai Dompet Kampus',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 12,
                          color: Colors.white54,
                        )),
                  ],
                ),
              ),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(DkgIcons.arrowRight, size: 16, color: AppColors.gold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactions(List<TransactionEntity> txns) {
    final recent = txns.take(5).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              const Icon(DkgIcons.clock, size: 18, color: AppColors.slate600),
              const SizedBox(width: 8),
              const Text('Transaksi Terakhir',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  )),
              const Spacer(),
              GestureDetector(
                onTap: () {},
                child: const Text('Lihat Semua',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    )),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (recent.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(DkgIcons.wallet, size: 40, color: AppColors.slate300),
                  const SizedBox(height: 8),
                  const Text('Belum ada transaksi',
                      style: TextStyle(fontSize: 14, color: AppColors.slate400)),
                ],
              ),
            ),
          )
        else
          ...recent.map((tx) => TransactionRow(txn: tx)),
      ],
    );
  }
}
