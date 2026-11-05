import 'package:flutter/material.dart';

/// ============================================================================
/// BANNER PROMO RESMI PUNDIGO (100% PERSIS & IDENTIK DENGAN FIGMA ASLI)
/// ============================================================================
/// Menggunakan aset asli dari Figma yang diberikan pengguna:
/// - Gradien toska-ke-biru mulus satu kesatuan tanpa kotak tempelan di kanan.
/// - Kartu 3D, koin emas, dan kilat asli desain pengguna.
/// - Tipografi dan tombol 'Coba Sekarang ➔' presisi pixel-perfect.
/// ============================================================================
class PromoBannerCard extends StatelessWidget {
  final VoidCallback? onTap;

  const PromoBannerCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00A887).withOpacity(0.24),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            splashColor: Colors.white.withOpacity(0.18),
            highlightColor: Colors.white.withOpacity(0.08),
            child: AspectRatio(
              aspectRatio: 396 / 113,
              child: Image.asset(
                'assets/images/promo_banner_figma_clean.png',
                fit: BoxFit.fill,
                filterQuality: FilterQuality.high,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
