import 'package:flutter/material.dart';
import '../../data/app_state.dart';
import '../../widgets/navigation/custom_bottom_nav_bar.dart';
import 'activity/activity_screen.dart';
import 'features/features_screen.dart';
import 'home/home_screen.dart';
import 'profile/profile_screen.dart';
import 'qris/scan_qris_screen.dart';

/// ============================================================================
/// HALAMAN NAVIGASI UTAMA (MAIN NAVIGATION WITH BOTTOM BAR)
/// ============================================================================
/// Catatan untuk Dosen:
/// - Menggunakan [IndexedStack] untuk mengelola 4 tab utama tanpa reload ulang.
/// - Menghubungkan [CustomBottomNavBar] dengan tampilan Beranda, Aktivitas,
///   Fitur, Profil, dan modal Scan QRIS.
/// ============================================================================
class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;

  const MainNavigationScreen({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _openScanQris() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ScanQrisScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) {
        return Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: [
              HomeScreen(
                onOpenFeatures: () => _onTabTapped(2),
                onOpenProfile: () => _onTabTapped(3),
              ),
              const ActivityScreen(),
              const FeaturesScreen(),
              const ProfileScreen(),
            ],
          ),
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
            onScanTap: _openScanQris,
          ),
        );
      },
    );
  }
}
