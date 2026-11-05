import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/app_state.dart';
import '../main_navigation_screen.dart';

/// ============================================================================
/// 4. STATUS PENGAJUAN AKUN PLUS TERKIRIM (SESUAI FIGMA: Frame-4.png)
/// ============================================================================
class KycSuccessScreen extends StatelessWidget {
  const KycSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFD),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),

              // Badge Sukses Bergradien Emas & Toska
              Center(
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00BFA5), Color(0xFF1E88E5)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00BFA5).withOpacity(0.35),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.check_rounded, color: Colors.white, size: 52),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Judul Utama (Persis Figma Frame-4.png)
              Text(
                'Pengajuan Akun Plus Terkirim!',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                  letterSpacing: -0.3,
                ),
              ),

              const SizedBox(height: 12),

              // Penjelasan (Persis Figma Frame-4.png)
              Text(
                'Data identitas dan foto biometrik Anda sedang diverifikasi. Proses verifikasi otomatis membutuhkan waktu sekitar 1-5 menit.',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF64748B),
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 28),

              // Kartu Status Manfaat Plus
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6F8F5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            '✦ PundiGo! Plus',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF00A887),
                            ),
                          ),
                        ),
                        const Spacer(),
                        const Text(
                          '✓ Data Terverifikasi',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF059669),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    _buildBenefitRow(Icons.account_balance_wallet_rounded, 'Limit saldo naik hingga Rp 20.000.000'),
                    const SizedBox(height: 10),
                    _buildBenefitRow(Icons.sync_alt_rounded, 'Bebas transfer ke seluruh rekening & e-wallet'),
                    const SizedBox(height: 10),
                    _buildBenefitRow(Icons.groups_rounded, 'Akses penuh Kas Bersama & Patungan Pintar'),
                  ],
                ),
              ),

              const Spacer(),

              // Tombol "Kembali ke Beranda" (Persis Figma Frame-4.png)
              InkWell(
                onTap: () {
                  // Aktifkan akun Plus secara resmi di AppState
                  AppState.instance.upgradeToPlus();

                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
                    (route) => false,
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF00BFA5), Color(0xFF1E88E5)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00BFA5).withOpacity(0.35),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Kembali ke Beranda',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBenefitRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF00BFA5)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF334155),
            ),
          ),
        ),
      ],
    );
  }
}
