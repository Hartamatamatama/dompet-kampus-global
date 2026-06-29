/// Domain entity representing the user's financial account.
/// Tracks balance linked to a specific payment platform.
class AccountEntity {
  final int id;
  final double balance;
  final String? platform;
  final int userId;

  const AccountEntity({
    required this.id,
    required this.balance,
    this.platform,
    this.userId = 0,
  });
}
