import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../data/app_state.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/numeric_keyboard.dart';
import 'plus_offer_screen.dart';

/// ============================================================================
/// HALAMAN PEMBUATAN & KONFIRMASI PIN KEAMANAN
/// ============================================================================
/// Catatan untuk Dosen:
/// - Sesuai desain 'MEMBUAT PIN.png' & 'KONFIRMASI ULANG PIN.png'.
/// - Terdiri dari 2 fase:
///   1. Buat PIN: Pengguna memasukkan 6 digit PIN pertama.
///   2. Konfirmasi PIN: Pengguna mengetik ulang PIN untuk verifikasi kecocokan.
/// - Setelah PIN dikonfirmasi cocok, memanggil [AppState.instance.registerNewUser]
///   untuk menginisialisasi akun baru murni dari awal dengan saldo Rp0!
/// ============================================================================
class PinScreen extends StatefulWidget {
  final String name;
  final String phone;
  final String email;
  final bool isCreatingPin;
  final String? originalPin;

  const PinScreen({
    super.key,
    this.name = 'Dinda Syahfitri',
    this.phone = '+62 825-0180-0288',
    this.email = 'alhamdulillah.dinda@gmail.com',
    this.isCreatingPin = true,
    this.originalPin,
  });

  @override
  State<PinScreen> createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  String _enteredPin = '';

  void _onDigitPressed(String digit) {
    if (_enteredPin.length < 6) {
      setState(() {
        _enteredPin += digit;
      });

      // Begitu mencapai 6 digit, otomatis proses
      if (_enteredPin.length == 6) {
        _processPin();
      }
    }
  }

  void _onDeletePressed() {
    if (_enteredPin.isNotEmpty) {
      setState(() {
        _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
      });
    }
  }

  void _quickFillPin() {
    final pinToFill = widget.isCreatingPin ? '170845' : (widget.originalPin ?? '170845');
    setState(() {
      _enteredPin = pinToFill;
    });
    _processPin();
  }

  void _processPin() {
    if (widget.isCreatingPin) {
      // Pindah ke halaman konfirmasi PIN
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => PinScreen(
                isCreatingPin: false,
                originalPin: _enteredPin,
                name: widget.name,
                phone: widget.phone,
                email: widget.email,
              ),
            ),
          );
        }
      });
    } else {
      // Verifikasi apakah PIN konfirmasi cocok dengan PIN awal
      if (_enteredPin == widget.originalPin) {
        // DAFTARKAN AKUN BARU DENGAN SALDO RP0 MURNI DARI AWAL
        AppState.instance.registerNewUser(
          name: widget.name,
          phone: widget.phone,
          email: widget.email,
          pin: _enteredPin,
        );

        // Berpindah ke Halaman Penawaran PundiGo! Plus (Sesuai Desain Figma: Penawaran PundiGo PLus.png)
        Future.delayed(const Duration(milliseconds: 250), () {
          if (mounted) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const PlusOfferScreen()),
            );
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PIN tidak cocok! Silakan coba lagi.'),
            backgroundColor: AppColors.danger,
          ),
        );
        setState(() {
          _enteredPin = '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isCreatingPin ? 'Buat PIN Akun' : 'Konfirmasi PIN Akun';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: title),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Column(
                  children: [
                    // Banner Gradien Biru dengan Gembok 3D (Sesuai Figma)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00BFA5), Color(0xFF1E88E5)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 54,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Gagang Gembok
                                Positioned(
                                  top: 8,
                                  child: Container(
                                    width: 22,
                                    height: 18,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                      border: Border.all(color: Colors.white, width: 3),
                                    ),
                                  ),
                                ),
                                // Badan Gembok Putih Bersih
                                Positioned(
                                  bottom: 8,
                                  child: Container(
                                    width: 32,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(7),
                                      boxShadow: [
                                        BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 6),
                                      ],
                                    ),
                                    alignment: Alignment.center,
                                    child: Container(
                                      width: 6,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF00A887),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.isCreatingPin
                                      ? 'Buat PIN Transaksi 6 Digit'
                                      : 'Konfirmasi Ulang PIN Kamu',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.isCreatingPin
                                      ? 'PIN digunakan untuk mengamankan setiap transaksi dan login ke akun PundiGo! kamu.'
                                      : 'Masukkan kembali 6 digit PIN yang baru saja kamu buat untuk memastikan kecocokan sandi transaksi.',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white.withOpacity(0.92),
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Tips Keamanan Pill (Sesuai Figma)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F1FD),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.help_outline_rounded, color: Color(0xFF00897B), size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.isCreatingPin
                                  ? 'Hindari tanggal lahir, nomor telepon, atau angka berurutan'
                                  : 'Pastikan kamu tidak lupa dengan pin kamu sendiri',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF334155),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // 6 Kotak Digit PIN (Warna Mint Toska Khas Figma)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(6, (index) {
                        final isFilled = index < _enteredPin.length;
                        final digit = isFilled ? _enteredPin[index] : '';

                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          width: 44,
                          height: 54,
                          decoration: BoxDecoration(
                            color: isFilled
                                ? const Color(0xFF72E4D4)
                                : const Color(0xFFE6F8F5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isFilled ? const Color(0xFF00BFA5) : const Color(0xFFB2DFDB),
                              width: 1.5,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            isFilled ? digit : '•',
                            style: TextStyle(
                              fontSize: isFilled ? 20 : 26,
                              fontWeight: FontWeight.w800,
                              color: isFilled ? const Color(0xFF0F172A) : const Color(0xFF80CBC4),
                            ),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 14),

                    // Tombol Bantuan Simulasi Cepat
                    InkWell(
                      onTap: _quickFillPin,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6F8F5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF00BFA5).withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.bolt_rounded, size: 14, color: Color(0xFF00A887)),
                            const SizedBox(width: 4),
                            Text(
                              widget.isCreatingPin
                                  ? 'Simulasi Cepat (Isi 170845)'
                                  : 'Cocokkan PIN Cepat (170845)',
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF00A887),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    const Text(
                      'Gunakan kombinasi angka yang tidak mudah ditebak',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (!widget.isCreatingPin)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Ubah PIN sebelumnya',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryTeal,
                    ),
                  ),
                ),
              ),

            // Keyboard Virtual Numerik Khas Figma
            NumericKeyboard(
              onKeyPressed: _onDigitPressed,
              onDeletePressed: _onDeletePressed,
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
