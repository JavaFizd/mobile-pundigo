import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/user_model.dart';

/// ============================================================================
/// KOMPONEN AVATAR PENGGUNA PUNDIGO!
/// ============================================================================
/// Otomatis mendukung:
/// 1. Tampilan foto profil jika pengguna mengunggah / memilih foto (URL, Asset, Base64).
/// 2. Jika pengguna TIDAK memakai foto, sistem otomatis menampilkan INISIAL nama
///    (Contoh: "Arman Wijaya" -> "AW", "Dinda Syahfitri" -> "DS").
/// 3. Indikator kamera untuk tombol ganti foto di Edit Profil.
/// 4. Indikator centang verifikasi untuk Akun PundiGo! Plus.
/// ============================================================================
class UserAvatar extends StatelessWidget {
  final UserModel user;
  final double radius;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final VoidCallback? onTap;
  final bool showCameraBadge;
  final bool showPlusBadge;
  final String? overrideInitials;

  const UserAvatar({
    super.key,
    required this.user,
    this.radius = 22,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.onTap,
    this.showCameraBadge = false,
    this.showPlusBadge = false,
    this.overrideInitials,
  });

  @override
  Widget build(BuildContext context) {
    final initials = overrideInitials ?? user.initials;
    final defaultBg = user.isPlus ? const Color(0xFFE6F8F5) : const Color(0xFFDCE4FD);
    final defaultText = user.isPlus ? const Color(0xFF00796B) : const Color(0xFF1E88E5);

    Widget avatarContent;

    if (user.hasPhoto) {
      final photo = user.photoUrl!.trim();
      ImageProvider? imgProvider;

      if (photo.startsWith('http://') || photo.startsWith('https://')) {
        imgProvider = NetworkImage(photo);
      } else if (photo.startsWith('assets/')) {
        imgProvider = AssetImage(photo);
      } else if (photo.startsWith('data:image') || photo.length > 100) {
        try {
          final cleanBase64 = photo.contains(',') ? photo.split(',').last : photo;
          imgProvider = MemoryImage(base64Decode(cleanBase64));
        } catch (_) {
          imgProvider = null;
        }
      }

      if (imgProvider != null) {
        avatarContent = CircleAvatar(
          radius: radius,
          backgroundColor: backgroundColor ?? defaultBg,
          backgroundImage: imgProvider,
          onBackgroundImageError: (_, __) {},
        );
      } else {
        avatarContent = _buildInitials(initials, defaultBg, defaultText);
      }
    } else {
      avatarContent = _buildInitials(initials, defaultBg, defaultText);
    }

    Widget decoratedAvatar = avatarContent;

    // Bingkai gradien khusus akun Plus jika diinginkan
    if (showPlusBadge && user.isPlus) {
      decoratedAvatar = Container(
        padding: const EdgeInsets.all(2.5),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Color(0xFF00BFA5), Color(0xFF1E88E5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: decoratedAvatar,
      );
    }

    Widget finalWidget = Stack(
      clipBehavior: Clip.none,
      children: [
        decoratedAvatar,

        // Badge Kamera (Untuk layar Edit Profil)
        if (showCameraBadge)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: radius * 0.7,
              height: radius * 0.7,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00BFA5), Color(0xFF00897B)],
                ),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.camera_alt_rounded,
                color: Colors.white,
                size: radius * 0.36,
              ),
            ),
          ),

        // Badge Centang Verifikasi Plus
        if (showPlusBadge && user.isPlus)
          Positioned(
            bottom: -2,
            right: -2,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Container(
                width: 18,
                height: 18,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF00BFA5), Color(0xFF1E88E5)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified_rounded,
                  color: Colors.white,
                  size: 13,
                ),
              ),
            ),
          ),
      ],
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius * 2),
        child: finalWidget,
      );
    }

    return finalWidget;
  }

  Widget _buildInitials(String initials, Color defaultBg, Color defaultText) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? defaultBg,
      child: Text(
        initials,
        style: GoogleFonts.plusJakartaSans(
          color: textColor ?? defaultText,
          fontWeight: FontWeight.w800,
          fontSize: fontSize ?? (radius * 0.8),
        ),
      ),
    );
  }
}

