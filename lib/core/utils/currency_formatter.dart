import 'package:intl/intl.dart';

/// ============================================================================
/// FORMATTER RUPIAH PUNDIGO
/// ============================================================================
/// Helper untuk mengubah angka integer biasa (misal: 2450000)
/// menjadi format teks resmi Indonesia: "Rp 2.450.000"
/// ============================================================================
class CurrencyFormatter {
  static String format(num amount, {bool withPrefix = true, bool spaceAfterPrefix = false}) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: withPrefix ? (spaceAfterPrefix ? 'Rp ' : 'Rp') : '',
      decimalDigits: 0,
    );
    return formatter.format(amount).trim();
  }
}
