import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/app_state.dart';
import '../../widgets/common/pg_logo.dart';
import '../../widgets/common/plus_upgrade_dialog.dart';
import '../../widgets/home/balance_header.dart';
import '../../widgets/home/notification_modal.dart';
import '../../widgets/home/promo_banner.dart';
import '../../widgets/home/quick_actions.dart';
import '../../widgets/home/smart_feature_card.dart';
import '../profile/profile_screen.dart';
import '../transactions/patungan_pintar_screen.dart';
import '../transactions/request_balance_screen.dart';
import '../transactions/saku_kelompok_screen.dart';
import '../transactions/topup_screen.dart';
import '../transactions/transfer_screen.dart';
import '../transactions/transaction_history_screen.dart';

/// ============================================================================
/// HALAMAN BERANDA / DASHBOARD PUNDIGO (100% PERSIS FIGMA DASHBOARD-3.png)
/// ============================================================================
/// Tata Letak & Estetika:
/// 1. [BalanceHeader]: Header gradien toska-biru membulat halus di bawah (28dp),
///    avatar DS periwinkle (#DCE4FD), sapaan 'Halo, Dinda!', 'MEMBER BARU',
///    saldo utama 'Rp100.000', badge '● Akun Basic'.
/// 2. [QuickActionsCard]: Kartu putih melayang tumpang tindih (50% di atas gradien,
///    50% di atas kanvas putih) dengan ikon transfer, top up, dan minta saldo resmi.
/// 3. [PgLogo]: Emblem logo PG di tengah berlatar putih bersih.
/// 4. "Uangmu, lebih teratur" & tautan "Fitur Cerdas >".
/// 5. [SmartFeatureCard]: Kartu Patungan Pintar & Saku Kelompok dengan ilustrasi resmi Figma.
/// 6. [PromoBannerCard]: Banner Promo Tahunan resmi Figma.
/// ============================================================================
class HomeScreen extends StatefulWidget {
  final VoidCallback onOpenFeatures;
  final VoidCallback? onOpenProfile;

  const HomeScreen({
    super.key,
    required this.onOpenFeatures,
    this.onOpenProfile,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AppState _appState = AppState.instance;

  @override
  void initState() {
    super.initState();
    _appState.addListener(_onStateChange);
  }

  @override
  void dispose() {
    _appState.removeListener(_onStateChange);
    super.dispose();
  }

  void _onStateChange() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final user = _appState.user;
    final isBalanceVisible = _appState.isBalanceVisible;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          children: [
            // =================================================================
            // 1. HEADER GRADIENT DENGAN KARTU AKSI CEPAT MELAYANG (TUMPANG TINDIH)
            // =================================================================
            Stack(
              clipBehavior: Clip.none,
              children: [
                BalanceHeader(
                  user: user,
                  isBalanceVisible: isBalanceVisible,
                  onToggleVisibility: () {
                    _appState.toggleBalanceVisibility();
                  },
                  onNotificationTap: () {
                    NotificationModal.show(context);
                  },
                  onProfileTap: () {
                    if (widget.onOpenProfile != null) {
                      widget.onOpenProfile!();
                    } else {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ProfileScreen(showBackButton: true),
                        ),
                      );
                    }
                  },
                  onDompetTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Saldo Dompet Simpanan: Rp ${user.saldoDompet.toInt()}'),
                      ),
                    );
                  },
                ),

                // Kartu Aksi Cepat (Transfer, Top Up, Minta Saldo) Melayang Tumpang Tindih
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: -40,
                  child: QuickActionsCard(
                    onTransferTap: () {
                      if (!_appState.user.isPlus) {
                        PlusUpgradeDialog.show(context, featureName: 'Transfer ke Bank & E-Wallet');
                        return;
                      }
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const TransferScreen()),
                      );
                    },
                    onTopUpTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const TopupScreen()),
                      );
                    },
                    onRequestTap: () {
                      if (!_appState.user.isPlus) {
                        PlusUpgradeDialog.show(context, featureName: 'Minta Saldo').then((upgraded) {
                          if (upgraded == true && mounted && context.mounted) {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => const RequestBalanceScreen()),
                            );
                          }
                        });
                        return;
                      }
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const RequestBalanceScreen()),
                      );
                    },
                    onHistoryTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const TransactionHistoryScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),

            // Jarak Penyeimbang Kartu Melayang ke Logo PG (Persis Figma DASHBOARD-3: 22px)
            const SizedBox(height: 62),

            // =================================================================
            // 2. LOGO PUNDIGO KECIL DI TENGAH (PERSIS FIGMA DASHBOARD-3.png)
            // =================================================================
            const Center(child: PgLogo(size: 26)),

            const SizedBox(height: 26),

            // =================================================================
            // 3. BAGIAN "UANGMU, LEBIH TERATUR" (FITUR CERDAS)
            // =================================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Uangmu, lebih teratur',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1E293B),
                          letterSpacing: -0.3,
                        ),
                      ),
                      InkWell(
                        onTap: widget.onOpenFeatures,
                        child: Row(
                          children: [
                            Text(
                              'Fitur Cerdas',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF00A887),
                              ),
                            ),
                            const SizedBox(width: 2),
                            const Icon(
                              Icons.chevron_right,
                              size: 18,
                              color: Color(0xFF00A887),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Kartu 1: Patungan Pintar (dengan aset ilustrasi asli Figma)
                  SmartFeatureCard(
                    title: 'Patungan Pintar',
                    description: 'Scan struk, bagi tagihan otomatis',
                    actionText: 'Mulai patungan',
                    imageAsset: 'assets/images/patungan_illustration.png',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const PatunganPintarScreen()),
                      );
                    },
                  ),

                  // Kartu 2: Saku Kelompok (dengan aset ilustrasi asli Figma)
                  SmartFeatureCard(
                    title: 'Saku Kelompok',
                    description: 'Dompet kas bersama yang praktis',
                    actionText: 'Buka Saku',
                    imageAsset: 'assets/images/saku_illustration.png',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const SakuKelompokScreen()),
                      );
                    },
                  ),

                  const SizedBox(height: 4),

                  // =============================================================
                  // 4. BANNER PROMO TAHUNAN PUNDIGO (dengan aset ilustrasi asli Figma)
                  // =============================================================
                  PromoBannerCard(
                    onTap: () {
                      if (_appState.user.isPlus) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const TransferScreen(initialTabIndex: 1),
                          ),
                        );
                      } else {
                        PlusUpgradeDialog.show(
                          context,
                          featureName: 'Gratis Transfer ke Semua Bank',
                        ).then((upgraded) {
                          if (upgraded == true && mounted && context.mounted) {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const TransferScreen(initialTabIndex: 1),
                              ),
                            );
                          }
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 52),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

