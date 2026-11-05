import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/common/custom_app_bar.dart';
import 'kyc_ktp_camera_screen.dart';

/// ============================================================================
/// 1. PANDUAN PENGAMBILAN FOTO KTP (SESUAI FIGMA: Frame-3.png)
/// ============================================================================
class KycKtpGuideScreen extends StatelessWidget {
  const KycKtpGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFD),
      appBar: const CustomAppBar(title: 'Scan KTP'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Judul
              Text(
                'Foto KTP Asli',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Posisikan kartu di tengah bingkai kamera.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF64748B),
                ),
              ),

              const SizedBox(height: 20),

              // Ilustrasi Kartu KTP Elegan
              Center(
                child: Container(
                  width: double.infinity,
                  height: 190,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE0F2FE), Color(0xFFEFF6FF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF93C5FD), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF3B82F6).withOpacity(0.08),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Chip & Garis Kartu
                      Positioned(
                        top: 24,
                        left: 24,
                        child: Container(
                          width: 42,
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFCD34D),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFFF59E0B)),
                          ),
                          child: const Icon(Icons.memory_rounded, color: Color(0xFFB45309), size: 22),
                        ),
                      ),
                      Positioned(
                        top: 26,
                        left: 78,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(width: 120, height: 10, decoration: BoxDecoration(color: const Color(0xFF94A3B8).withOpacity(0.4), borderRadius: BorderRadius.circular(4))),
                            const SizedBox(height: 6),
                            Container(width: 80, height: 8, decoration: BoxDecoration(color: const Color(0xFF94A3B8).withOpacity(0.25), borderRadius: BorderRadius.circular(4))),
                          ],
                        ),
                      ),
                      // Foto KTP di kanan
                      Positioned(
                        top: 24,
                        right: 24,
                        bottom: 24,
                        child: Container(
                          width: 88,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFBFDBFE)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.person_rounded, size: 44, color: Color(0xFF94A3B8)),
                              SizedBox(height: 4),
                              Text('PAS FOTO', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Color(0xFF64748B))),
                            ],
                          ),
                        ),
                      ),
                      // Baris NIK & Detail
                      Positioned(
                        bottom: 24,
                        left: 24,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(width: 170, height: 12, decoration: BoxDecoration(color: const Color(0xFF0F172A).withOpacity(0.7), borderRadius: BorderRadius.circular(4))),
                            const SizedBox(height: 6),
                            Container(width: 140, height: 8, decoration: BoxDecoration(color: const Color(0xFF64748B).withOpacity(0.3), borderRadius: BorderRadius.circular(4))),
                            const SizedBox(height: 4),
                            Container(width: 110, height: 8, decoration: BoxDecoration(color: const Color(0xFF64748B).withOpacity(0.3), borderRadius: BorderRadius.circular(4))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Bagian Petunjuk Pengambilan Foto
              Text(
                'PETUNJUK PENGAMBILAN FOTO',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: const Color(0xFF64748B),
                ),
              ),

              const SizedBox(height: 14),

              // Poin 1
              _buildGuideItem(
                icon: Icons.credit_card_rounded,
                iconColor: const Color(0xFF00BFA5),
                bgColor: const Color(0xFFE6F8F5),
                title: 'e-KTP Asli Fisik',
                description: 'Gunakan kartu asli fisik, bukan salinan fotokopi atau hasil cetak kertas.',
              ),
              const SizedBox(height: 12),

              // Poin 2
              _buildGuideItem(
                icon: Icons.crop_free_rounded,
                iconColor: const Color(0xFF2563EB),
                bgColor: const Color(0xFFEFF6FF),
                title: 'Presisi 4 Sudut',
                description: 'Pastikan seluruh sudut KTP masuk ke dalam bingkai kamera dan tidak terpotong.',
              ),
              const SizedBox(height: 12),

              // Poin 3
              _buildGuideItem(
                icon: Icons.wb_sunny_outlined,
                iconColor: const Color(0xFFD97706),
                bgColor: const Color(0xFFFEF3C7),
                title: 'Bebas Pantulan Cahaya',
                description: 'NIK dan nama jelas terbaca, hindari silau lampu langsung maupun bayangan gelap.',
              ),

              const SizedBox(height: 20),

              // Kotak Enkripsi & Regulasi BI (Persis Figma)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.security_rounded, size: 20, color: Color(0xFF059669)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Data Anda terlindungi enkripsi 256-bit dan diawasi sesuai regulasi sistem pembayaran Bank Indonesia.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF475569),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Tombol Buka Kamera & Scan KTP
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const KycKtpCameraScreen()),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Buka Kamera & Scan KTP',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuideItem({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF64748B),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
