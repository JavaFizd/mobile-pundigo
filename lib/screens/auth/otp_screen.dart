import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/numeric_keyboard.dart';
import 'pin_screen.dart';

/// ============================================================================
/// HALAMAN VERIFIKASI KODE OTP
/// ============================================================================
/// Catatan untuk Dosen:
/// - Sesuai desain 'VERIVIKASI OTP (...).png' di Figma.
/// - Menampilkan 6 kotak input PIN OTP dengan auto-focus antar kotak.
/// - Terdapat timer hitung mundur untuk pengiriman ulang kode.
/// - Disediakan tombol 'Simulasi Cepat OTP' agar dosen dapat langsung menguji
///   alur verifikasi secara cepat tanpa menunggu SMS sungguhan.
/// ============================================================================
class OtpScreen extends StatefulWidget {
  final String name;
  final String phoneNumber;
  final String email;
  final String method;

  const OtpScreen({
    super.key,
    this.name = 'Dinda Syahfitri',
    required this.phoneNumber,
    this.email = 'alhamdulillah.dinda@gmail.com',
    this.method = 'WhatsApp',
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String _enteredOtp = '';
  int _countdown = 41;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  void _onDigitPressed(String digit) {
    if (_enteredOtp.length < 6) {
      setState(() {
        _enteredOtp += digit;
      });

      if (_enteredOtp.length == 6) {
        _verifyOtp();
      }
    }
  }

  void _onDeletePressed() {
    if (_enteredOtp.isNotEmpty) {
      setState(() {
        _enteredOtp = _enteredOtp.substring(0, _enteredOtp.length - 1);
      });
    }
  }

  void _quickFillOtp() {
    setState(() {
      _enteredOtp = '123456';
    });
    _verifyOtp();
  }

  void _verifyOtp() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PinScreen(
              isCreatingPin: true,
              name: widget.name,
              phone: widget.phoneNumber,
              email: widget.email,
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Verifikasi OTP'),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    const Text(
                      'Masukkan Kode OTP',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      'Kode verifikasi 6 digit telah dikirimkan ke\n${widget.method} nomor',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Pill Nomor HP (Sesuai Figma)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border.withOpacity(0.8)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            widget.method == 'WhatsApp'
                                ? Icons.chat_bubble_rounded
                                : Icons.sms_rounded,
                            color: const Color(0xFF00BFA5),
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            widget.phoneNumber,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            '•',
                            style: TextStyle(color: AppColors.textMuted),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: Row(
                              children: const [
                                Text(
                                  'Ubah Nomor',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF00A887),
                                  ),
                                ),
                                SizedBox(width: 3),
                                Icon(Icons.edit_outlined, size: 13, color: Color(0xFF00A887)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 36),

                    // 6 Kotak Digit OTP (Sesuai Figma)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(6, (index) {
                        final isFilled = index < _enteredOtp.length;
                        final isCurrent = index == _enteredOtp.length;
                        final digit = isFilled ? _enteredOtp[index] : '';

                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          width: 44,
                          height: 54,
                          decoration: BoxDecoration(
                            color: isCurrent
                                ? const Color(0xFF00BFA5)
                                : (isFilled ? const Color(0xFF72E4D4) : const Color(0xFFF0F4FD)),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isCurrent
                                  ? const Color(0xFF00BFA5)
                                  : (isFilled ? const Color(0xFF00BFA5) : Colors.transparent),
                              width: 1.5,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: isCurrent
                              ? Container(
                                  width: 2,
                                  height: 22,
                                  color: Colors.white,
                                )
                              : Text(
                                  isFilled ? digit : '•',
                                  style: TextStyle(
                                    fontSize: isFilled ? 20 : 26,
                                    fontWeight: FontWeight.w800,
                                    color: isFilled
                                        ? const Color(0xFF0F172A)
                                        : const Color(0xFFB0BEC5),
                                  ),
                                ),
                        );
                      }),
                    ),

                    const SizedBox(height: 16),

                    // Tombol Bantuan Simulasi Cepat
                    InkWell(
                      onTap: _quickFillOtp,
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
                          children: const [
                            Icon(Icons.bolt_rounded, size: 14, color: Color(0xFF00A887)),
                            SizedBox(width: 4),
                            Text(
                              'Simulasi Cepat (Isi 123456)',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF00A887),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Pill Timer Hitung Mundur (Sesuai Figma)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F1FD),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.access_time_rounded, color: AppColors.textSecondary, size: 15),
                          const SizedBox(width: 6),
                          Text(
                            _countdown > 0
                                ? 'Kirim ulang kode dalam 00:${_countdown.toString().padLeft(2, '0')}'
                                : 'Kirim ulang kode sekarang',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Link Kirim via SMS / WhatsApp
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Tidak menerima pesan? ',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Kode OTP baru telah dikirimkan.'),
                                backgroundColor: Color(0xFF00A887),
                              ),
                            );
                          },
                          child: Text(
                            widget.method == 'WhatsApp' ? 'Kirim via SMS →' : 'Kirim via WhatsApp →',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF00A887),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
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
