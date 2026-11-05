import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'screens/activity/activity_screen.dart';
import 'screens/auth/plus_offer_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/features/features_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/transactions/patungan_pintar_screen.dart';
import 'screens/transactions/request_balance_screen.dart';
import 'screens/transactions/saku_kelompok_screen.dart';
import 'screens/transactions/topup_screen.dart';
import 'screens/transactions/transfer_screen.dart';
import 'widgets/common/mobile_frame.dart';

/// ============================================================================
/// TITIK MASUK UTAMA APLIKASI (ENTRY POINT) - PUNDIGO!
/// ============================================================================
/// Catatan Khusus untuk Dosen & Mahasiswa:
///
/// 1. BINGKAI SMARTPHONE OTOMATIS:
///    - Dijalankan di Browser Chrome / Desktop: Aplikasi otomatis tampil
///      di dalam bingkai smartphone interaktif dengan notch & status bar.
///    - Dijalankan di HP sungguhan: Otomatis tampil penuh (fullscreen).
///    - Terdapat tombol toggle 'Mode Layar Penuh / Bingkai HP' di kanan atas layar.
///
/// 2. ARSITEKTUR TAHAN UJI:
///    - `lib/core/`     : Warna tema & font (Google Fonts Plus Jakarta Sans)
///    - `lib/data/`     : Mock database lokal (Firebase-Ready)
///    - `lib/models/`   : Model data (dengan toMap & fromMap)
///    - `lib/widgets/`  : Komponen UI modular
///    - `lib/screens/`  : Halaman aplikasi sesuai alur Figma
/// ============================================================================
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PundiGoApp());
}

class PundiGoApp extends StatelessWidget {
  const PundiGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PundiGo!',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      scrollBehavior: const AppScrollBehavior(),
      builder: (context, child) {
        return MobileFrame(child: child ?? const SizedBox());
      },
      home: const SplashScreen(),
      routes: {
        '/splash': (_) => const SplashScreen(),
        '/onboarding': (_) => const OnboardingScreen(),
        '/register': (_) => const RegisterScreen(),
        '/plus-offer': (_) => const PlusOfferScreen(),
        '/main': (_) => const MainNavigationScreen(),
        '/transfer': (_) => const TransferScreen(),

        '/topup': (_) => const TopupScreen(),
        '/request': (_) => const RequestBalanceScreen(),
        '/patungan': (_) => const PatunganPintarScreen(),
        '/kas': (_) => const SakuKelompokScreen(),
        '/activity': (_) => const ActivityScreen(showBackButton: true),
        '/features': (_) => const FeaturesScreen(showBackButton: true),
        '/profile': (_) => const ProfileScreen(showBackButton: true),
      },
    );
  }
}
