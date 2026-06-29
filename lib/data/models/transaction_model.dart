/// Data-layer model for transaction API responses.
class TransactionModel {
  final int id;
  final double amount;
  final String type;
  final String description;
  final DateTime? createdAt;

  const TransactionModel({
    required this.id,
    required this.amount,
    required this.type,
    required this.description,
    this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as int? ?? json['ID'] as int? ?? 0,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      type: json['type'] as String? ?? 'debit',
      description: json['description'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  bool get isCredit => type == 'credit' || type == 'in';
}
