import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// ============================================================================
/// KEYBOARD NUMERIK KUSTOM (PIN & TRANSFER)
/// ============================================================================
/// Catatan untuk Dosen:
/// Keyboard virtual angka 0-9 dan tombol hapus (backspace).
/// Didesain persis seperti kartu tombol numpad di Figma PundiGo!.
/// ============================================================================
class NumericKeyboard extends StatelessWidget {
  final ValueChanged<String> onKeyPressed;
  final VoidCallback onDeletePressed;

  const NumericKeyboard({
    super.key,
    required this.onKeyPressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRow(['1', '2', '3']),
          const SizedBox(height: 10),
          _buildRow(['4', '5', '6']),
          const SizedBox(height: 10),
          _buildRow(['7', '8', '9']),
          const SizedBox(height: 10),
          _buildBottomRow(),
        ],
      ),
    );
  }

  static const Map<String, String> _subtitles = {
    '1': '',
    '2': 'ABC',
    '3': 'DEF',
    '4': 'GHI',
    '5': 'JKL',
    '6': 'MNO',
    '7': 'PQRS',
    '8': 'TUV',
    '9': 'WXYZ',
    '0': '+',
  };

  Widget _buildRow(List<String> digits) {
    return Row(
      children: digits.map((digit) {
        final sub = _subtitles[digit] ?? '';
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: _buildKey(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    digit,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      height: 1.1,
                    ),
                  ),
                  if (sub.isNotEmpty)
                    Text(
                      sub,
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMuted,
                        letterSpacing: 1.0,
                      ),
                    ),
                ],
              ),
              onTap: () => onKeyPressed(digit),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBottomRow() {
    return Row(
      children: [
        // Spasi kosong di kiri angka 0
        const Expanded(child: SizedBox()),

        // Angka 0
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: _buildKey(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    '0',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      height: 1.1,
                    ),
                  ),
                  Text(
                    '+',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              onTap: () => onKeyPressed('0'),
            ),
          ),
        ),

        // Tombol Backspace
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: _buildKey(
              backgroundColor: const Color(0xFFF0F4FD),
              child: const Icon(
                Icons.backspace_outlined,
                color: AppColors.textPrimary,
                size: 20,
              ),
              onTap: onDeletePressed,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKey({
    required Widget child,
    required VoidCallback onTap,
    Color backgroundColor = Colors.white,
  }) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(14),
      elevation: backgroundColor == Colors.white ? 1.5 : 0,
      shadowColor: Colors.black.withOpacity(0.08),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 52,
          alignment: Alignment.center,
          child: child,
        ),
      ),
    );
  }
}
