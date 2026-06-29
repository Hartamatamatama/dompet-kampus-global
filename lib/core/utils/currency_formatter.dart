import 'package:intl/intl.dart';

/// Utility for formatting currency values in Indonesian Rupiah format.
/// Handles both full formatting and balance masking for privacy.
class CurrencyFormatter {
  static String format(double amount) {

  static String format(double amount, {bool withSymbol = true}) {
    final formatted = _formatter.format(amount.abs().round());
    return withSymbol ? 'Rp$formatted' : formatted;
  }

  static String formatInt(int amount, {bool withSymbol = true}) {
    return format(amount.toDouble(), withSymbol: withSymbol);
  }

  static String maskBalance() => 'Rp • • • • • •';
}
