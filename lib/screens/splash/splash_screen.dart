import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/common/pundigo_background.dart';
import '../onboarding/onboarding_screen.dart';

/// ============================================================================
/// HALAMAN PEMBUKA & LOADING SCREEN RESMI PUNDIGO (SEAMLESS SINGLE-CANVAS FLOW)
/// ============================================================================
/// Fitur Utama:
/// 1. Logo Awal (Halaman Pembuka):
///    - Lambang 3D PG tampil di tengah dengan animasi skala & fade-in elastis.
///    - Diberikan jeda elegan agar brand PundiGo! terlihat berkelas (tidak langsung jump).
/// 2. Transisi Sejajar & Super Smooth (Tanpa Ganti Layar):
///    - Posisi logo 100% terkunci dan sejajar (zero layout shift/flicker).
///    - Elemen loading (badge, tagline, dan progress bar) meluncur halus ke atas (slide + fade)
///      langsung di bawah logo.
/// 3. Indikator Keamanan & Persentase Real-time:
///    - Progress bar berjalan mulus dari 0% hingga 100%.
///    - Setelah 100% dan status 'Sistem siap!', otomatis berpindah ke [OnboardingScreen].
/// ============================================================================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  // Controller untuk kemunculan logo awal
  late AnimationController _logoController;
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;

  // Controller untuk kemunculan konten loading di bawah logo (Badge + Tagline + Progress Bar)
  late AnimationController _contentController;
  late Animation<double> _contentFade;
  late Animation<Offset> _contentSlide;

  // Controller untuk progres 0% s/d 100%
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  String _statusText = 'Menghubungkan jaringan terenkripsi...';

  @override
  void initState() {
    super.initState();

    // 1. Animasi Logo Awal
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _logoScale = Tween<double>(begin: 0.78, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeIn),
    );

    // 2. Animasi Masuk Konten Loading (Slide Up + Fade In sangat halus)
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _contentFade = CurvedAnimation(
      parent: _contentController,
      curve: Curves.easeOut,
    );
    _contentSlide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOutCubic),
    );

    // 3. Animasi Bar Progres
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2300),
    );
    _progressAnimation = CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOutCubic,
    );

    _progressController.addListener(() {
      final val = _progressController.value;
      if (mounted) {
        setState(() {
          if (val < 0.32) {
            _statusText = 'Menghubungkan jaringan terenkripsi...';
          } else if (val < 0.68) {
            _statusText = 'Memverifikasi modul keamanan...';
          } else if (val < 0.94) {
            _statusText = 'Menyiapkan antarmuka dompet pintar...';
          } else {
            _statusText = 'Sistem siap!';
          }
        });
      }
    });

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) {
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const OnboardingScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
                transitionDuration: const Duration(milliseconds: 450),
              ),
            );
          }
        });
      }
    });

    // Mulai rangkaian animasi:
    // Fase 1: Munculkan logo
    _logoController.forward();

    // Fase 2: Berikan jeda berkelas (1.1s) agar pengguna melihat logo awal sebelum loading muncul
    Future.delayed(const Duration(milliseconds: 1100), () {
      if (mounted) {
        _contentController.forward();
      }
    });

    // Fase 3: Mulai jalankan bar progres
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) {
        _progressController.forward();
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _contentController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PundigoBackground(
        child: Stack(
          children: [
            // 1. LOGO UTAMA PUNDIGO (TETAP DI POSISI Alignment(0, -0.22) TANPA PERGESERAN)
            Align(
              alignment: const Alignment(0, -0.22),
              child: FadeTransition(
                opacity: _logoFade,
                child: ScaleTransition(
                  scale: _logoScale,
                  child: Image.asset(
                    'assets/images/logo_pundigo_full.png',
                    width: 160,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              ),
            ),

            // 2. ELEMEN LOADING (MUNCUL HALUS DI BAWAH LOGO SECARA SEJAJAR)
            Align(
              alignment: const Alignment(0, 0.42),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: SlideTransition(
                  position: _contentSlide,
                  child: FadeTransition(
                    opacity: _contentFade,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Badge Pil: ✦ Dompet Pintar Generasi Maju
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFC1F2F0),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFF8CEFD8), width: 1),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.auto_awesome, size: 12, color: Color(0xFF00A887)),
                              const SizedBox(width: 6),
                              Text(
                                'Dompet Pintar Generasi Maju',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF00796B),
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Subtitle: Cerdas Kelola, Cepat Bertumbuh
                        Text(
                          'Cerdas Kelola, Cepat Bertumbuh',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1E202B),
                            letterSpacing: -0.3,
                          ),
                        ),

                        const SizedBox(height: 38),

                        // Baris Status & Persentase
                        AnimatedBuilder(
                          animation: _progressAnimation,
                          builder: (context, child) {
                            final percentage = (_progressAnimation.value * 100).toInt();
                            return Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        _statusText,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFF6B7280),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      '$percentage%',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF00796B),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),

                                // Progress Bar Elegan (Sesuai Figma)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                    height: 4,
                                    width: double.infinity,
                                    color: const Color(0xFFE5E7EB),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: FractionallySizedBox(
                                        widthFactor: _progressAnimation.value.clamp(0.01, 1.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFF00E5BC),
                                                Color(0xFF00897B),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
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
    );
  }
}
