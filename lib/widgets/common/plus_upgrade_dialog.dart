import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../screens/auth/plus_offer_screen.dart';

/// ============================================================================
/// DIALOG PERINGATAN UPGRADE PUNDIGO PLUS
/// ============================================================================
/// Ditampilkan ketika pengguna Akun Basic mencoba mengakses:
/// 1. Fitur Transfer (Sesama PundiGo, Rekening Bank, E-Wallet)
/// 2. Fitur Token Listrik PLN
///
/// Menyediakan tombol aksi:
/// - "Upgrade ke Plus Sekarang": membuka alur verifikasi KTP & Wajah.
/// - "Nanti Saja": menutup dialog.
/// ============================================================================
class PlusUpgradeDialog extends StatelessWidget {
  final String featureName;

  const PlusUpgradeDialog({
    super.key,
    required this.featureName,
  });

  static Future<bool?> show(BuildContext context, {required String featureName}) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => PlusUpgradeDialog(featureName: featureName),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle Bar
          Container(
            width: 44,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFCBD5E1),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Icon Emblem PundiGo Plus
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF00BFA5), Color(0xFF2979FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00BFA5).withOpacity(0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons.workspace_premium_rounded,
              color: Colors.white,
              size: 38,
            ),
          ),

          const SizedBox(height: 16),

          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F8F5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'FITUR EKSKLUSIF PUNDIGO PLUS',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF00A887),
                letterSpacing: 0.8,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Title
          Text(
            'Upgrade ke PundiGo Plus',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0F172A),
            ),
          ),

          const SizedBox(height: 8),

          // Subtitle
          Text(
            'Fitur $featureName membutuhkan akun PundiGo Plus. Nikmati transfer bebas biaya ke semua bank & e-wallet serta pembayaran token listrik.',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: const Color(0xFF64748B),
              height: 1.45,
            ),
          ),

          const SizedBox(height: 20),

          // List Keuntungan Plus
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                _buildBenefitRow('Transfer gratis ke Bank Aceh, BSI, GoPay & DANA'),
                const SizedBox(height: 8),
                _buildBenefitRow('Beli Stroom Token Listrik PLN kapan saja'),
                const SizedBox(height: 8),
                _buildBenefitRow('Limit saldo dompet bertambah hingga Rp 20.000.000'),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Tombol Upgrade Sekarang
          SizedBox(
            width: double.infinity,
            height: 50,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00BFA5), Color(0xFF2979FF)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00BFA5).withOpacity(0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const PlusOfferScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  'Upgrade ke Plus Sekarang',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Tombol Nanti Saja
          SizedBox(
            width: double.infinity,
            height: 40,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(
                'Nanti Saja',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF64748B),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitRow(String text) {
    return Row(
      children: [
        const Icon(Icons.check_circle_rounded, color: Color(0xFF00A887), size: 16),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF334155),
            ),
          ),
        ),
      ],
    );
  }
}
