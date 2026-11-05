import 'package:flutter/material.dart';

/// ============================================================================
/// PUNDIGO DESIGN SYSTEM - COLOR PALETTE
/// ============================================================================
/// Panduan untuk Dosen/Pengembang:
/// - Jika ingin mengganti warna utama (brand color) aplikasi, cukup ubah
///   nilai [primaryTeal] atau [primaryBlue] di bawah ini.
/// - Seluruh tombol, header gradient, dan aksen akan otomatis berubah.
/// ============================================================================
class AppColors {
  // Brand Gradients & Accents
  static const Color primaryTeal = Color(0xFF00BFA5);
  static const Color primaryBlue = Color(0xFF1E88E5);
  static const Color cyanAccent  = Color(0xFF00B0FF);

  // Gradient Utama (Digunakan di Header Saldo & Tombol Aksi Utama)
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryTeal, primaryBlue],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // Gradient Kartu & Promo
  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF00B496), Color(0xFF1877F2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Background & Surface
  static const Color background = Color(0xFFF7FAFD);
  static const Color surface    = Color(0xFFFFFFFF);
  static const Color inputFill  = Color(0xFFF0F4FD);

  // Typography Colors
  static const Color textPrimary   = Color(0xFF1E293B); // Slate 800 (Judul & Teks Tebal)
  static const Color textSecondary = Color(0xFF64748B); // Slate 500 (Subjudul)
  static const Color textMuted     = Color(0xFF94A3B8); // Slate 400 (Hint & Teks Nonaktif)

  // Functional & Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFFF9800);
  static const Color danger  = Color(0xFFEF4444);

  // Tint / Soft Backgrounds (Untuk icon container & badges)
  static const Color mintLight  = Color(0xFFE6F8F5);
  static const Color blueLight  = Color(0xFFEBF3FE);
  static const Color orangeLight = Color(0xFFFFF3E0);
  static const Color redLight   = Color(0xFFFEE2E2);

  // Border & Divider
  static const Color border = Color(0xFFE2E8F0);
}
