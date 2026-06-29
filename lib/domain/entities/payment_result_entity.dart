/// Domain entity returned after a successful payment or top-up.
class PaymentResultEntity {
  final double amount;
  final double balanceBefore;
  final double balanceAfter;
  final int? transactionId;
  final String? description;

  const PaymentResultEntity({
    required this.amount,
    required this.balanceBefore,
    required this.balanceAfter,
    this.transactionId,
    this.description,
  });
}
