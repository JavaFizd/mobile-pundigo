import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../data/app_state.dart';
import '../../models/user_model.dart';
import '../common/user_avatar.dart';

/// ============================================================================
/// MODAL PILIH / UBAH FOTO PROFIL PUNDIGO!
/// ============================================================================
/// Menyediakan pilihan:
/// 1. Pilihan koleksi avatar preset berkualitas tinggi
/// 2. Masukkan link URL foto kustom
/// 3. Hapus foto -> Otomatis kembali menggunakan inisial nama (misal: "AW")
/// ============================================================================
class PhotoPickerModal extends StatelessWidget {
  final UserModel user;
  final ValueChanged<String?> onPhotoSelected;

  const PhotoPickerModal({
    super.key,
    required this.user,
    required this.onPhotoSelected,
  });

  static const List<Map<String, String>> presetAvatars = [
    {
      'label': 'Profesional',
      'url': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
    },
    {
      'label': 'Casual Pria',
      'url': 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?auto=format&fit=crop&w=400&q=80',
    },
    {
      'label': 'Modern Hijab',
      'url': 'https://images.unsplash.com/photo-1567532939604-b6b5b0db2604?auto=format&fit=crop&w=400&q=80',
    },
    {
      'label': 'Tech Enthusiast',
      'url': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=400&q=80',
    },
    {
      'label': 'Kreatif',
      'url': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=400&q=80',
    },
    {
      'label': 'Fintech 3D',
      'url': 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=400&q=80',
    },
  ];

  static Future<void> show(BuildContext context, {required UserModel user, required ValueChanged<String?> onPhotoSelected}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => PhotoPickerModal(
        user: user,
        onPhotoSelected: onPhotoSelected,
      ),
    );
  }

  void _showCustomUrlDialog(BuildContext context) {
    final controller = TextEditingController(text: user.photoUrl ?? '');
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Tautan Foto Kustom',
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 18),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Tempelkan tautan (URL) gambar JPG/PNG online untuk foto profil kamu:',
                style: GoogleFonts.plusJakartaSans(fontSize: 13, color: const Color(0xFF64748B)),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: controller,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'https://...',
                  filled: true,
                  fillColor: const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryTeal,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                final text = controller.text.trim();
                Navigator.of(ctx).pop(); // Tutup dialog
                Navigator.of(context).pop(); // Tutup bottom sheet
                if (text.isNotEmpty) {
                  onPhotoSelected(text);
                }
              },
              child: const Text('Terapkan Foto', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final initials = UserModel.computeInitials(user.name);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle Bar
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Header
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: Color(0xFFE6F8F5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  color: Color(0xFF00A887),
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pilih Foto Profil',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Pilih foto baru atau gunakan inisial nama otomatis',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          // Pilihan 1: Kembali ke Inisial Nama Otomatis (Sistem)
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
              onPhotoSelected(null); // Menghapus foto profil -> inisial otomatis
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: !user.hasPhoto ? const Color(0xFF00BFA5) : const Color(0xFFE2E8F0),
                  width: !user.hasPhoto ? 1.8 : 1,
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: const Color(0xFFDCE4FD),
                    child: Text(
                      initials,
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF00796B),
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Gunakan Inisial Nama Saja',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE6F8F5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'OTOMATIS',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF00A887),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Contoh: "${user.name}" otomatis menjadi inisial "$initials"',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!user.hasPhoto)
                    const Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF00A887),
                      size: 22,
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          // Pilihan 2: Koleksi Avatar Siap Pakai
          Text(
            'Koleksi Foto & Avatar Siap Pakai',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 12),

          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: presetAvatars.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (ctx, index) {
                final preset = presetAvatars[index];
                final url = preset['url']!;
                final isSelected = user.photoUrl == url;

                return InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    onPhotoSelected(url);
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? const Color(0xFF00BFA5) : const Color(0xFFCBD5E1),
                                width: isSelected ? 2.5 : 1,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 26,
                              backgroundImage: NetworkImage(url),
                              backgroundColor: const Color(0xFFE2E8F0),
                            ),
                          ),
                          if (isSelected)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check_circle_rounded,
                                  color: Color(0xFF00BFA5),
                                  size: 16,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        preset['label']!,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? const Color(0xFF00A887) : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Pilihan 3: Input Tautan Foto Kustom
          InkWell(
            onTap: () => _showCustomUrlDialog(context),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.link_rounded, color: Color(0xFF00796B), size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Gunakan Tautan Foto Sendiri (URL)',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF334155),
                      ),
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8), size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

