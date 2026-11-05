import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/utils/currency_formatter.dart';
import '../../data/app_state.dart';
import '../../widgets/common/plus_upgrade_dialog.dart';
import 'topup_success_screen.dart';

/// ============================================================================
/// HALAMAN PUSAT LAYANAN TOP UP PUNDIGO
/// ============================================================================
/// Menyediakan 3 kategori Top Up:
/// 1. [🏪 Tunai di Gerai (Indomaret)]: 100% Persis Figma 'Tahapan top up di indomaret.png'
///    Pilihan nominal: Rp 50.000 s/d Rp 500.000 (kelipatan 50rb).
/// 2. [📱 Pulsa & Paket Data (Telkomsel)]: Pilihan pulsa mulai Rp 10.000 s/d Rp 100.000.
/// 3. [⚡ Token Listrik PLN]: Proteksi khusus akun PundiGo Plus.
/// ============================================================================
class TopupScreen extends StatefulWidget {
  final int initialTabIndex; // 0: Indomaret, 1: Pulsa, 2: Token Listrik

  const TopupScreen({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  State<TopupScreen> createState() => _TopupScreenState();
}

class _TopupScreenState extends State<TopupScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AppState _appState = AppState.instance;

  // State Top Up Indomaret (Pilihan 50rb s/d 500rb)
  double _selectedIndomaretNominal = 100000;
  final List<double> _indomaretNominals = [
    50000,
    100000,
    150000,
    200000,
    250000,
    300000,
    350000,
    400000,
    450000,
    500000,
  ];

  // State Pulsa (Mulai 10rb s/d 100rb)
  final TextEditingController _phoneController = TextEditingController(text: '0822-7718-2910');
  double _selectedPulsaAmount = 50000;
  String _selectedPulsaTitle = 'Pulsa Reguler Rp 50.000';

  final List<Map<String, dynamic>> _pulsaList = [
    {'nominal': 10000.0, 'title': 'Pulsa 10.000', 'desc': 'Masa aktif 15 hari'},
    {'nominal': 20000.0, 'title': 'Pulsa 20.000', 'desc': 'Masa aktif 20 hari'},
    {'nominal': 25000.0, 'title': 'Pulsa 25.000', 'desc': 'Masa aktif 30 hari'},
    {'nominal': 30000.0, 'title': 'Pulsa 30.000', 'desc': 'Masa aktif 30 hari'},
    {'nominal': 40000.0, 'title': 'Pulsa 40.000', 'desc': 'Masa aktif 35 hari'},
    {'nominal': 50000.0, 'title': 'Pulsa 50.000', 'desc': 'Masa aktif 45 hari'},
    {'nominal': 60000.0, 'title': 'Pulsa 60.000', 'desc': 'Masa aktif 50 hari'},
    {'nominal': 70000.0, 'title': 'Pulsa 70.000', 'desc': 'Masa aktif 55 hari'},
    {'nominal': 75000.0, 'title': 'Pulsa 75.000', 'desc': 'Masa aktif 60 hari'},
    {'nominal': 80000.0, 'title': 'Pulsa 80.000', 'desc': 'Masa aktif 60 hari'},
    {'nominal': 90000.0, 'title': 'Pulsa 90.000', 'desc': 'Masa aktif 60 hari'},
    {'nominal': 100000.0, 'title': 'Pulsa 100.000', 'desc': 'Masa aktif 60 hari'},
  ];

  // State PLN
  final TextEditingController _meterController = TextEditingController(text: '142388910023');
  double _selectedPlnAmount = 50000;

  @override
  void initState() {
    super.initState();
    _appState.addListener(_onStateChange);
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
    _tabController.addListener(() {
      setState(() {});
    });
  }

  void _onStateChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _appState.removeListener(_onStateChange);
    _tabController.dispose();
    _phoneController.dispose();
    _meterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Top Up',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 18),
            child: Image.asset(
              'assets/images/logo_pg_exact.png',
              width: 28,
              height: 28,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.account_balance_wallet_rounded,
                color: Color(0xFF00A887),
                size: 24,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // TAB SELECTOR KATEGORI TOP UP
            Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 6),
              height: 46,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(16),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                labelColor: const Color(0xFF0F172A),
                labelStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
                unselectedLabelColor: const Color(0xFF64748B),
                unselectedLabelStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
                tabs: const [
                  Tab(text: '🏪 Indomaret'),
                  Tab(text: '📱 Pulsa & Data'),
                  Tab(text: '⚡ Listrik PLN'),
                ],
              ),
            ),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // KATEGORI 1: INDOMARET
                  _buildIndomaretTab(),

                  // KATEGORI 2: PULSA & DATA
                  _buildPulsaTab(),

                  // KATEGORI 3: TOKEN LISTRIK PLN
                  _buildPlnTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // TAB 1: INDOMARET (50RB s/d 500RB)
  // ===========================================================================
  Widget _buildIndomaretTab() {
    const cashierCode = 'PG - 8821 - 9901';
    const barcodeNumber = '8  8  2  1  9  9  0  1  0  5  9  6';

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Isi Saldo Indomaret',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // KARTU KODE PEMBAYARAN KASIR & BARCODE
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Kode Pembayaran Kasir',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SelectableText(
                        cashierCode,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0F172A),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Barcode 1D
                      const _BarcodeWidget(),

                      const SizedBox(height: 10),
                      Text(
                        barcodeNumber,
                        style: GoogleFonts.spaceMono(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF475569),
                          letterSpacing: 2,
                        ),
                      ),

                      const SizedBox(height: 22),

                      // Badge Timer 55 Menit
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF2FF),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.timer_outlined,
                              size: 15,
                              color: Color(0xFF4F46E5),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Berlaku hingga 55 menit lagi',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF4F46E5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // PILIHAN NOMINAL TOP UP (50RB s/d 500RB)
                Text(
                  'Pilih Nominal Top Up Tunai',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 10),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _indomaretNominals.map((nom) {
                    final isSelected = _selectedIndomaretNominal == nom;
                    return InkWell(
                      onTap: () {
                        setState(() => _selectedIndomaretNominal = nom);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFE8F8F5) : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF00A887) : const Color(0xFFE2E8F0),
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: [
                            if (isSelected)
                              BoxShadow(
                                color: const Color(0xFF00A887).withOpacity(0.15),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                          ],
                        ),
                        child: Text(
                          CurrencyFormatter.format(nom),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                            color: isSelected ? const Color(0xFF00796B) : const Color(0xFF1E293B),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 18),

                // KARTU RINCIAN PEMBAYARAN
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Bayar ke Kasir',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                          Text(
                            CurrencyFormatter.format(_selectedIndomaretNominal),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF00796B),
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(color: Color(0xFFF1F5F9), height: 1),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Biaya Layanan',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF64748B),
                            ),
                          ),
                          Text(
                            'Rp0 (Gratis Promo)',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF00A887),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // KARTU PETUNJUK PEMBAYARAN DI GERAI
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFF1F5F9), width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Petunjuk Pembayaran di Gerai:',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 14),
                      _buildStep(1, 'Sampaikan ke kasir Indomaret untuk pembayaran tagihan e-wallet PundiGo.'),
                      const SizedBox(height: 12),
                      _buildStep(2, 'Tunjukkan barcode di layar ponsel atau sebutkan kode pembayaran kasir.'),
                      const SizedBox(height: 12),
                      _buildStep(
                        3,
                        'Bayar tunai ${CurrencyFormatter.format(_selectedIndomaretNominal)} dan simpan struk pembayaran hingga saldo masuk.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // TOMBOL LANJUT
        Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, -4)),
            ],
          ),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00BFA5), Color(0xFF2979FF)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00BFA5).withOpacity(0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  _appState.topUpSaldo(_selectedIndomaretNominal, method: 'Indomaret');
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => TopupSuccessScreen(amount: _selectedIndomaretNominal),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Lanjut Bayar • ${CurrencyFormatter.format(_selectedIndomaretNominal)}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // TAB 2: PULSA (MULAI 10RB s/d 100RB)
  // ===========================================================================
  Widget _buildPulsaTab() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Input Nomor HP
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFF1F5F9)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nomor Telepon Tujuan',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Row(
                          children: [
                            Image.asset('assets/images/logo_telkomsel.png', height: 18, fit: BoxFit.contain),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF0F172A),
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                            Text(
                              'Telkomsel',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFEF4444),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  'Pilihan Pulsa (10rb - 100rb)',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 10),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: _pulsaList.length,
                  itemBuilder: (context, index) {
                    final item = _pulsaList[index];
                    final nominal = item['nominal'] as double;
                    final title = item['title'] as String;
                    final desc = item['desc'] as String;
                    final isSelected = _selectedPulsaAmount == nominal;

                    return InkWell(
                      onTap: () {
                        setState(() {
                          _selectedPulsaAmount = nominal;
                          _selectedPulsaTitle = title;
                        });
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFE8F8F5) : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF00A887) : const Color(0xFFE2E8F0),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              title,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: isSelected ? const Color(0xFF00796B) : const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(desc, style: GoogleFonts.plusJakartaSans(fontSize: 10, color: const Color(0xFF64748B))),
                            const SizedBox(height: 4),
                            Text(
                              CurrencyFormatter.format(nominal),
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF00A887),
                              ),
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

        // TOMBOL BELI PULSA
        Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, -4)),
            ],
          ),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00BFA5), Color(0xFF2979FF)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00BFA5).withOpacity(0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  if (_appState.user.saldoUtama < _selectedPulsaAmount) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Saldo tidak mencukupi (${CurrencyFormatter.format(_appState.user.saldoUtama)}). Lakukan Top Up saldo terlebih dahulu.',
                        ),
                        backgroundColor: const Color(0xFFEF4444),
                      ),
                    );
                    return;
                  }

                  _appState.beliPulsa(
                    amount: _selectedPulsaAmount,
                    phone: _phoneController.text,
                    packageName: _selectedPulsaTitle,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Pembelian $_selectedPulsaTitle Berhasil!'),
                      backgroundColor: const Color(0xFF00A887),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  'Beli Pulsa Sekarang • ${CurrencyFormatter.format(_selectedPulsaAmount)}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // TAB 3: TOKEN LISTRIK PLN (DENGAN PROTEKSI PLUS)
  // ===========================================================================
  Widget _buildPlnTab() {
    final isPlus = _appState.user.isPlus;

    if (!isPlus) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFFFEF3C7),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lock_rounded,
                color: Color(0xFFD97706),
                size: 44,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Fitur Eksklusif PundiGo Plus',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Pembelian Token Listrik PLN hanya dapat dilakukan oleh pengguna akun PundiGo Plus terverifikasi (KTP & Wajah).',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: const Color(0xFF64748B),
                height: 1.45,
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00BFA5), Color(0xFF2979FF)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00BFA5).withOpacity(0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    PlusUpgradeDialog.show(context, featureName: 'Beli Token Listrik PLN');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    'Upgrade ke PundiGo Plus',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    final List<Map<String, dynamic>> plnNominals = [
      {'nominal': 20000.0, 'kwh': '±13.5 kWh'},
      {'nominal': 50000.0, 'kwh': '±34.8 kWh'},
      {'nominal': 100000.0, 'kwh': '±70.2 kWh'},
      {'nominal': 200000.0, 'kwh': '±141.5 kWh'},
      {'nominal': 500000.0, 'kwh': '±354.0 kWh'},
    ];

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFF1F5F9)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset('assets/images/logo_pln.png', height: 20, fit: BoxFit.contain),
                          const SizedBox(width: 8),
                          Text(
                            'Nomor Meter / ID Pelanggan PLN',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: TextField(
                          controller: _meterController,
                          keyboardType: TextInputType.number,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '✔ Pelanggan: M. FAHMI ARDIANSYAH (R1M / 900 VA)',
                        style: GoogleFonts.plusJakartaSans(fontSize: 11, color: const Color(0xFF16A34A)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Text(
                  'Pilih Nominal Token',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 10),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.6,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: plnNominals.length,
                  itemBuilder: (context, index) {
                    final item = plnNominals[index];
                    final nominal = item['nominal'] as double;
                    final kwh = item['kwh'] as String;
                    final isSelected = _selectedPlnAmount == nominal;

                    return InkWell(
                      onTap: () {
                        setState(() => _selectedPlnAmount = nominal);
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFE8F8F5) : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF00A887) : const Color(0xFFE2E8F0),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              CurrencyFormatter.format(nominal),
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: isSelected ? const Color(0xFF00796B) : const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '⚡ $kwh',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF64748B),
                              ),
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

        // TOMBOL BELI TOKEN PLN
        Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, -4)),
            ],
          ),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00BFA5), Color(0xFF2979FF)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00BFA5).withOpacity(0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  if (_appState.user.saldoUtama < _selectedPlnAmount) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Saldo tidak mencukupi (${CurrencyFormatter.format(_appState.user.saldoUtama)}). Lakukan Top Up saldo terlebih dahulu.',
                        ),
                        backgroundColor: const Color(0xFFEF4444),
                      ),
                    );
                    return;
                  }

                  const generatedToken = '2910 - 8491 - 0482 - 7719 - 8820';
                  _appState.bayarTokenListrik(
                    amount: _selectedPlnAmount,
                    idPelanggan: _meterController.text,
                    tokenCode: generatedToken,
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pembelian Token PLN Sukses! Stroom: 2910-8491-0482-7719-8820'),
                      backgroundColor: Color(0xFF00A887),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  'Beli Token Sekarang • ${CurrencyFormatter.format(_selectedPlnAmount)}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep(int number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: const BoxDecoration(
            color: Color(0xFFEBF5FF),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$number',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF2563EB),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF475569),
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}

