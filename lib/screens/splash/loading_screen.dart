import 'package:flutter/material.dart';
import '../../widgets/common/pundigo_background.dart';
import '../onboarding/onboarding_screen.dart';

/// ============================================================================
/// HALAMAN LOADING SCREEN PUNDIGO (LOADING SCREEN 1 - 5)
/// ============================================================================
/// Sesuai layer Figma 'LOADING SCREEN 1' s.d 'LOADING SCREEN 5':
/// - Latar belakang putih dengan polkadot besar #ACEDFF di atas & #6CFBCB di bawah.
/// - Lambang PG 3D di tengah.
/// - Badge pil '✦ Dompet Pintar Generasi Maju'.
/// - Subtitle 'Cerdas Kelola, Cepat Bertumbuh'.
/// - Progress bar interaktif animasi 0% s.d 100% dengan status koneksi terenkripsi.
/// - Setelah 100%, otomatis berpindah ke Onboarding / Pengenalan Fitur.
/// ============================================================================
class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with TickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  late AnimationController _contentFadeController;
  late Animation<double> _contentFadeAnimation;

  String _statusText = 'Menghubungkan jaringan terenkripsi...';

  @override
  void initState() {
    super.initState();

    // Animasi fade in sangat halus untuk elemen loading di bawah logo
    _contentFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _contentFadeAnimation = CurvedAnimation(
      parent: _contentFadeController,
      curve: Curves.easeIn,
    );
    _contentFadeController.forward();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    _progressAnimation = CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOutCubic,
    );

    _progressController.addListener(() {
      final val = _progressController.value;
      setState(() {
        if (val < 0.35) {
          _statusText = 'Menghubungkan jaringan terenkripsi...';
        } else if (val < 0.70) {
          _statusText = 'Memverifikasi modul keamanan...';
        } else if (val < 0.95) {
          _statusText = 'Menyiapkan antarmuka dompet pintar...';
        } else {
          _statusText = 'Sistem siap!';
        }
      });
    });

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 350), () {
          if (mounted) {
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => const OnboardingScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
                transitionDuration: const Duration(milliseconds: 500),
              ),
            );
          }
        });
      }
    });

    // Mulai progress bar
    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _contentFadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PundigoBackground(
        child: Stack(
          children: [
            // 1. Logo identik dan sejajar 100% dengan SplashScreen (Alignment (0, -0.22))
            Align(
              alignment: const Alignment(0, -0.22),
              child: Hero(
                tag: 'pundigo_shared_logo',
                child: Image.asset(
                  'assets/images/logo_pundigo_full.png',
                  width: 160,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ),

            // 2. Elemen loading (Badge, Tagline, Progress Bar) muncul halus di bawah logo
            Align(
              alignment: const Alignment(0, 0.42),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: FadeTransition(
                  opacity: _contentFadeAnimation,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Badge Pill: Dompet Pintar Generasi Maju
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC1F2F0), // #C1F2F0 persis sampel Figma
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFF8CEFD8), width: 1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.auto_awesome, size: 12, color: Color(0xFF00A887)),
                            SizedBox(width: 6),
                            Text(
                              'Dompet Pintar Generasi Maju',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF00796B),
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Tagline: Cerdas Kelola, Cepat Bertumbuh
                      const Text(
                        'Cerdas Kelola, Cepat Bertumbuh',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1E202B),
                          letterSpacing: -0.3,
                        ),
                      ),

                      const SizedBox(height: 38),

                      // Status Text & Persentase (Row di atas Progress Bar)
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
                                      style: const TextStyle(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF6B7280),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    '$percentage%',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF00796B),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // Progress Bar Track & Fill (4px sleek per Figma)
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
          ],
        ),
      ),
    );
  }
}
