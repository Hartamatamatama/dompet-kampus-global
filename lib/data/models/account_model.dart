/// Data-layer model for account API responses.
class AccountModel {
  final int id;
  final double balance;
  final String? platform;
  final int userId;

  const AccountModel({
    required this.id,
    required this.balance,
    this.platform,
    this.userId = 0,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    return AccountModel(
      id: json['id'] as int? ?? 0,
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      platform: json['platform'] as String?,
      userId: json['user_id'] as int? ?? 0,
    );
  }
}
