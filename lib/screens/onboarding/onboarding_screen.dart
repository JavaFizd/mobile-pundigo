import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/common/pundigo_background.dart';
import '../auth/register_screen.dart';

/// ============================================================================
/// HALAMAN PENGENALAN / ONBOARDING (PUNDIGO! INTRODUCE 1 & 2)
/// ============================================================================
/// 100% Native Vector UI - Tampilan Ultra HD & Bebas Tempelan:
/// - Latar belakang putih dengan polkadot pendaran lembut #ACEDFF & #6CFBCB.
/// - Header: Nama brand "PundiGo!" & Tombol "Lewati ➔" (hanya di slide 1).
/// - Logo Pusat: Lambang 3D PG + Tipografi tebal "PundiGo!".
/// - Kartu Utama:
///   * Menggunakan teks vektor asli (bukan gambar bitmap yang pecah).
///   * Gradien resmi Figma #04B99C (Emerald) ke #1E88E5 (Ocean Blue).
///   * Slide 1: Ilustrasi 3D Toples Kaca Transparan & Koin Emas.
///   * Slide 2: Ilustrasi 3D Dompet Mint Transparan & Koin Melayang.
/// - Indikator Titik Halaman interaktif (Pil hijau mint aktif & titik abu-abu).
/// - Tombol Aksi Utama: Gradien Mint ke Biru ("Lanjutkan ➔" & "Masuk ➔").
/// ============================================================================
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _goToRegister() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const RegisterScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  void _nextPage() {
    if (_currentPage < 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _goToRegister();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PundigoBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
            child: Column(
              children: [
                // =============================================================
                // 1. BARIS HEADER ATAS: "PundiGo!" & "Lewati ➔"
                // =============================================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'assets/images/logo_pundigo_text.png',
                      height: 20,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                    ),
                    if (_currentPage == 0)
                      InkWell(
                        onTap: _goToRegister,
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          child: Row(
                            children: [
                              Text(
                                'Lewati',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF4A5568),
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                size: 15,
                                color: Color(0xFF4A5568),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      const SizedBox(width: 60, height: 26), // Placeholder agar layout stabil
                  ],
                ),

                // =============================================================
                // 2. KONTEN TENGAH SEIMBANG: LOGO & KARTU FITUR DIKETENGAHKAN BERSAMA
                // =============================================================
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Brand Lockup Pusat (Logo 3D PG + Logotype "PundiGo!")
                        Image.asset(
                          'assets/images/logo_pundigo_full.png',
                          width: 155,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.high,
                        ),
                        const SizedBox(height: 24),
                        // Carousel Kartu Fitur Resmi Figma
                        SizedBox(
                          height: 345,
                          child: PageView(
                            controller: _pageController,
                            physics: const BouncingScrollPhysics(),
                            onPageChanged: (index) {
                              setState(() {
                                _currentPage = index;
                              });
                            },
                            children: [
                              // Slide 1: Nabung Receh & Toples Koin 3D
                              Center(
                                child: Image.asset(
                                  'assets/images/intro_card_1_hd.png',
                                  width: 372,
                                  fit: BoxFit.contain,
                                  filterQuality: FilterQuality.high,
                                ),
                              ),

                              // Slide 2: Patungan Santai & Dompet 3D
                              Center(
                                child: Image.asset(
                                  'assets/images/intro_card_2_hd.png',
                                  width: 372,
                                  fit: BoxFit.contain,
                                  filterQuality: FilterQuality.high,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // =============================================================
                // 3. INDIKATOR TITIK HALAMAN (PAGE INDICATOR FIGMA)
                // =============================================================
                Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 5,
                      width: _currentPage == 0 ? 24 : 6,
                      decoration: BoxDecoration(
                        color: _currentPage == 0 ? const Color(0xFF00A887) : const Color(0xFFD1D5DB),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 6),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 5,
                      width: _currentPage == 1 ? 24 : 6,
                      decoration: BoxDecoration(
                        color: _currentPage == 1 ? const Color(0xFF00A887) : const Color(0xFFD1D5DB),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // =============================================================
                // 4. TOMBOL AKSI UTAMA DENGAN GRADIEN RESMI FIGMA
                // =============================================================
                InkWell(
                  onTap: _nextPage,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    width: double.infinity,
                    height: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF00C9A7), // Mint Hijau
                          Color(0xFF2979FF), // Biru Laut Cerah
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00C9A7).withOpacity(0.35),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentPage == 0 ? 'Lanjutkan' : 'Masuk',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
