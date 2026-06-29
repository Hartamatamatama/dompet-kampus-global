/// Domain entity for a single financial transaction.
/// Supports both credit (in) and debit (out) types.
class TransactionEntity {
  final int id;
  final double amount;
  final String type;
  final String description;
  final DateTime? createdAt;

  const TransactionEntity({
    required this.id,
    required this.amount,
    required this.type,
    required this.description,
    this.createdAt,
  });

  bool get isCredit => type == 'credit' || type == 'in';
  bool get isDebit => type == 'debit' || type == 'out';
}
