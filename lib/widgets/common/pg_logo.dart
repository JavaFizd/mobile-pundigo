import 'package:flutter/material.dart';

/// ============================================================================
/// LOGO ASLI PUNDIGO (LETTERMARK "PG") DARI FIGMA
/// ============================================================================
/// Menggunakan aset logo 3D gradien asli yang diekstrak langsung dari desain Figma,
/// dengan transparansi sempurna dan ketajaman tinggi di semua resolusi.
/// ============================================================================
class PgLogo extends StatelessWidget {
  final double size;
  const PgLogo({super.key, this.size = 28});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo_pg_clean.png',
      width: size,
      height: size * (368 / 475),
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      errorBuilder: (context, error, stackTrace) => _buildVectorLogo(),
    );
  }

  Widget _buildVectorLogo() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00E5BC), Color(0xFF00796B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00E5BC).withOpacity(0.35),
            blurRadius: size * 0.2,
            offset: Offset(0, size * 0.08),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'PG',
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.45,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
      ),
    );
  }
}

