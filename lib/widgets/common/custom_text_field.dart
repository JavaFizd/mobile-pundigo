import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ============================================================================
/// INPUT FIELD FORM PUNDIGO
/// ============================================================================
/// Catatan untuk Dosen:
/// Input field ini digunakan di form Registrasi, OTP, dan Transfer:
/// - Memiliki background lembut khas Figma (#F0F4FD).
/// - Mendukung prefix teks (+62) atau ikon (@, key) dengan pembatas vertikal.
/// - Tipografi Google Fonts Plus Jakarta Sans rapi & proporsional.
/// ============================================================================
class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final String? prefixText;
  final bool showPrefixDivider;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final bool readOnly;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
    this.prefixText,
    this.showPrefixDivider = false,
    this.suffixIcon,
    this.onChanged,
    this.validator,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label di atas Input Field
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13.5,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1E293B),
            letterSpacing: -0.2,
          ),
        ),
        const SizedBox(height: 8),

        // Kotak Input
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          obscuringCharacter: '●',
          readOnly: readOnly,
          onChanged: onChanged,
          validator: validator,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14.5,
            fontWeight: FontWeight.w500,
            letterSpacing: obscureText ? 3.0 : -0.1,
            color: const Color(0xFF1E293B),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF0F4FD),
            hintText: hintText,
            hintStyle: GoogleFonts.plusJakartaSans(
              color: const Color(0xFF94A3B8),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFF00BFA5), width: 1.5),
            ),
            prefixIcon: _buildPrefix(),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }

  Widget? _buildPrefix() {
    if (prefixText != null) {
      return IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 10),
              child: Text(
                prefixText!,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ),
            Container(
              width: 1.2,
              height: 18,
              color: const Color(0xFFCBD5E1),
            ),
            const SizedBox(width: 8),
          ],
        ),
      );
    } else if (prefixIcon != null) {
      if (showPrefixDivider) {
        return IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 10),
                child: prefixIcon,
              ),
              Container(
                width: 1.2,
                height: 18,
                color: const Color(0xFFCBD5E1),
              ),
              const SizedBox(width: 8),
            ],
          ),
        );
      }
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: prefixIcon,
      );
    }
    return null;
  }
}

