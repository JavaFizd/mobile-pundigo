import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ============================================================================
/// KARTU AKSI CEPAT (TRANSFER, TOP UP, MINTA SALDO)
/// ============================================================================
/// 100% Persis desain Figma DASHBOARD-3.png:
/// - Kartu putih melayang dengan sudut membulat 22dp & bayangan halus.
/// - 3 Tombol aksi dengan lingkaran mint lembut (#E8F8F5) dan ikon toska (#00796B).
/// - Ikon vektor super tajam di semua resolusi:
///   1. Transfer: Kotak dengan panah keluar diagonal (↗)
///   2. Top Up: Tanda plus (+)
///   3. Minta Saldo: Tangan menadah koin dolar melayang ($)
/// ============================================================================
class QuickActionsCard extends StatelessWidget {
  final VoidCallback onTransferTap;
  final VoidCallback onTopUpTap;
  final VoidCallback onRequestTap;
  final VoidCallback onHistoryTap;

  const QuickActionsCard({
    super.key,
    required this.onTransferTap,
    required this.onTopUpTap,
    required this.onRequestTap,
    required this.onHistoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActionButton(
            iconWidget: const Icon(
              Icons.open_in_new_rounded,
              color: Color(0xFF00796B),
              size: 21,
            ),
            label: 'Transfer',
            onTap: onTransferTap,
          ),
          _buildActionButton(
            iconWidget: const Icon(
              Icons.add_rounded,
              color: Color(0xFF00796B),
              size: 25,
            ),
            label: 'Top Up',
            onTap: onTopUpTap,
          ),
          _buildActionButton(
            iconWidget: const _MintaSaldoIcon(color: Color(0xFF00796B)),
            label: 'Minta Saldo',
            onTap: onRequestTap,
          ),
          _buildActionButton(
            iconWidget: const Icon(
              Icons.receipt_long_rounded,
              color: Color(0xFF00796B),
              size: 22,
            ),
            label: 'Riwayat',
            onTap: onHistoryTap,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required Widget iconWidget,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: Color(0xFFE8F8F5),
                shape: BoxShape.circle,
              ),
              child: Center(child: iconWidget),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1E293B),
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Ikon Vektor Presisi "Minta Saldo": Tangan Menadah dengan Koin Dolar Melayang (Persis Figma DASHBOARD-3)
class _MintaSaldoIcon extends StatelessWidget {
  final Color color;
  const _MintaSaldoIcon({required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(24, 24),
      painter: _MintaSaldoPainter(color: color),
    );
  }
}

class _MintaSaldoPainter extends CustomPainter {
  final Color color;
  const _MintaSaldoPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // 1. Tanda Dolar '$' di bagian atas tengah
    final textPainter = TextPainter(
      text: TextSpan(
        text: '\$',
        style: TextStyle(
          color: color,
          fontSize: size.height * 0.44,
          fontWeight: FontWeight.w900,
          fontFamily: 'Arial',
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(size.width * 0.52 - textPainter.width / 2, size.height * 0.04),
    );

    // 2. Siluet Tangan Menadah (Filled Path) persis siluet Figma
    final path = Path();
    path.moveTo(size.width * 0.16, size.height * 0.74);
    path.lineTo(size.width * 0.16, size.height * 0.60);
    path.lineTo(size.width * 0.30, size.height * 0.58);
    path.lineTo(size.width * 0.42, size.height * 0.48);
    path.lineTo(size.width * 0.54, size.height * 0.48);
    path.lineTo(size.width * 0.46, size.height * 0.60);
    path.lineTo(size.width * 0.64, size.height * 0.60);
    path.lineTo(size.width * 0.82, size.height * 0.48);
    path.lineTo(size.width * 0.86, size.height * 0.54);
    path.lineTo(size.width * 0.68, size.height * 0.74);
    path.close();

    canvas.drawPath(path, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
