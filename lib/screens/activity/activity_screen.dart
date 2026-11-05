import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../data/app_state.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../transactions/patungan_pintar_screen.dart';
import '../transactions/saku_kelompok_screen.dart';
import '../transactions/transaction_history_screen.dart';

/// ============================================================================
/// HALAMAN PUSAT AKTIVITAS (ACTIVITY FEED & INTERACTION HUB)
/// ============================================================================
/// Catatan untuk Dosen:
/// - Berbeda dari 'Riwayat Transaksi' (yang berfokus pada mutasi debit/kredit saldo),
///   halaman 'Aktivitas' berfungsi sebagai pusat interaksi sosial, notifikasi cerdas,
///   pembaruan status Kas Kelompok, tagihan Patungan Pintar, serta peringatan keamanan.
/// - Memiliki tab filter: Semua, Kas & Patungan, Permintaan Saldo, dan Sistem.
/// ============================================================================
class ActivityScreen extends StatefulWidget {
  final bool showBackButton;

  const ActivityScreen({
    super.key,
    this.showBackButton = false,
  });

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AppState _appState = AppState.instance;

  // Status simulasi aksi pending
  bool _isSplitBillPaid = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _appState.addListener(_onStateChange);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _appState.removeListener(_onStateChange);
    super.dispose();
  }

  void _onStateChange() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final user = _appState.user;
    final kas = _appState.kasKelompok;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFD),
      appBar: CustomAppBar(
        title: 'Aktivitas',
        showBack: widget.showBackButton,
        actions: [
          IconButton(
            tooltip: 'Riwayat Transaksi Keuangan',
            icon: const Icon(Icons.receipt_long_rounded, color: AppColors.textPrimary, size: 22),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const TransactionHistoryScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // =================================================================
            // 1. BANNER PENGANTAR: PUSAT AKTIVITAS & LINK KE RIWAYAT TRANSAKSI
            // =================================================================
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const TransactionHistoryScreen()),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6F8F5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFA7F3D0)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Color(0xFF00A887),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.receipt_long_rounded, color: Colors.white, size: 16),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cari mutasi atau bukti transfer?',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF00796B),
                              ),
                            ),
                            Text(
                              'Buka Riwayat Transaksi Keuangan ➔',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF047857),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: Color(0xFF00796B), size: 20),
                    ],
                  ),
                ),
              ),
            ),

            // =================================================================
            // 2. TAB FILTER AKTIVITAS
            // =================================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Container(
                height: 40,
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  dividerColor: Colors.transparent,
                  labelColor: const Color(0xFF0F172A),
                  unselectedLabelColor: const Color(0xFF64748B),
                  labelStyle: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
                  tabAlignment: TabAlignment.start,
                  tabs: const [
                    Tab(text: 'Semua Aktivitas'),
                    Tab(text: 'Kas & Patungan'),
                    Tab(text: 'Permintaan Saldo'),
                    Tab(text: 'Keamanan & Sistem'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 6),

            // =================================================================
            // 3. DAFTAR FEED AKTIVITAS
            // =================================================================
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab 1: Semua Aktivitas
                  _buildAllActivitiesView(user, kas),

                  // Tab 2: Kas & Patungan
                  _buildKasAndPatunganView(kas),

                  // Tab 3: Permintaan Saldo
                  _buildRequestsView(),

                  // Tab 4: Keamanan & Akun
                  _buildSystemView(user),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // FEED: SEMUA AKTIVITAS
  // ===========================================================================
  Widget _buildAllActivitiesView(dynamic user, dynamic kas) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      children: [
        // Kartu Tagihan Patungan Pintar Menunggu Tindakan
        if (!_isSplitBillPaid) ...[
          _buildActionRequiredCard(
            title: 'Tagihan Patungan Menunggu Pembayaran',
            subtitle: 'Patungan Makan Siang Bareng Kelompok - Rp 25.000 diminta oleh Naufal Daffa',
            time: '15 menit yang lalu',
            onPay: () {
              setState(() {
                _isSplitBillPaid = true;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tagihan Patungan Pintar Rp 25.000 berhasil dibayar!'),
                  backgroundColor: Color(0xFF059669),
                ),
              );
            },
            onDetails: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PatunganPintarScreen()),
              );
            },
          ),
          const SizedBox(height: 14),
        ],

        // Item 1: Kas Kelompok
        _buildActivityItem(
          icon: Icons.groups_rounded,
          iconBg: const Color(0xFFEFF6FF),
          iconColor: const Color(0xFF2563EB),
          title: 'Iuran Kas Kelompok Diterima',
          description: 'Naufal Daffa menyetor iuran Rp 15.000 ke ${kas.title}.',
          time: 'Hari ini, 10:30 WIB',
          actionLabel: 'Buka Saku',
          onAction: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SakuKelompokScreen()),
            );
          },
        ),
        const SizedBox(height: 12),

        // Item 2: Status Akun Plus
        _buildActivityItem(
          icon: Icons.verified_user_rounded,
          iconBg: const Color(0xFFE6F8F5),
          iconColor: const Color(0xFF00A887),
          title: user.isPlus ? 'Akun PundiGo! Plus Aktif' : 'Status Akun: Basic',
          description: user.isPlus
              ? 'Identitas e-KTP dan foto biometrik Anda telah terverifikasi dengan limit saldo hingga Rp 20.000.000.'
              : 'Tingkatkan ke PundiGo! Plus sekarang untuk membuka limit transaksi hingga Rp 20.000.000.',
          time: 'Kemarin, 14:15 WIB',
        ),
        const SizedBox(height: 12),

        // Item 3: Permintaan Saldo
        _buildActivityItem(
          icon: Icons.qr_code_2_rounded,
          iconBg: const Color(0xFFF3E8FF),
          iconColor: const Color(0xFF9333EA),
          title: 'Kode QR Permintaan Saldo Dibuat',
          description: 'Anda membuat tautan kode QR permintaan saldo sebesar Rp 50.000.',
          time: '24 Okt 2026, 18:20 WIB',
        ),
        const SizedBox(height: 12),

        // Item 4: Keamanan Login
        _buildActivityItem(
          icon: Icons.security_rounded,
          iconBg: const Color(0xFFFEF3C7),
          iconColor: const Color(0xFFD97706),
          title: 'Pemberitahuan Keamanan Login',
          description: 'Sesi login baru terdeteksi pada peramban web Chrome di sistem Windows.',
          time: '24 Okt 2026, 10:12 WIB',
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // ===========================================================================
  // FEED: KAS & PATUNGAN
  // ===========================================================================
  Widget _buildKasAndPatunganView(dynamic kas) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      children: [
        _buildActivityItem(
          icon: Icons.calculate_rounded,
          iconBg: const Color(0xFFEFF6FF),
          iconColor: const Color(0xFF2563EB),
          title: 'Patungan Pintar: OCR Struk Resto',
          description: 'Perhitungan bagi tagihan otomatis untuk 4 anggota selesai diproses.',
          time: 'Hari ini, 12:45 WIB',
          actionLabel: 'Lihat Hasil Bagi',
          onAction: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PatunganPintarScreen()),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildActivityItem(
          icon: Icons.groups_rounded,
          iconBg: const Color(0xFFE6F8F5),
          iconColor: const Color(0xFF00A887),
          title: 'Target Kas Bersama Diperbarui',
          description: 'Pengelola memperbarui batas target pengumpulan kas menjadi Rp 100.000.',
          time: 'Hari ini, 09:20 WIB',
          actionLabel: 'Detail Saku',
          onAction: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SakuKelompokScreen()),
            );
          },
        ),
      ],
    );
  }

  // ===========================================================================
  // FEED: PERMINTAAN SALDO
  // ===========================================================================
  Widget _buildRequestsView() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      children: [
        _buildActivityItem(
          icon: Icons.call_received_rounded,
          iconBg: const Color(0xFFE6F8F5),
          iconColor: const Color(0xFF00A887),
          title: 'Permintaan Saldo Terkirim',
          description: 'Permintaan saldo sebesar Rp 50.000 terkirim ke kontak +62 825-0180-1800.',
          time: '24 Okt 2026, 18:20 WIB',
        ),
        const SizedBox(height: 12),
        _buildActivityItem(
          icon: Icons.qr_code_scanner_rounded,
          iconBg: const Color(0xFFF1F5F9),
          iconColor: const Color(0xFF64748B),
          title: 'Kode QR Permintaan Aktif',
          description: 'Kode QR permintaan saldo siap dipindai oleh sesama pengguna PundiGo! atau QRIS.',
          time: '23 Okt 2026, 11:00 WIB',
        ),
      ],
    );
  }

  // ===========================================================================
  // FEED: KEAMANAN & SISTEM
  // ===========================================================================
  Widget _buildSystemView(dynamic user) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      children: [
        _buildActivityItem(
          icon: Icons.lock_outline_rounded,
          iconBg: const Color(0xFFFEF3C7),
          iconColor: const Color(0xFFD97706),
          title: 'PIN Keamanan Aktif',
          description: 'PIN transaksi 6-digit akun Anda aktif dan melindungi otorisasi pembayaran.',
          time: 'Hari ini, 08:00 WIB',
        ),
        const SizedBox(height: 12),
        _buildActivityItem(
          icon: Icons.security_rounded,
          iconBg: const Color(0xFFEFF6FF),
          iconColor: const Color(0xFF2563EB),
          title: 'Enkripsi 256-Bit Dilindungi BI',
          description: 'Seluruh transmisi data dan enkripsi dompet dipantau sesuai regulasi Bank Indonesia.',
          time: 'Sistem Selalu Aktif',
        ),
      ],
    );
  }

  // ===========================================================================
  // WIDGET KARTU PENDING ACTION (PERLU TINDAKAN)
  // ===========================================================================
  Widget _buildActionRequiredCard({
    required String title,
    required String subtitle,
    required String time,
    required VoidCallback onPay,
    required VoidCallback onDetails,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFDE68A)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD97706).withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFD97706),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'PERLU TINDAKAN',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                time,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: const Color(0xFF92400E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF78350F),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.5,
              color: const Color(0xFF92400E),
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    side: const BorderSide(color: Color(0xFFF59E0B)),
                  ),
                  onPressed: onDetails,
                  child: Text(
                    'Lihat Detail',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF92400E),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: InkWell(
                  onTap: onPay,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 38,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00BFA5), Color(0xFF1E88E5)],
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Bayar Sekarang',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // WIDGET ITEM AKTIVITAS FEED
  // ===========================================================================
  Widget _buildActivityItem({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String description,
    required String time,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      time,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: const Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.5,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF475569),
              height: 1.4,
            ),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onAction,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      actionLabel,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF00796B),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward_rounded, size: 14, color: Color(0xFF00796B)),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
