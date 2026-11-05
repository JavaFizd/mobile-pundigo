import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../data/app_state.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/plus_upgrade_dialog.dart';
import '../../widgets/common/pundigo_qr_card.dart';

/// ============================================================================
/// HALAMAN MINTA SALDO & KODE QR
/// ============================================================================
/// Catatan untuk Dosen:
/// - Tampilan awal bersih persis Figma (tidak ada banner saat masuk).
/// - Saat pengguna mengklik 'Buat Kode QR Permintaan', sistem mengecek status akun:
///   jika belum Plus, akan muncul pemberitahuan dialog penawaran upgrade PundiGo Plus
///   (mirip seperti saat mau melakukan transfer).
/// - Jika sudah Plus atau memilih upgrade, Kode QR instan langsung ditampilkan.
/// ============================================================================
class RequestBalanceScreen extends StatefulWidget {
  const RequestBalanceScreen({super.key});

  @override
  State<RequestBalanceScreen> createState() => _RequestBalanceScreenState();
}

class _RequestBalanceScreenState extends State<RequestBalanceScreen> {
  final TextEditingController _amountController = TextEditingController(text: '50000');
  bool _showQrCode = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _handleGenerateQr() {
    final user = AppState.instance.user;
    if (!user.isPlus) {
      // Pemberitahuan Upgrade PundiGo Plus saat aksi (mirip saat mau transfer)
      PlusUpgradeDialog.show(
        context,
        featureName: 'Minta Saldo & Buat Kode QR',
      ).then((upgraded) {
        if (upgraded == true && mounted) {
          setState(() {
            _showQrCode = true;
          });
        }
      });
      return;
    }

    setState(() {
      _showQrCode = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = AppState.instance.user;
    final amount = double.tryParse(_amountController.text) ?? 50000;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Minta Saldo'),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              if (!_showQrCode) ...[
                // FASE 1: ATUR JUMLAH MINTA SALDO (BERSIH SESUAI FIGMA)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border.withOpacity(0.6)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Atur Jumlah Permintaan Saldo',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Tentukan nominal yang ingin kamu minta dari teman sesama PundiGo.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          prefixText: 'Rp ',
                          prefixStyle: GoogleFonts.plusJakartaSans(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryTeal,
                          ),
                          labelText: 'Nominal Saldo',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                AppButton(
                  text: 'Buat Kode QR Permintaan',
                  onPressed: _handleGenerateQr,
                ),
              ] else ...[
                // FASE 2: TAMPILKAN KODE QR & BAGIKAN TAUTAN
                PundigoQrCard(
                  userName: user.name,
                  userPhone: user.phone,
                  nominal: amount,
                  note: 'Permintaan Saldo PundiGo',
                  qrSize: 200,
                ),

                const SizedBox(height: 24),

                AppButton(
                  text: 'Bagikan Tautan Permintaan',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Tautan pembayaran ${CurrencyFormatter.format(amount)} berhasil disalin!'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 12),

                AppButton.outline(
                  text: 'Ubah Nominal',
                  onPressed: () {
                    setState(() {
                      _showQrCode = false;
                    });
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
