import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../data/app_state.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/numeric_keyboard.dart';
import 'transaction_history_screen.dart';
import 'transfer_confirm_screen.dart';
import '../../widgets/common/plus_upgrade_dialog.dart';

/// ============================================================================
/// HALAMAN TRANSFER MULTI-TUJUAN PUNDIGO
/// ============================================================================
/// Menyediakan 3 opsi transfer terpadu:
/// 1. Sesama PundiGo (Nomor HP & Nama Kontak Terverifikasi)
/// 2. Rekening Bank (Khusus Bank Aceh & Bank Syariah Indonesia / BSI)
/// 3. E-Wallet (Khusus GoPay & DANA)
///
/// Seluruh logo resmi ditampilkan secara terintegrasi rapi (bukan tempelan),
/// dengan border responsif, badge verifikasi, dan keypad numerik instan.
/// ============================================================================
class TransferScreen extends StatefulWidget {
  final int initialTabIndex; // 0: Sesama, 1: Bank, 2: E-Wallet

  const TransferScreen({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final AppState _appState = AppState.instance;

  // Controllers
  final TextEditingController _pundigoPhoneController = TextEditingController(text: '0825-0180-1800');
  final TextEditingController _bankAccountController = TextEditingController(text: '010.02.04.123456-7');
  final TextEditingController _ewalletPhoneController = TextEditingController(text: '0812-3456-7890');

  // Selected Bank & E-Wallet
  int _selectedBankIndex = 0; // 0: Bank Aceh, 1: BSI
  int _selectedEwalletIndex = 0; // 0: GoPay, 1: DANA

  String _nominalString = '100000';
  double get _nominal => double.tryParse(_nominalString) ?? 0;

  final List<Map<String, String>> _bankList = [
    {
      'name': 'Bank Aceh Syariah',
      'shortName': 'Bank Aceh',
      'logo': 'assets/images/logo_bank_aceh.png',
      'account': '010.02.04.123456-7',
      'recipient': 'CUT NYAK MEUTIA',
      'desc': 'BI-FAST Bebas Biaya',
    },
    {
      'name': 'Bank Syariah Indonesia (BSI)',
      'shortName': 'BSI',
      'logo': 'assets/images/logo_bank_bsi.png',
      'account': '7123456789',
      'recipient': 'MUHAMMAD DAFFA',
      'desc': 'Online Instan 24 Jam',
    },
  ];

  final List<Map<String, String>> _ewalletList = [
    {
      'name': 'GoPay Indonesia',
      'shortName': 'GoPay',
      'logo': 'assets/images/logo_gopay.png',
      'phone': '0812-3456-7890',
      'recipient': 'RAHMAT HIDAYAT',
      'desc': 'GoPay Plus Terverifikasi',
    },
    {
      'name': 'DANA Dompet Digital',
      'shortName': 'DANA',
      'logo': 'assets/images/logo_dana.png',
      'phone': '0852-9876-5432',
      'recipient': 'SITI AMINAH',
      'desc': 'DANA Premium Aktif',
    },
  ];

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
    _pundigoPhoneController.dispose();
    _bankAccountController.dispose();
    _ewalletPhoneController.dispose();
    super.dispose();
  }

  void _onDigitPressed(String digit) {
    if (_nominalString.length < 9) {
      setState(() {
        if (_nominalString == '0') {
          _nominalString = digit;
        } else {
          _nominalString += digit;
        }
      });
    }
  }

  void _onDeletePressed() {
    setState(() {
      if (_nominalString.length > 1) {
        _nominalString = _nominalString.substring(0, _nominalString.length - 1);
      } else {
        _nominalString = '0';
      }
    });
  }

  void _setQuickNominal(double amount) {
    setState(() {
      _nominalString = amount.toInt().toString();
    });
  }

  void _proceedToConfirm() {
    if (!_appState.user.isPlus) {
      PlusUpgradeDialog.show(context, featureName: 'Transfer ke Bank & E-Wallet');
      return;
    }

    if (_nominal <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan nominal transfer terlebih dahulu.'),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }

    if (_nominal > _appState.user.saldoUtama) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Saldo PundiGo tidak mencukupi untuk transfer ini.'),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }

    String recipientName;
    String destinationType;
    String destinationName;
    String accountOrPhone;
    String? logoAsset;

    final tabIndex = _tabController.index;
    if (tabIndex == 0) {
      // Sesama PundiGo
      destinationType = 'PundiGo';
      destinationName = 'PundiGo! Pay';
      recipientName = 'Naufal Daffa';
      accountOrPhone = _pundigoPhoneController.text;
      logoAsset = 'assets/images/logo_pg_mark_hd.png';
    } else if (tabIndex == 1) {
      // Bank Aceh atau BSI
      final bank = _bankList[_selectedBankIndex];
      destinationType = 'Bank';
      destinationName = bank['name']!;
      recipientName = bank['recipient']!;
      accountOrPhone = _bankAccountController.text;
      logoAsset = bank['logo'];
    } else {
      // GoPay atau DANA
      final ewallet = _ewalletList[_selectedEwalletIndex];
      destinationType = 'E-Wallet';
      destinationName = ewallet['name']!;
      recipientName = ewallet['recipient']!;
      accountOrPhone = _ewalletPhoneController.text;
      logoAsset = ewallet['logo'];
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TransferConfirmScreen(
          recipientName: recipientName,
          destinationType: destinationType,
          destinationName: destinationName,
          accountOrPhone: accountOrPhone,
          logoAsset: logoAsset,
          amount: _nominal,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = _appState.user;

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
          'Transfer',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Riwayat Transfer',
            icon: const Icon(Icons.history_rounded, color: Color(0xFF1E293B), size: 22),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const TransactionHistoryScreen(initialTabIndex: 2)),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!user.isPlus)
                      Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFFDE68A)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.lock_rounded, color: Color(0xFFD97706), size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Fitur Transfer memerlukan akun PundiGo Plus.',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF92400E),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => PlusUpgradeDialog.show(context, featureName: 'Transfer Saldo'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD97706),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Upgrade',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // =========================================================
                    // TAB SELECTOR 3 KATEGORI TRANSFER (PROMINENT, LEGA & JELAS)
                    // =========================================================
                    Container(
                      height: 52,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9), // Slate-100 bersih dan terang
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 2),
                        indicator: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0F172A).withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        labelColor: const Color(0xFF007A63), // PundiGo Emerald Teal
                        labelStyle: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                        ),
                        unselectedLabelColor: const Color(0xFF475569), // Slate-600 tegas & jelas terbaca
                        unselectedLabelStyle: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.2,
                        ),
                        tabs: [
                          Tab(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/logo_pg_mark_hd.png',
                                    width: 17,
                                    height: 17,
                                    fit: BoxFit.contain,
                                  ),
                                  const SizedBox(width: 6),
                                  const Text('PundiGo'),
                                ],
                              ),
                            ),
                          ),
                          const Tab(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.account_balance_rounded, size: 18),
                                  SizedBox(width: 6),
                                  Text('Bank'),
                                ],
                              ),
                            ),
                          ),
                          const Tab(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.account_balance_wallet_rounded, size: 18),
                                  SizedBox(width: 6),
                                  Text('E-Wallet Lain'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // KARTU SALDO PENGGUNA
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFF1F5F9)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F8F5),
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFFA7F3D0)),
                            ),
                            child: Image.asset(
                              'assets/images/logo_pg_mark_hd.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Saldo PundiGo Aktif',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    color: const Color(0xFF64748B),
                                  ),
                                ),
                                Text(
                                  CurrencyFormatter.format(user.saldoUtama),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF0F172A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEF2FF),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              'Bebas Admin',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF4F46E5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // FORM SESUAI TAB
                    if (_tabController.index == 0) ...[
                      // TAB 0: SESAMA PUNDIGO
                      _buildPundigoSection(),
                    ] else if (_tabController.index == 1) ...[
                      // TAB 1: TRANSFER KE BANK (BANK ACEH & BSI)
                      _buildBankSection(),
                    ] else ...[
                      // TAB 2: TRANSFER KE E-WALLET (GOPAY & DANA)
                      _buildEwalletSection(),
                    ],

                    const SizedBox(height: 16),

                    // KOTAK NOMINAL TRANSFER & QUICK CHIPS
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFF1F5F9)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Nominal Transfer',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.check_circle, color: Color(0xFF10B981), size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Biaya Admin: Rp0 (Gratis)',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF059669),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            CurrencyFormatter.format(_nominal),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Quick Chips
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [50000.0, 100000.0, 250000.0, 500000.0].map((amt) {
                              final isCurrent = _nominal == amt;
                              return ActionChip(
                                label: Text(
                                  CurrencyFormatter.format(amt),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
                                    color: isCurrent ? Colors.white : const Color(0xFF0F172A),
                                  ),
                                ),
                                backgroundColor: isCurrent ? const Color(0xFF00A887) : const Color(0xFFF1F5F9),
                                side: BorderSide.none,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                onPressed: () => _setQuickNominal(amt),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // KEYBOARD NUMERIK
            NumericKeyboard(
              onKeyPressed: _onDigitPressed,
              onDeletePressed: _onDeletePressed,
            ),

            // TOMBOL LANJUT
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 16),
              child: AppButton(
                text: 'Lanjut',
                onPressed: _proceedToConfirm,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET TAB 0: SESAMA PUNDIGO
  Widget _buildPundigoSection() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Resmi PundiGo Transfer Sesama
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE6F8F5), Color(0xFFEBF3FE)],
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF6CFBCB).withOpacity(0.6)),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Image.asset('assets/images/logo_pg_mark_hd.png', fit: BoxFit.contain),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'PundiGo! Pay',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Icon(Icons.verified, size: 14, color: Color(0xFF00A887)),
                        ],
                      ),
                      Text(
                        'Transfer instan antar akun PundiGo! • Bebas Biaya Admin',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Text(
            'Nomor HP PundiGo Penerima',
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
                Expanded(
                  child: TextField(
                    controller: _pundigoPhoneController,
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
                TextButton(
                  onPressed: () {
                    setState(() => _pundigoPhoneController.text = '0825-0180-1800');
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFE8F8F5),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(
                    'Tempel',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF00A887),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // User Card Preview Resmi PundiGo
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFBBF7D0)),
            ),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD1FAE5),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      'ND',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF065F46),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Naufal Daffa',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF166534),
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.verified, color: Color(0xFF16A34A), size: 14),
                        ],
                      ),
                      Text(
                        '0825-0180-1800 • Akun PundiGo Terverifikasi',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: const Color(0xFF15803D),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET TAB 1: TRANSFER REKENING BANK (BANK ACEH & BSI)
  Widget _buildBankSection() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pilih Bank Tujuan (Resmi)',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 12),

          // 2 Pilihan Bank: Bank Aceh & BSI
          Row(
            children: List.generate(_bankList.length, (index) {
              final bank = _bankList[index];
              final isSelected = _selectedBankIndex == index;

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: index == 0 ? 8 : 0, left: index == 1 ? 8 : 0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedBankIndex = index;
                        _bankAccountController.text = bank['account']!;
                      });
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      height: 78,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFE8F8F5) : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF00A887) : const Color(0xFFE2E8F0),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Image.asset(
                              bank['logo']!,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => Text(
                                bank['shortName']!,
                                style: const TextStyle(fontWeight: FontWeight.w800),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            bank['shortName']!,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                              color: isSelected ? const Color(0xFF00796B) : const Color(0xFF475569),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 16),

          Text(
            'Nomor Rekening Tujuan',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: TextField(
              controller: _bankAccountController,
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

          const SizedBox(height: 10),

          // Bank Account Preview
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFBBF7D0)),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _bankList[_selectedBankIndex]['recipient']!,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF166534),
                        ),
                      ),
                      Text(
                        '${_bankList[_selectedBankIndex]['name']} • ${_bankList[_selectedBankIndex]['desc']}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: const Color(0xFF15803D),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET TAB 2: TRANSFER KE E-WALLET (GOPAY & DANA)
  Widget _buildEwalletSection() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pilih Dompet Digital (Resmi)',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 12),

          // 2 Pilihan E-Wallet: GoPay & DANA
          Row(
            children: List.generate(_ewalletList.length, (index) {
              final ewallet = _ewalletList[index];
              final isSelected = _selectedEwalletIndex == index;

              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: index == 0 ? 8 : 0, left: index == 1 ? 8 : 0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedEwalletIndex = index;
                        _ewalletPhoneController.text = ewallet['phone']!;
                      });
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      height: 78,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFFE8F8F5) : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF00A887) : const Color(0xFFE2E8F0),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Image.asset(
                              ewallet['logo']!,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => Text(
                                ewallet['shortName']!,
                                style: const TextStyle(fontWeight: FontWeight.w800),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            ewallet['shortName']!,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                              color: isSelected ? const Color(0xFF00796B) : const Color(0xFF475569),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 16),

          Text(
            'Nomor HP E-Wallet Terdaftar',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: TextField(
              controller: _ewalletPhoneController,
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

          const SizedBox(height: 10),

          // E-Wallet Preview
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFBBF7D0)),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Color(0xFF16A34A), size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _ewalletList[_selectedEwalletIndex]['recipient']!,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF166534),
                        ),
                      ),
                      Text(
                        '${_ewalletList[_selectedEwalletIndex]['name']} • ${_ewalletList[_selectedEwalletIndex]['desc']}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: const Color(0xFF15803D),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