/// Custom Barcode 1D Painter persis seperti di Figma
class _BarcodeWidget extends StatelessWidget {
  const _BarcodeWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      width: 220,
      child: CustomPaint(
        painter: _BarcodePainter(),
      ),
    );
  }
}

class _BarcodePainter extends CustomPainter {
  static const List<double> barPattern = [
    2.5, 2.0, 1.2, 3.0, 1.5, 2.5, 1.2, 3.2, 2.0, 1.2,
    3.0, 1.5, 2.0, 3.5, 1.2, 2.5, 1.5, 3.0, 1.2, 2.0,
    3.2, 1.5, 2.0, 1.2, 3.0, 2.5, 1.2, 2.0, 3.5, 1.5,
    1.2, 2.5, 3.0, 1.2, 2.0, 3.2, 1.5, 2.0, 1.2, 3.0,
    2.5, 1.2, 2.0, 3.5, 1.5, 2.0, 1.2, 3.0, 2.5, 1.2,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0F172A)
      ..style = PaintingStyle.fill;

    double currentX = 0;
    bool isBar = true;

    for (int i = 0; i < barPattern.length && currentX < size.width; i++) {
      final width = barPattern[i];
      if (isBar) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(currentX, 0, width, size.height),
            const Radius.circular(0.8),
          ),
          paint,
        );
      }
      currentX += width + 1.8;
      isBar = !isBar;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
