import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ============================================================================
/// KARTU FITUR CERDAS PUNDIGO (100% PERSIS FIGMA DASHBOARD-3.png)
/// ============================================================================
/// Menggunakan aset ilustrasi resmi hasil ekstraksi Figma:
/// 1. Patungan Pintar: 'assets/images/patungan_illustration.png' (Smartphone + struk + avatar)
/// 2. Saku Kelompok: 'assets/images/saku_illustration.png' (Dompet toska + koin + avatar)
/// ============================================================================
class SmartFeatureCard extends StatelessWidget {
  final String title;
  final String description;
  final String actionText;
  final String imageAsset;
  final VoidCallback onTap;

  const SmartFeatureCard({
    super.key,
    required this.title,
    required this.description,
    required this.actionText,
    required this.imageAsset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 16, 12),
            child: Row(
              children: [
                // Visual Ilustrasi Resmi Figma (Dioptimasi cacheWidth untuk 60fps smooth scroll)
                SizedBox(
                  width: 120,
                  height: 80,
                  child: Image.asset(
                    imageAsset,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.medium,
                    cacheWidth: 240,
                  ),
                ),
                const SizedBox(width: 12),

                // Teks Judul, Deskripsi & Link Aksi
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1E293B),
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        description,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF64748B),
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            actionText,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF00796B),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.open_in_new_rounded,
                            size: 13,
                            color: Color(0xFF00796B),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
