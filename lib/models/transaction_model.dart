/// ============================================================================
/// MODEL RIWAYAT TRANSAKSI (FIREBASE-READY)
/// ============================================================================
/// Menyimpan informasi riwayat transaksi seperti Top Up, Transfer,
/// atau Pembayaran QRIS di PundiGo!.
/// ============================================================================
class TransactionModel {
  final String id;
  final String title;
  final String subtitle;
  final DateTime date;
  final double amount;
  final bool isIncome; // true: uang masuk (+), false: uang keluar (-)
  final String status; // "Sukses", "Menunggu", "Gagal"
  final String referenceNumber;
  final String category; // "TopUp", "Transfer", "QRIS", "Patungan"

  TransactionModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.amount,
    required this.isIncome,
    this.status = 'Sukses',
    required this.referenceNumber,
    this.category = 'Transfer',
  });

  String get dateFormatted {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    final m = date.month >= 1 && date.month <= 12 ? months[date.month - 1] : 'Okt';
    final minuteStr = date.minute.toString().padLeft(2, '0');
    final hourStr = date.hour.toString().padLeft(2, '0');
    return '${date.day} $m ${date.year}, $hourStr:$minuteStr WIB';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'date': date.toIso8601String(),
      'amount': amount,
      'isIncome': isIncome,
      'status': status,
      'referenceNumber': referenceNumber,
      'category': category,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      subtitle: map['subtitle'] ?? '',
      date: DateTime.tryParse(map['date'] ?? '') ?? DateTime.now(),
      amount: (map['amount'] ?? 0).toDouble(),
      isIncome: map['isIncome'] ?? false,
      status: map['status'] ?? 'Sukses',
      referenceNumber: map['referenceNumber'] ?? '',
      category: map['category'] ?? 'Transfer',
    );
  }
}
