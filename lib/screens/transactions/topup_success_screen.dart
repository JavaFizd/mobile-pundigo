import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../data/app_state.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/custom_app_bar.dart';

/// ============================================================================
/// HALAMAN TOP UP BERHASIL (STRUK RESMI DIGITAL)
/// ============================================================================
/// Catatan untuk Dosen:
/// - Sesuai desain 'Top up berhasil.png' di Figma.
/// - Menampilkan struk digital resmi bukti pengisian saldo berhasil.
/// - Menampilkan pembaruan saldo akun secara otomatis dari [AppState].
/// ============================================================================
class TopupSuccessScreen extends StatelessWidget {
  final double amount;

  const TopupSuccessScreen({
    super.key,
    this.amount = 100000,
  });

  @override
  Widget build(BuildContext context) {
    final user = AppState.instance.user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Top Up'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              const Text(
                'Detail Transaksi',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 24),

              // Ikon Centang Hijau
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Color(0xFF00796B),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded, color: Colors.white, size: 38),
              ),

              const SizedBox(height: 16),

              const Text(
                'Isi Saldo Berhasil!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                '+${CurrencyFormatter.format(amount)}',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF00796B),
                ),
              ),

              const SizedBox(height: 10),

              // Badge Transaksi Selesai
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F8F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.circle, size: 6, color: Color(0xFF00A887)),
                    SizedBox(width: 6),
                    Text(
                      'TRANSAKSI SELESAI & TERVERIFIKASI',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF00A887),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Kartu Rincian Struk
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border.withOpacity(0.6)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'RINCIAN TRANSAKSI',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textMuted,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEBF3FE),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'PundiGo Pay',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E88E5),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    _buildDetailRow('Metode', 'Tunai Kasir Indomaret'),
                    const SizedBox(height: 10),

                    _buildDetailRow(
                      'Akun PundiGo',
                      user.name,
                      subtitle: user.phone,
                    ),
                    const SizedBox(height: 10),

                    _buildDetailRow('Waktu Transaksi', '14 Okt 2026, 10:30 WIB'),
                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('No. Referensi', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                        Row(
                          children: const [
                            Text(
                              'PG-IDM-88219901',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.copy_outlined, size: 14, color: AppColors.textMuted),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    _buildDetailRow('Biaya Layanan', 'Rp 0 (Gratis)', valueColor: const Color(0xFF00A887)),
                    const SizedBox(height: 14),

                    const Divider(color: AppColors.border, height: 1),
                    const SizedBox(height: 14),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Saldo Baru PundiGo',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                        ),
                        Text(
                          CurrencyFormatter.format(user.saldoUtama),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF00796B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              AppButton(
                text: 'Selesai',
                onPressed: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {String? subtitle, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: valueColor ?? AppColors.textPrimary,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 1),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
