import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/common/pg_logo.dart';
import '../main_navigation_screen.dart';
import '../kyc/kyc_ktp_guide_screen.dart';
import '../kyc/kyc_face_scan_screen.dart';

/// ============================================================================
/// HALAMAN PENAWARAN PUNDIGO! PLUS (100% PERSIS FIGMA 'Penawaran PundiGo PLus.png')
/// ============================================================================
/// Fitur & Tata Letak:
/// 1. Top Bar: Teks 'PundiGo! Plus' di kiri & logo emblem PG di kanan.
/// 2. Badge Status: '✓ PIN akun berhasil dibuat' dengan ikon centang toska.
/// 3. Judul Besar: 'Kenalan dengan PundiGo! Plus'.
/// 4. Kartu Gradien Fitur Plus: 'Bisa transfer dengan akun Plus' dengan dompet & (+).
/// 5. Kartu Persyaratan: Siapkan KTP & Wajah/selfie dengan kotak biru lembut.
/// 6. Catatan penjelas: 'Bisa lanjut tanpa upgrade sekarang. Tingkatkan ke Plus nanti saat kamu siap.'
/// 7. Tombol Utama: 'Tingkatkan ke Plus ➔' (Gradien toska-biru) -> Membuka Alur KYC KTP & Wajah.
/// 8. Tombol Sekunder: 'Nanti saja'.
/// ============================================================================
class PlusOfferScreen extends StatelessWidget {
  const PlusOfferScreen({super.key});

  void _skipToDashboard(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
      (route) => false,
    );
  }

  void _upgradeToPlus(BuildContext context) {
    // Alur resmi pendaftaran Akun Plus: Verifikasi e-KTP & Biometrik Wajah
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const KycKtpGuideScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===============================================================
              // 1. TOP BAR: PundiGo! Plus & Logo PG (Persis Figma)
              // ===============================================================
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'PundiGo! Plus',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E293B),
                        letterSpacing: -0.3,
                      ),
                    ),
                    PgLogo(size: 28),
                  ],
                ),
              ),

              const Divider(height: 1, color: Color(0xFFF1F5F9)),

              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ===============================================================
                    // 2. BADGE SUKSES: ✓ PIN akun berhasil dibuat
                    // ===============================================================
                    Row(
                      children: [
                        Container(
                          width: 22,
                          height: 22,
                          decoration: const BoxDecoration(
                            color: Color(0xFFD8F8F0),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.check,
                            color: Color(0xFF00BFA5),
                            size: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'PIN akun berhasil dibuat',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF00897B),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // ===============================================================
                    // 3. JUDUL BESAR & SUBJUDUL RESMI FIGMA
                    // ===============================================================
                    Text(
                      'Kenalan dengan\nPundiGo! Plus',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1E293B),
                        height: 1.2,
                        letterSpacing: -0.4,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Mau akses lebih? Tingkatkan akunmu dengan verifikasi identitas.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF64748B),
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ===============================================================
                    // 4. KARTU GRADIEN RESMI FIGMA (DOMPET & FITUR PLUS)
                    // ===============================================================
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00BFA5).withOpacity(0.25),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.asset(
                          'assets/images/plus_offer_card_exact.png',
                          width: double.infinity,
                          fit: BoxFit.fill,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ===============================================================
                    // 5. KARTU PERSYARATAN DENGAN IKON ASLI FIGMA
                    // ===============================================================
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Untuk jadi Plus, siapkan:',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Verifikasi identitas saat kamu siap.',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF64748B),
                            ),
                          ),

                          const SizedBox(height: 18),

                          // Syarat 1: KTP milikmu (Bisa Langsung Diklik)
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const KycKtpGuideScreen()),
                              );
                            },
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const _KtpRequirementIcon(),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'KTP milikmu',
                                              style: GoogleFonts.plusJakartaSans(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: const Color(0xFF0F172A),
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFE6F8F5),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: const Text(
                                                'Wajib',
                                                style: TextStyle(
                                                  color: Color(0xFF00A887),
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Scan atau foto e-KTP fisik yang jelas.',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xFF64748B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF00A887)),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Syarat 2: Wajah / selfie (Bisa Langsung Diklik)
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const KycFaceScanScreen()),
                              );
                            },
                            borderRadius: BorderRadius.circular(14),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const _FaceRequirementIcon(),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Wajah / selfie',
                                              style: GoogleFonts.plusJakartaSans(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: const Color(0xFF0F172A),
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFEFF6FF),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: const Text(
                                                'Biometrik',
                                                style: TextStyle(
                                                  color: Color(0xFF2563EB),
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Verifikasi liveness wajah untuk cocokkan KTP.',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xFF64748B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF2563EB)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ===============================================================
                    // 6. TEKS DISCLAIMER TENGAH
                    // ===============================================================
                    Center(
                      child: Text(
                        'Bisa lanjut tanpa upgrade sekarang.\nTingkatkan ke Plus nanti saat kamu siap.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF64748B),
                          height: 1.45,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ===============================================================
                    // 7. TOMBOL 1: Tingkatkan ke Plus ➔ (Gradien Mint-Biru)
                    // ===============================================================
                    InkWell(
                      onTap: () => _upgradeToPlus(context),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: double.infinity,
                        height: 52,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00BFA5), Color(0xFF1E88E5)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
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
                          children: const [
                            Text(
                              'Tingkatkan ke Plus',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 0.2,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 17),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ===============================================================
                    // 8. TOMBOL 2: Nanti saja (Teks Hijau Toska)
                    // ===============================================================
                    Center(
                      child: InkWell(
                        onTap: () => _skipToDashboard(context),
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text(
                            'Nanti saja',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF00A887),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Ikon Vektor Presisi "KTP milikmu" (Persis Figma Penawaran PundiGo PLus.png)
class _KtpRequirementIcon extends StatelessWidget {
  const _KtpRequirementIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: CustomPaint(
          size: const Size(24, 24),
          painter: _KtpIconPainter(),
        ),
      ),
    );
  }
}

class _KtpIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const color = Color(0xFF00A887);
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.9
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // 1. Badge body with rounded corners
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.16, size.height * 0.20, size.width * 0.68, size.height * 0.72),
      const Radius.circular(5),
    );
    canvas.drawRRect(rrect, strokePaint);

    // 2. Top clip tabs
    canvas.drawLine(
      Offset(size.width * 0.35, size.height * 0.08),
      Offset(size.width * 0.35, size.height * 0.22),
      strokePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.65, size.height * 0.08),
      Offset(size.width * 0.65, size.height * 0.22),
      strokePaint,
    );

    // 3. User head circle
    canvas.drawCircle(
      Offset(size.width * 0.50, size.height * 0.45),
      size.width * 0.14,
      strokePaint,
    );

    // 4. User shoulders / torso arc
    final shoulders = Path();
    shoulders.moveTo(size.width * 0.28, size.height * 0.82);
    shoulders.quadraticBezierTo(
      size.width * 0.50,
      size.height * 0.64,
      size.width * 0.72,
      size.height * 0.82,
    );
    canvas.drawPath(shoulders, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Ikon Vektor Presisi "Wajah / selfie" (Persis Figma Penawaran PundiGo PLus.png)
class _FaceRequirementIcon extends StatelessWidget {
  const _FaceRequirementIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: CustomPaint(
          size: const Size(24, 24),
          painter: _FaceScanPainter(),
        ),
      ),
    );
  }
}

