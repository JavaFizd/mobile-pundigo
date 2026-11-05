import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// ============================================================================
/// TOMBOL UTAMA PUNDIGO (GRADIENT & OUTLINE)
/// ============================================================================
/// Catatan untuk Dosen:
/// Tombol ini memiliki 2 varian:
/// 1. [AppButton.primary]: Tombol kapsul gradien Teal-Blue dengan teks putih
///    dan panah opsional (sesuai tombol "Lanjutkan ->" di Figma).
/// 2. [AppButton.outline]: Tombol dengan border dan background lembut
///    (sesuai tombol "Keluar Akun" di Figma).
/// ============================================================================
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool showArrow;
  final bool isLoading;
  final bool isOutlined;
  final Color? outlineColor;
  final Color? textColor;
  final double height;
  final double? width;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.showArrow = true,
    this.isLoading = false,
    this.isOutlined = false,
    this.outlineColor,
    this.textColor,
    this.height = 54,
    this.width,
  });

  factory AppButton.outline({
    Key? key,
    required String text,
    required VoidCallback? onPressed,
    Color? outlineColor,
    Color? textColor,
    bool showArrow = false,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,
      isOutlined: true,
      showArrow: showArrow,
      outlineColor: outlineColor ?? AppColors.danger.withOpacity(0.3),
      textColor: textColor ?? AppColors.danger,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null || isLoading;

    if (isOutlined) {
      return SizedBox(
        width: width ?? double.infinity,
        height: height,
        child: OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: outlineColor?.withOpacity(0.04) ?? Colors.transparent,
            side: BorderSide(color: outlineColor ?? AppColors.border, width: 1.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(height / 2),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: textColor ?? AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height / 2),
        gradient: isDisabled
            ? null
            : const LinearGradient(
                colors: [AppColors.primaryTeal, AppColors.primaryBlue],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
        color: isDisabled ? const Color(0xFFD1D5DB) : null,
        boxShadow: isDisabled
            ? null
            : [
                BoxShadow(
                  color: AppColors.primaryBlue.withOpacity(0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : onPressed,
          borderRadius: BorderRadius.circular(height / 2),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        text,
                        style: TextStyle(
                          color: isDisabled ? Colors.white70 : Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                      if (showArrow) ...[
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 18,
                          color: isDisabled ? Colors.white70 : Colors.white,
                        ),
                      ],
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
