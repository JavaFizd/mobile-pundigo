import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ============================================================================
/// HALAMAN PUSAT BANTUAN & STATUS PROYEK
/// ============================================================================
/// Menyajikan informasi transparan bahwa aplikasi PundiGo! merupakan
/// tugas proyek / prototipe akademik dan belum diawasi oleh OJK/BI.
/// ============================================================================
class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF0F172A), size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Pusat Bantuan',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0F172A),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =================================================================
            // 1. BANNER UTAMA STATUS PENGEMBANGAN & PERINGATAN OJK
            // =================================================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFF59E0B)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.school_rounded, color: Color(0xFFF59E0B), size: 13),
                            const SizedBox(width: 5),
                            Text(
                              'PROYEK AKADEMIK KAMPUS',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFFF59E0B),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'PundiGo! Masih Dalam Tahap Pengembangan',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.3,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Aplikasi ini dibangun sebagai pemenuhan tugas proyek dan riset antarmuka finansial (UI/UX). Aplikasi ini BELUM DIAWASI oleh Otoritas Jasa Keuangan (OJK) maupun Bank Indonesia (BI). Seluruh nominal saldo, mutasi kas, dan data transaksi di dalamnya adalah SIMULASI (Sandbox Demo).',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      color: const Color(0xFF94A3B8),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.shield_outlined, color: Color(0xFF00BFA5), size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Tidak ada uang riil yang ditarik dari rekening pengguna.',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11.5,
                              color: const Color(0xFFE2E8F0),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // =================================================================
            // 2. FAQ TANYA JAWAB UMUM
            // =================================================================
            Text(
              'Pertanyaan yang Sering Diajukan (FAQ)',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 12),

            _buildFaqItem(
              icon: Icons.account_balance_wallet_rounded,
              question: 'Apakah saldo PundiGo bisa dicairkan ke uang asli?',
              answer: 'Karena ini prototipe tugas proyek, saldo yang ditampilkan adalah saldo simulasi untuk mendemonstrasikan kelancaran fitur transfer dan pembayaran.',
            ),
            _buildFaqItem(
              icon: Icons.workspace_premium_rounded,
              question: 'Bagaimana cara mencoba Akun Plus untuk presentasi?',
              answer: 'Kamu bisa menyelesaikan alur KYC (KTP & Wajah) atau langsung tekan tombol "⚡ Aktivasi Instan (Mode Demo)" saat peringatan upgrade muncul.',
            ),
            _buildFaqItem(
              icon: Icons.group_work_rounded,
              question: 'Bagaimana cara kerja Patungan Pintar?',
              answer: 'Kamu bisa membagi rata total tagihan atau mencatat menu makanan masing-masing. PundiGo akan menghitung pajak secara otomatis dan menyiapkan pesan rincian siap kirim ke WhatsApp teman.',
            ),
            _buildFaqItem(
              icon: Icons.savings_rounded,
              question: 'Apa fungsi fitur Saku Kelompok?',
              answer: 'Saku Kelompok berfungsi sebagai rekening kas transparan bersama teman kelompok, panitia, atau kost agar bendahara tidak dicurigai.',
            ),

            const SizedBox(height: 20),

            // =================================================================
            // 3. KONTAK TIM PENGEMBANG PROYEK
            // =================================================================
            Text(
              'Hubungi Tim Pengembang Mahasiswa',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  _buildContactRow(
                    icon: Icons.chat_rounded,
                    color: const Color(0xFF25D366),
                    title: 'WhatsApp Tim Pengembang',
                    subtitle: '+62 822-7718-2910 (Demo CS 24/7)',
                  ),
                  const Divider(height: 20, color: Color(0xFFF1F5F9)),
                  _buildContactRow(
                    icon: Icons.mail_rounded,
                    color: const Color(0xFF2563EB),
                    title: 'Email Proyek PundiGo',
                    subtitle: 'pundigo.fintech.project@gmail.com',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem({
    required IconData icon,
    required String question,
    required String answer,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Theme(
        data: ThemeData().copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFE6F8F5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF00A887), size: 18),
          ),
          title: Text(
            question,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Text(
                answer,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: const Color(0xFF64748B),
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactRow({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11.5,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