class _FaceScanPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const color = Color(0xFF00A887);
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.9
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    const cornerLen = 5.5;

    // Top-Left corner
    canvas.drawLine(Offset(size.width * 0.16, size.height * 0.16 + cornerLen), Offset(size.width * 0.16, size.height * 0.16), strokePaint);
    canvas.drawLine(Offset(size.width * 0.16, size.height * 0.16), Offset(size.width * 0.16 + cornerLen, size.height * 0.16), strokePaint);

    // Top-Right corner
    canvas.drawLine(Offset(size.width * 0.84 - cornerLen, size.height * 0.16), Offset(size.width * 0.84, size.height * 0.16), strokePaint);
    canvas.drawLine(Offset(size.width * 0.84, size.height * 0.16), Offset(size.width * 0.84, size.height * 0.16 + cornerLen), strokePaint);

    // Bottom-Left corner
    canvas.drawLine(Offset(size.width * 0.16, size.height * 0.84 - cornerLen), Offset(size.width * 0.16, size.height * 0.84), strokePaint);
    canvas.drawLine(Offset(size.width * 0.16, size.height * 0.84), Offset(size.width * 0.16 + cornerLen, size.height * 0.84), strokePaint);

    // Bottom-Right corner
    canvas.drawLine(Offset(size.width * 0.84 - cornerLen, size.height * 0.84), Offset(size.width * 0.84, size.height * 0.84), strokePaint);
    canvas.drawLine(Offset(size.width * 0.84, size.height * 0.84), Offset(size.width * 0.84, size.height * 0.84 - cornerLen), strokePaint);

    // Two Eyes
    canvas.drawCircle(Offset(size.width * 0.38, size.height * 0.44), 1.6, fillPaint);
    canvas.drawCircle(Offset(size.width * 0.62, size.height * 0.44), 1.6, fillPaint);

    // Smiling Mouth
    final smile = Path();
    smile.moveTo(size.width * 0.36, size.height * 0.58);
    smile.quadraticBezierTo(
      size.width * 0.50,
      size.height * 0.72,
      size.width * 0.64,
      size.height * 0.58,
    );
    canvas.drawPath(smile, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
