import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/app_state.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/plus_upgrade_dialog.dart';
import '../../widgets/home/promo_banner.dart';
import '../../widgets/home/quick_actions.dart';
import '../../widgets/home/smart_feature_card.dart';
import '../transactions/patungan_pintar_screen.dart';
import '../transactions/request_balance_screen.dart';
import '../transactions/saku_kelompok_screen.dart';
import '../transactions/topup_screen.dart';
import '../transactions/transfer_screen.dart';
import '../transactions/transaction_history_screen.dart';
import 'pln_token_screen.dart';
import 'pulsa_screen.dart';

/// ============================================================================
/// HALAMAN SEMUA FITUR PUNDIGO
/// ============================================================================
/// Katalog lengkap seluruh layanan PundiGo!:
/// 1. Layanan Keuangan Cepat (Transfer, Top Up Indomaret, Minta Saldo, Riwayat)
/// 2. Tagihan & PPOB (Token Listrik PLN, Pulsa & Paket Data Telkomsel)
/// 3. Transfer Spesifik (Bank Aceh, BSI, GoPay, DANA)
/// 4. Fitur Cerdas (Patungan Pintar, Saku Kelompok)
/// ============================================================================
class FeaturesScreen extends StatelessWidget {
  final bool showBackButton;

  const FeaturesScreen({
    super.key,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: CustomAppBar(
        title: 'Fitur & Layanan',
        showBack: showBackButton,
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Judul Halaman
            Text(
              'Semua Fitur PundiGo',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Pusat layanan transaksi, tagihan, dan fitur cerdas',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: const Color(0xFF64748B),
              ),
            ),

            const SizedBox(height: 20),

            // Kategori 1: Layanan Keuangan
            Text(
              'Aksi Cepat Transaksi',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 12),

            QuickActionsCard(
              onTransferTap: () {
                if (!AppState.instance.user.isPlus) {
                  PlusUpgradeDialog.show(context, featureName: 'Transfer ke Bank & E-Wallet');
                  return;
                }
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const TransferScreen()),
                );
              },
              onTopUpTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const TopupScreen()),
                );
              },
              onRequestTap: () {
                if (!AppState.instance.user.isPlus) {
                  PlusUpgradeDialog.show(context, featureName: 'Minta Saldo').then((upgraded) {
                    if (upgraded == true && context.mounted) {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const RequestBalanceScreen()),
                      );
                    }
                  });
                  return;
                }
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const RequestBalanceScreen()),
                );
              },
              onHistoryTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const TransactionHistoryScreen()),
                );
              },
            ),

            const SizedBox(height: 24),

            // Kategori 2: Tagihan & Pembelian (PPOB)
            Text(
              'Tagihan & Pembelian',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                // Token Listrik PLN
                Expanded(
                  child: _buildServiceCard(
                    context: context,
                    title: 'Token Listrik',
                    subtitle: 'Stroom PLN Prabayar',
                    logoPath: 'assets/images/logo_pln.png',
                    badge: 'Bebas Admin',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const PlnTokenScreen()),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                // Pulsa & Data
                Expanded(
                  child: _buildServiceCard(
                    context: context,
                    title: 'Pulsa & Data',
                    subtitle: 'Telkomsel & Paket OMG',
                    logoPath: 'assets/images/logo_telkomsel.png',
                    badge: 'Promo',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const PulsaScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Kategori 3: Transfer Mitra Bank & E-Wallet
            Text(
              'Transfer Mitra Resmi',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFF1F5F9)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildPartnerRow(
                    context: context,
                    logoPath: 'assets/images/logo_pg_mark_hd.png',
                    title: 'PundiGo! Pay (Transfer Sesama)',
                    subtitle: 'Transfer instan antar sesama akun PundiGo! Rp0',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const TransferScreen(initialTabIndex: 0)),
                      );
                    },
                  ),
                  const Divider(color: Color(0xFFF1F5F9), height: 18),
                  _buildPartnerRow(
                    context: context,
                    logoPath: 'assets/images/logo_bank_aceh.png',
                    title: 'Bank Aceh Syariah',
                    subtitle: 'Transfer antar bank BI-FAST Rp0',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const TransferScreen(initialTabIndex: 1)),
                      );
                    },
                  ),
                  const Divider(color: Color(0xFFF1F5F9), height: 18),
                  _buildPartnerRow(
                    context: context,
                    logoPath: 'assets/images/logo_bank_bsi.png',
                    title: 'Bank Syariah Indonesia (BSI)',
                    subtitle: 'Transfer instan 24 jam real-time',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const TransferScreen(initialTabIndex: 1)),
                      );
                    },
                  ),
                  const Divider(color: Color(0xFFF1F5F9), height: 18),
                  _buildPartnerRow(
                    context: context,
                    logoPath: 'assets/images/logo_gopay.png',
                    title: 'GoPay Indonesia',
                    subtitle: 'Kirim saldo langsung ke akun GoPay',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const TransferScreen(initialTabIndex: 2)),
                      );
                    },
                  ),
                  const Divider(color: Color(0xFFF1F5F9), height: 18),
                  _buildPartnerRow(
                    context: context,
                    logoPath: 'assets/images/logo_dana.png',
                    title: 'DANA Dompet Digital',
                    subtitle: 'Kirim saldo langsung ke dompet DANA',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const TransferScreen(initialTabIndex: 2)),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Kategori 4: Fitur Cerdas
            Text(
              'Fitur Cerdas',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 12),

            SmartFeatureCard(
              title: 'Patungan Pintar',
              description: 'Scan struk, bagi tagihan otomatis',
              actionText: 'Mulai patungan',
              imageAsset: 'assets/images/patungan_illustration.png',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const PatunganPintarScreen()),
                );
              },
            ),

            SmartFeatureCard(
              title: 'Saku Kelompok',
              description: 'Dompet kas bersama yang praktis',
              actionText: 'Buka Saku',
              imageAsset: 'assets/images/saku_illustration.png',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SakuKelompokScreen()),
                );
              },
            ),

            const SizedBox(height: 20),

            PromoBannerCard(
              onTap: () {
                final appState = AppState.instance;
                if (appState.user.isPlus) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const TransferScreen(initialTabIndex: 1),
                    ),
                  );
                } else {
                  PlusUpgradeDialog.show(
                    context,
                    featureName: 'Gratis Transfer ke Semua Bank',
                  ).then((upgraded) {
                    if (upgraded == true && context.mounted) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const TransferScreen(initialTabIndex: 1),
                        ),
                      );
                    }
                  });
                }
              },
            ),

            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String logoPath,
    required String badge,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFF1F5F9)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Image.asset(logoPath, fit: BoxFit.contain),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F8F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    badge,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF00A887),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPartnerRow({
    required BuildContext context,
    required String logoPath,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 34,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Image.asset(logoPath, fit: BoxFit.contain),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8), size: 20),
          ],
        ),
      ),
    );
  }
}
