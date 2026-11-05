import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/app_state.dart';
import '../../widgets/common/pundigo_qr_card.dart';

/// ============================================================================
/// PUSAT QRIS PUNDIGO! - DUA OPSI: PINDAI (SCAN) & KODE QR SAYA
/// ============================================================================
/// Catatan untuk Dosen:
/// - Menyediakan 2 opsi tab:
///   1. 'Pindai QRIS': Jendela bidik kamera dengan reticle neon hijau khas Figma Frame.png,
///      animasi garis scanner, toggle senter/flash, dan simulasi deteksi QRIS merchant.
///   2. 'Kode QR Saya': Kartu QRIS resmi standar Bank Indonesia dengan logo PundiGo!
///      di tengah matriks QR, opsi atur nominal, simpan, dan bagikan tautan (Figma 2. Kode QR).
/// ============================================================================
class ScanQrisScreen extends StatefulWidget {
  final int initialTabIndex; // 0: Scan, 1: QR Saya
  const ScanQrisScreen({super.key, this.initialTabIndex = 0});

  @override
  State<ScanQrisScreen> createState() => _ScanQrisScreenState();
}

class _ScanQrisScreenState extends State<ScanQrisScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _laserController;
  bool _isFlashOn = false;
  double? _customNominal;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
    _laserController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _laserController.dispose();
    super.dispose();
  }

  void _onCapture() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          contentPadding: const EdgeInsets.all(24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Color(0xFFE6F8F5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.qr_code_2_rounded, color: Color(0xFF00A887), size: 36),
              ),
              const SizedBox(height: 16),
              Text(
                'Kode QRIS Terdeteksi!',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: [
                    _buildModalRow('Merchant', 'Kopi Kenangan Kampus'),
                    const Divider(height: 16),
                    _buildModalRow('Nominal', 'Rp 28.000'),
                    const Divider(height: 16),
                    _buildModalRow('Metode', 'PundiGo! Pay', isAccent: true),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                      ),
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text('Batal', style: GoogleFonts.plusJakartaSans(color: const Color(0xFF64748B), fontWeight: FontWeight.w700)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(ctx).pop();
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Pembayaran QRIS Rp 28.000 Berhasil!'),
                            backgroundColor: Color(0xFF059669),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00BFA5), Color(0xFF1E88E5)],
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Konfirmasi & Bayar',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
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
      },
    );
  }

  Widget _buildModalRow(String label, String value, {bool isAccent = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isAccent ? const Color(0xFF00A887) : const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }

  void _showSetNominalDialog() {
    final controller = TextEditingController(text: _customNominal?.toInt().toString() ?? '');
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          title: Text(
            'Atur Nominal Permintaan',
            style: GoogleFonts.plusJakartaSans(fontSize: 17, fontWeight: FontWeight.w800),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Tentukan jumlah yang harus dibayar saat kode QR ini dipindai oleh orang lain.',
                style: GoogleFonts.plusJakartaSans(fontSize: 12.5, color: const Color(0xFF64748B)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                autofocus: true,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                decoration: const InputDecoration(
                  prefixText: 'Rp ',
                  labelText: 'Nominal Saldo',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _customNominal = null;
                });
                Navigator.of(ctx).pop();
              },
              child: const Text('Bebas Nominal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00BFA5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                final val = double.tryParse(controller.text);
                setState(() {
                  _customNominal = val;
                });
                Navigator.of(ctx).pop();
              },
              child: const Text('Terapkan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = AppState.instance.user;

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
          'Pusat QRIS PundiGo',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Container(
              height: 44,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00BFA5), Color(0xFF1E88E5)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00BFA5).withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                labelStyle: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700),
                tabs: const [
                  Tab(
                    iconMargin: EdgeInsets.zero,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.qr_code_scanner_rounded, size: 18),
                        SizedBox(width: 8),
                        Text('Pindai QRIS'),
                      ],
                    ),
                  ),
                  Tab(
                    iconMargin: EdgeInsets.zero,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.qr_code_2_rounded, size: 18),
                        SizedBox(width: 8),
                        Text('Kode QR Saya'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // =================================================================
          // OPSI 1: PINDAI QRIS (KAMERA SCANNER)
          // =================================================================
          _buildScannerView(),

          // =================================================================
          // OPSI 2: TAMPILKAN KODE QR SAYA (DENGAN LOGO DI TENGAH)
          // =================================================================
          _buildMyQrView(user),
        ],
      ),
    );
  }

  // View Pemindai Kamera
  Widget _buildScannerView() {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 12),

          // Badge Instruksi
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.crop_free_rounded, color: Color(0xFF69F0AE), size: 16),
                const SizedBox(width: 8),
                Text(
                  'Arahkan kamera ke kode QRIS pembayaran',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Jendela Pemindai Kotak dengan Sudut Hijau Neon
          Center(
            child: Container(
              width: 270,
              height: 270,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.5),
              ),
              child: Stack(
                children: [
                  Positioned(top: 8, left: 8, child: _buildReticleCorner(isTop: true, isLeft: true)),
                  Positioned(top: 8, right: 8, child: _buildReticleCorner(isTop: true, isLeft: false)),
                  Positioned(bottom: 8, left: 8, child: _buildReticleCorner(isTop: false, isLeft: true)),
                  Positioned(bottom: 8, right: 8, child: _buildReticleCorner(isTop: false, isLeft: false)),

                  // Garis Laser Scanning Animasi Bergerak
                  AnimatedBuilder(
                    animation: _laserController,
                    builder: (context, child) {
                      return Positioned(
                        top: 20 + (_laserController.value * 230),
                        left: 20,
                        right: 20,
                        child: Container(
                          height: 3,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.transparent, Color(0xFF69F0AE), Colors.transparent],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF69F0AE).withOpacity(0.9),
                                blurRadius: 10,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          const Spacer(),

          // Toolbar Kontrol: Flash & Galeri
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildToolButton(
                icon: _isFlashOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
                label: _isFlashOn ? 'Flash Nyala' : 'Senter',
                isActive: _isFlashOn,
                onTap: () {
                  setState(() {
                    _isFlashOn = !_isFlashOn;
                  });
                },
              ),
              const SizedBox(width: 32),
              _buildToolButton(
                icon: Icons.image_rounded,
                label: 'Galeri',
                isActive: false,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Membuka galeri untuk scan QR...')),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Tombol Shutter Ambil Foto/Scan
          GestureDetector(
            onTap: _onCapture,
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF00BFA5), width: 3.5),
              ),
              child: Center(
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Color(0xFF00BFA5), Color(0xFF00897B)],
                    ),
                  ),
                  child: const Icon(Icons.qr_code_scanner_rounded, color: Colors.white, size: 28),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            'Ketuk tombol untuk memindai',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // View Kode QR Saya (Dengan Logo PundiGo di Tengah)
  Widget _buildMyQrView(dynamic user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        children: [
          // Kartu QR PundiGo dengan Logo di Tengah
          PundigoQrCard(
            userName: user.name,
            userPhone: user.phone,
            nominal: _customNominal,
            note: _customNominal != null ? 'Transfer ke Rekening PundiGo' : null,
            qrSize: 210,
          ),

          const SizedBox(height: 20),

          // Tombol Tindakan Cepat (Atur Nominal, Unduh, Bagikan)
          Row(
            children: [
              Expanded(
                child: _buildActionCard(
                  icon: Icons.edit_note_rounded,
                  label: _customNominal != null ? 'Ubah Nominal' : 'Atur Nominal',
                  color: const Color(0xFF00BFA5),
                  onTap: _showSetNominalDialog,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionCard(
                  icon: Icons.download_rounded,
                  label: 'Simpan QR',
                  color: const Color(0xFF3B82F6),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Kode QRIS PundiGo berhasil disimpan ke galeri!'),
                        backgroundColor: Color(0xFF059669),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionCard(
                  icon: Icons.share_rounded,
                  label: 'Bagikan',
                  color: const Color(0xFF8B5CF6),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Tautan pembayaran PundiGo disalin ke clipboard!'),
                        backgroundColor: Color(0xFF0284C7),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildToolButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFF00BFA5) : Colors.white.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.15)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReticleCorner({required bool isTop, required bool isLeft}) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        border: Border(
          top: isTop ? const BorderSide(color: Color(0xFF69F0AE), width: 4) : BorderSide.none,
          bottom: !isTop ? const BorderSide(color: Color(0xFF69F0AE), width: 4) : BorderSide.none,
          left: isLeft ? const BorderSide(color: Color(0xFF69F0AE), width: 4) : BorderSide.none,
          right: !isLeft ? const BorderSide(color: Color(0xFF69F0AE), width: 4) : BorderSide.none,
        ),
        borderRadius: BorderRadius.only(
          topLeft: isTop && isLeft ? const Radius.circular(8) : Radius.zero,
          topRight: isTop && !isLeft ? const Radius.circular(8) : Radius.zero,
          bottomLeft: !isTop && isLeft ? const Radius.circular(8) : Radius.zero,
          bottomRight: !isTop && !isLeft ? const Radius.circular(8) : Radius.zero,
        ),
      ),
    );
  }
}
