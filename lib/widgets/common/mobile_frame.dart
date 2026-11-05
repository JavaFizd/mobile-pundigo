import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ============================================================================
/// BINGKAI SMARTPHONE REALISTIS RESMI PUNDIGO (WEB PROTOTYPE MOCKUP)
/// ============================================================================
/// - Di Web Desktop: Menampilkan mockup smartphone fisik lengkap dengan bezel
///   halus, kamera punch-hole/speaker, tombol samping, dan bayangan 3D realistis.
/// - Di Layar Smartphone / Android Native: 100% fullscreen tanpa bingkai tambahan.
/// ============================================================================
class MobileFrame extends StatelessWidget {
  final Widget child;

  const MobileFrame({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Pada Android Studio (Emulator & HP Fisik Android/iOS): Langsung native murni
    if (!kIsWeb) {
      return child;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Jika dibuka dari browser HP (layar kecil < 500px): Langsung fullscreen
        if (constraints.maxWidth <= 500) {
          return child;
        }

        // Tampilan Desktop Web: Tampilkan mockup smartphone fisik yang presisi
        final double deviceWidth = 412;
        final double maxHeight = constraints.maxHeight;
        final double deviceHeight = min(maxHeight - 40, 870);

        return Scaffold(
          backgroundColor: const Color(0xFF0F172A), // Slate Dark Canvas Elegan
          body: Stack(
            alignment: Alignment.center,
            children: [
              // Efek Cahaya Latar Belakang (Ambient Fintech Glow)
              Positioned(
                top: -100,
                child: Container(
                  width: 500,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF00A887).withOpacity(0.22),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),

              // Mockup Smartphone Fisik
              Center(
                child: Container(
                  width: deviceWidth,
                  height: deviceHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(46),
                    // Bezel Luar Smartphone (Titanium Metalic Finish)
                    border: Border.all(
                      color: const Color(0xFF334155),
                      width: 10,
                    ),
                    boxShadow: [
                      // Bayangan Luar Realistis
                      BoxShadow(
                        color: Colors.black.withOpacity(0.45),
                        blurRadius: 40,
                        spreadRadius: 4,
                        offset: const Offset(0, 18),
                      ),
                      // Pendaran Aksen Hijau PundiGo di tepi bezel
                      BoxShadow(
                        color: const Color(0xFF00A887).withOpacity(0.18),
                        blurRadius: 28,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(36),
                    child: Stack(
                      children: [
                        // Layar Konten Aplikasi (Fluid & 100% Scrollable)
                        Positioned.fill(
                          child: child,
                        ),

                        // Kamera Punch-Hole & Earpiece Speaker di Atas (Hardware Mockup)
                        Positioned(
                          top: 8,
                          left: 0,
                          right: 0,
                          child: IgnorePointer(
                            child: Center(
                              child: Container(
                                width: 90,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0F172A),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Speaker Grille
                                    Container(
                                      width: 40,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF334155),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    // Selfie Camera
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: const Color(0xFF1E293B),
                                        border: Border.all(
                                          color: const Color(0xFF0284C7).withOpacity(0.6),
                                          width: 1.2,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Watermark / Badge Info di Pojok Kanan Atas
              Positioned(
                top: 18,
                right: 24,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.12)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF10B981),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'PundiGo! Mobile Prototype',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.85),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
