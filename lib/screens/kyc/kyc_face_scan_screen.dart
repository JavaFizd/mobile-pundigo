import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'kyc_success_screen.dart';

/// ============================================================================
/// 3. SCAN WAJAH & VERIFIKASI BIOMETRIK (SESUAI FIGMA: Frame-2.png)
/// ============================================================================
class KycFaceScanScreen extends StatefulWidget {
  const KycFaceScanScreen({super.key});

  @override
  State<KycFaceScanScreen> createState() => _KycFaceScanScreenState();
}

class _KycFaceScanScreenState extends State<KycFaceScanScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  int _stepProgress = 0; // 0: Menyesuaikan, 1: Kedipkan mata, 2: Terverifikasi
  Timer? _autoDetectTimer;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    // Simulasi deteksi wajah otomatis pintar
    _startAutoDetection();
  }

  void _startAutoDetection() {
    _autoDetectTimer = Timer(const Duration(milliseconds: 2200), () {
      if (mounted) {
        setState(() {
          _stepProgress = 1; // Minta kedipkan mata
        });
        _autoDetectTimer = Timer(const Duration(milliseconds: 2400), () {
          if (mounted) {
            _onSuccessCapture();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _autoDetectTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _onSuccessCapture() {
    setState(() {
      _stepProgress = 2; // Berhasil!
    });

    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const KycSuccessScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Scan Wajah',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Panduan Utama (Persis Figma Frame-2.png)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Posisikan Wajah Anda tepat di dalam oval',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.2,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Badge Instruksi Dinamis: "Kedipkan mata perlahan"
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _stepProgress == 1
                    ? const Color(0xFF00BFA5).withOpacity(0.25)
                    : Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _stepProgress == 1
                      ? const Color(0xFF00BFA5)
                      : Colors.white.withOpacity(0.15),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _stepProgress == 1 ? Icons.remove_red_eye_rounded : Icons.face_rounded,
                    color: _stepProgress == 1 ? const Color(0xFF69F0AE) : Colors.white70,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _stepProgress == 1 ? 'Kedipkan mata perlahan' : 'Tatap kamera lurus & tenang',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _stepProgress == 1 ? const Color(0xFF69F0AE) : Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Jendela Bidik Oval Biometrik (Persis Figma Frame-2.png)
            Center(
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  final glowRadius = 12 + (_pulseController.value * 14);
                  return Container(
                    width: 230,
                    height: 310,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(120),
                      border: Border.all(
                        color: _stepProgress == 2
                            ? const Color(0xFF10B981)
                            : (_stepProgress == 1 ? const Color(0xFF00BFA5) : const Color(0xFF38BDF8)),
                        width: 3.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (_stepProgress == 2
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFF00BFA5))
                              .withOpacity(0.4),
                          blurRadius: glowRadius,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Siluet Wajah
                        Opacity(
                          opacity: 0.25,
                          child: Icon(
                            Icons.face_retouching_natural_rounded,
                            size: 160,
                            color: Colors.white,
                          ),
                        ),

                        // Jika Berhasil Verifikasi
                        if (_stepProgress == 2)
                          Container(
                            width: 80,
                            height: 80,
                            decoration: const BoxDecoration(
                              color: Color(0xFF10B981),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check_rounded, color: Colors.white, size: 54),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const Spacer(),

            // Tombol "Ambil Foto Manual" (Persis Figma Frame-2.png)
            GestureDetector(
              onTap: _onSuccessCapture,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      'Ambil Foto Manual',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
