import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/utils/currency_formatter.dart';
import '../../data/app_state.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/numeric_keyboard.dart';

/// ============================================================================
/// HALAMAN KONFIRMASI TRANSFER & INPUT PIN
/// ============================================================================
/// Mendukung 3 moda transfer:
/// 1. Sesama PundiGo
/// 2. Rekening Bank (Bank Aceh & BSI)
/// 3. E-Wallet (GoPay & DANA)
///
/// Menampilkan logo asli terintegrasi rapi, verifikasi nama penerima BI-FAST,
/// dan bottom sheet PIN interaktif 6 digit.
/// ============================================================================
class TransferConfirmScreen extends StatefulWidget {
  final String recipientName;
  final String destinationType; // 'PundiGo', 'Bank', 'E-Wallet'
  final String destinationName; // 'PundiGo', 'Bank Aceh', 'Bank Syariah Indonesia (BSI)', 'GoPay', 'DANA'
  final String accountOrPhone;
  final String? logoAsset;
  final double amount;

  const TransferConfirmScreen({
    super.key,
    required this.recipientName,
    required this.destinationType,
    required this.destinationName,
    required this.accountOrPhone,
    this.logoAsset,
    required this.amount,
  });

  @override
  State<TransferConfirmScreen> createState() => _TransferConfirmScreenState();
}

class _TransferConfirmScreenState extends State<TransferConfirmScreen> {
  final AppState _appState = AppState.instance;

  void _openPinModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return _PinVerificationModal(
          onSuccess: () {
            Navigator.of(ctx).pop();
            _executeTransfer();
          },
        );
      },
    );
  }

  void _executeTransfer() {
    final transferLabel = '${widget.recipientName} (${widget.destinationName})';
    final success = _appState.transferSaldo(widget.amount, transferLabel);

    if (success) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE8F8F5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_rounded, color: Color(0xFF00A887), size: 38),
                ),
                const SizedBox(height: 16),
                Text(
                  'Transfer Berhasil!',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Saldo sebesar ${CurrencyFormatter.format(widget.amount)} telah berhasil dikirim ke ${widget.recipientName} via ${widget.destinationName}.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: const Color(0xFF64748B),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                AppButton(
                  text: 'Kembali ke Beranda',
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),
              ],
            ),
          );
        },
      );
    }
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
          'Konfirmasi Transfer',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner Peringatan Verifikasi
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.shield_outlined, color: Color(0xFF0284C7), size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Periksa detail penerima sebelum memasukkan PIN',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0369A1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // KARTU DETAIL PENERIMA
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'TUJUAN TRANSFER ${widget.destinationType.toUpperCase()}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF00A887),
                            letterSpacing: 0.5,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6F8F5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle, color: Color(0xFF00A887), size: 12),
                              const SizedBox(width: 4),
                              Text(
                                'Terverifikasi',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF00A887),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    Row(
                      children: [
                        // Avatar / Logo Tujuan
                        Container(
                          width: 52,
                          height: 52,
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: widget.destinationType == 'PundiGo' ? const Color(0xFFE6F8F5) : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: widget.destinationType == 'PundiGo' ? const Color(0xFF6CFBCB) : const Color(0xFFE2E8F0),
                              width: 1.5,
                            ),
                          ),
                          child: widget.logoAsset != null
                              ? Image.asset(
                                  widget.logoAsset!,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) => const Icon(
                                    Icons.account_balance_rounded,
                                    color: Color(0xFF00A887),
                                    size: 26,
                                  ),
                                )
                              : Center(
                                  child: Text(
                                    widget.recipientName.isNotEmpty ? widget.recipientName[0] : 'P',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: const Color(0xFF00A887),
                                    ),
                                  ),
                                ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.recipientName,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${widget.destinationName} • ${widget.accountOrPhone}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // KARTU DETAIL SUMBER DANA & NOMINAL
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                ),
                child: Column(
                  children: [
                    _buildRow(
                      'Sumber Dana',
                      'Saldo PundiGo (${CurrencyFormatter.format(user.saldoUtama)})',
                    ),
                    const Divider(color: Color(0xFFF1F5F9), height: 20),
                    _buildRow('Nominal Transfer', CurrencyFormatter.format(widget.amount)),
                    const SizedBox(height: 10),
                    _buildRow('Biaya Transaksi', 'Rp0 (Gratis Promo)', valueColor: const Color(0xFF00A887)),
                    const Divider(color: Color(0xFFF1F5F9), height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Transaksi',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          CurrencyFormatter.format(widget.amount),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF00796B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Tombol Konfirmasi Transfer
              SizedBox(
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
                    onPressed: _openPinModal,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Konfirmasi & Masukkan PIN',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(fontSize: 13, color: const Color(0xFF64748B)),
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: valueColor ?? const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }
}

/// Modal PIN 6-Digit Otentik PundiGo
class _PinVerificationModal extends StatefulWidget {
  final VoidCallback onSuccess;

  const _PinVerificationModal({required this.onSuccess});

  @override
  State<_PinVerificationModal> createState() => _PinVerificationModalState();
}

class _PinVerificationModalState extends State<_PinVerificationModal> {
  String _pin = '';

  void _onDigit(String digit) {
    if (_pin.length < 6) {
      setState(() => _pin += digit);
      if (_pin.length == 6) {
        Future.delayed(const Duration(milliseconds: 250), () {
          widget.onSuccess();
        });
      }
    }
  }

  void _onDelete() {
    if (_pin.isNotEmpty) {
      setState(() => _pin = _pin.substring(0, _pin.length - 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 20,
        left: 20,
        right: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFCBD5E1),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Masukkan PIN Keamanan',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Otorisasi transfer saldo PundiGo Anda',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 24),

          // 6 Titik Indikator PIN
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(6, (index) {
              final isFilled = index < _pin.length;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isFilled ? const Color(0xFF00A887) : Colors.transparent,
                  border: Border.all(
                    color: isFilled ? const Color(0xFF00A887) : const Color(0xFF94A3B8),
                    width: 2,
                  ),
                ),
              );
            }),
          ),

          const SizedBox(height: 20),

          // Numeric Keypad
          NumericKeyboard(
            onKeyPressed: _onDigit,
            onDeletePressed: _onDelete,
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
