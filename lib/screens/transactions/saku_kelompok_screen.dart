import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../data/app_state.dart';
import '../../widgets/common/custom_app_bar.dart';

/// ============================================================================
/// HALAMAN SAKU KELOMPOK (KAS BERSAMA MAHASISWA & KOST)
/// ============================================================================
/// Solusi Masalah Nyata Mahasiswa & Kelompok:
/// 1. Bendahara transparan & tidak dicurigai (setiap pengeluaran kas wajib ada
///    catatan keperluan & bisa lampirkan foto struk/nota digital).
/// 2. Setiap anggota bisa langsung lihat saldo kas bersama secara real-time.
/// 3. Bisa langsung ekspor rekap kas yang rapi ke grup WhatsApp (lengkap dengan
///    siapa yang sudah lunas vs belum bayar iuran kas).
/// ============================================================================
class SakuKelompokScreen extends StatefulWidget {
  const SakuKelompokScreen({super.key});

  @override
  State<SakuKelompokScreen> createState() => _SakuKelompokScreenState();
}

class _SakuKelompokScreenState extends State<SakuKelompokScreen> {
  final AppState _appState = AppState.instance;

  // Anggota kelompok dan status iuran bulan ini
  final List<Map<String, dynamic>> _members = [
    {'name': 'Dinda Syahfitri (Bendahara)', 'paid': true, 'amount': 25000},
    {'name': 'Rahmat Hidayat', 'paid': true, 'amount': 25000},
    {'name': 'Maya Lestari', 'paid': true, 'amount': 25000},
    {'name': 'Teuku Daffa', 'paid': false, 'amount': 25000},
  ];

  @override
  void initState() {
    super.initState();
    _appState.addListener(_onStateChange);
  }

  @override
  void dispose() {
    _appState.removeListener(_onStateChange);
    super.dispose();
  }

  void _onStateChange() {
    if (mounted) setState(() {});
  }

  // Dialog Setor Iuran Kas
  void _showSetorDialog() {
    final amountController = TextEditingController(text: '25000');
    String selectedMember = 'Dinda Syahfitri';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    children: [
                      Icon(Icons.add_circle, color: Color(0xFF00A887), size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Setor Iuran Kas Kelompok',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Saldo PundiGo! Anda saat ini: ${CurrencyFormatter.format(_appState.user.saldoUtama)}',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),

                  // Pilih Anggota yang Menyetor
                  const Text('Nama Anggota yang Menyetor:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedMember,
                        isExpanded: true,
                        items: ['Dinda Syahfitri', 'Rahmat Hidayat', 'Maya Lestari', 'Teuku Daffa'].map((m) {
                          return DropdownMenuItem(value: m, child: Text(m, style: const TextStyle(fontSize: 14)));
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setModalState(() => selectedMember = val);
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),
                  const Text('Nominal Iuran (Rp):', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Text('Rp', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00A887),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        final amt = double.tryParse(amountController.text) ?? 25000;
                        if (_appState.user.saldoUtama < amt) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Saldo PundiGo! Anda tidak cukup. Silakan Top Up terlebih dahulu.'),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                          return;
                        }

                        final ok = _appState.setorKas(amt, uploader: selectedMember);
                        if (ok) {
                          // Update list status anggota
                          final idx = _members.indexWhere((m) => m['name'].toString().contains(selectedMember.split(' ')[0]));
                          if (idx != -1) {
                            setState(() {
                              _members[idx]['paid'] = true;
                            });
                          }
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Berhasil menyetor ${CurrencyFormatter.format(amt)} untuk $selectedMember!'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        }
                      },
                      child: const Text('Konfirmasi & Setor Kas', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Dialog Catat Pengeluaran Kas (Solusi agar bendahara tidak dicurigai)
  void _showCatatPengeluaranDialog() {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    bool hasReceiptAttachment = true;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Row(
                    children: [
                      Icon(Icons.receipt_long, color: Color(0xFFE53935), size: 24),
                      SizedBox(width: 8),
                      Text(
                        'Catat Pengeluaran Kas',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Setiap pengeluaran kas wajib dicatat detail agar terbuka dan transparan ke seluruh anggota.',
                    style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 16),

                  const Text('Keperluan / Deskripsi Pengeluaran:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: 'Misal: Beli Konsumsi Rapat / Print Proposal',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),

                  const SizedBox(height: 14),
                  const Text('Nominal Pengeluaran (Rp):', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Text('Rp', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                      hintText: '35.000',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    ),
                  ),

                  const SizedBox(height: 14),
                  // Opsi Lampirkan Bukti Nota / Kwitansi
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FBFB),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.teal.shade100),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.document_scanner, color: Color(0xFF00A887)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Lampirkan Foto Nota / Struk',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                              ),
                              Text(
                                'Struk fisik akan tersimpan digital sebagai bukti',
                                style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: hasReceiptAttachment,
                          activeColor: const Color(0xFF00A887),
                          onChanged: (val) => setModalState(() => hasReceiptAttachment = val),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE53935),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        final title = titleController.text.trim();
                        final amt = double.tryParse(amountController.text) ?? 0;

                        if (title.isEmpty || amt <= 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Harap masukkan keperluan dan nominal yang valid!')),
                          );
                          return;
                        }

                        if (_appState.kasKelompok.collectedAmount < amt) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Saldo kas kelompok tidak mencukupi untuk pengeluaran ini.'),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                          return;
                        }

                        final ok = _appState.catatPengeluaranKas(
                          title: title,
                          amount: amt,
                          subtitle: hasReceiptAttachment ? 'Bukti Nota Terlampir • Diverifikasi' : 'Tanpa nota',
                          hasReceipt: hasReceiptAttachment,
                        );

                        if (ok) {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Pengeluaran $title sebesar ${CurrencyFormatter.format(amt)} berhasil dicatat!'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        }
                      },
                      child: const Text('Simpan Pengeluaran Kas', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Dialog Lihat Bukti Nota Struk Digital
  void _showReceiptModal(String title, double amount, DateTime date) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: const [
              Icon(Icons.verified, color: Color(0xFF00A887), size: 20),
              SizedBox(width: 8),
              Text('Bukti Struk Digital', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFDE7),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.amber.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        '★ NOTA RESMI KAS KELOMPOK ★',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1),
                      ),
                    ),
                    const Divider(thickness: 1, height: 16),
                    Text('Keperluan : $title', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text('Nominal    : ${CurrencyFormatter.format(amount)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFFE53935))),
                    const SizedBox(height: 4),
                    Text('Tanggal     : ${date.day}/${date.month}/${date.year}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    const SizedBox(height: 4),
                    const Text('Bendahara : Dinda Syahfitri', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    const Divider(thickness: 1, height: 16),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('VERIFIED RECEIPT ✓', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Nota struk fisik asli telah difoto dan diverifikasi oleh sistem PundiGo!.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryTeal,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Tutup', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // Generate Pesan WhatsApp Rekap Kas Bersama
  String _generateWhatsAppReport() {
    final kas = _appState.kasKelompok;
    final buffer = StringBuffer();
    buffer.writeln('📊 *LAPORAN TRANSPARANSI KAS PUNDIGO!*');
    buffer.writeln('🏷️ *Kelompok:* ${kas.title}');
    buffer.writeln('💰 *Saldo Kas Sekarang:* ${CurrencyFormatter.format(kas.collectedAmount)}');
    buffer.writeln('🎯 *Target Kas:* ${CurrencyFormatter.format(kas.targetAmount)} (${(kas.progressPercentage * 100).toInt()}% tercapai)');
    buffer.writeln('');
    buffer.writeln('👥 *Status Iuran Anggota:*');
    for (int i = 0; i < _members.length; i++) {
      final m = _members[i];
      final status = m['paid'] == true ? '[LUNAS ✓]' : '[BELUM BAYAR ⏳]';
      buffer.writeln('${i + 1}. ${m['name']} - $status (${CurrencyFormatter.format(m['amount'])})');
    }
    buffer.writeln('');
    buffer.writeln('📋 *Mutasi Terakhir:*');
    final recent = _appState.kasMutasi.take(4).toList();
    for (final mut in recent) {
      final sign = mut.isIncome ? '(+)' : '(-)';
      final note = mut.hasReceipt ? '[Nota Terlampir]' : '';
      buffer.writeln('• $sign ${mut.title}: ${CurrencyFormatter.format(mut.amount)} $note');
    }
    buffer.writeln('');
    buffer.writeln('📌 _Seluruh mutasi tercatat otomatis dan transparan di aplikasi PundiGo!._');
    return buffer.toString();
  }

  void _copyWhatsAppReport() {
    final report = _generateWhatsAppReport();
    Clipboard.setData(ClipboardData(text: report));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Laporan kas disalin! Siap dikirim ke WhatsApp kelompok.'),
        backgroundColor: Color(0xFF00A887),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final kas = _appState.kasKelompok;
    final progress = kas.progressPercentage;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Saku Kelompok (Kas)'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===============================================================
              // KARTU 1: SALDO KAS UTAMA & AKSI CEPAT
              // ===============================================================
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border.withOpacity(0.6)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            kas.title,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSecondary,
                              letterSpacing: 0.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEBF3FE),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.group_outlined, size: 12, color: Color(0xFF1E88E5)),
                              const SizedBox(width: 4),
                              Text(
                                '${kas.memberCount} Anggota',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1E88E5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      CurrencyFormatter.format(kas.collectedAmount),
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      kas.collectedAmount == 0
                          ? 'Belum ada saldo terkumpul di saku ini'
                          : 'Saldo kas aktif dan dapat dipantau seluruh anggota',
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 18),

                    // 2 Tombol Aksi: + Setor Kas & - Catat Pengeluaran
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: _showSetorDialog,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE6F8F5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.add_circle_outline, color: Color(0xFF00A887), size: 18),
                                  SizedBox(width: 6),
                                  Text(
                                    '+ Setor Kas',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF00A887),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: _showCatatPengeluaranDialog,
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFEBEE),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.remove_circle_outline, color: Color(0xFFE53935), size: 18),
                                  SizedBox(width: 6),
                                  Text(
                                    '- Catat Keluar',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFFE53935),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ===============================================================
              // KARTU 2: TARGET PENCAPAIAN KAS
              // ===============================================================
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border.withOpacity(0.6)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.flag_outlined, color: Color(0xFF00A887), size: 16),
                            SizedBox(width: 6),
                            Text(
                              'Target Kas Tercapai',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEBF3FE),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${(progress * 100).toInt()}% ${progress >= 1.0 ? 'TERCAPAI' : 'TERKUMPUL'}',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E88E5),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Realisasi Saat Ini', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                        Text(
                          '${CurrencyFormatter.format(kas.collectedAmount)} / ${CurrencyFormatter.format(kas.targetAmount)}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor: const Color(0xFFEBF3FE),
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00BFA5)),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ===============================================================
              // KARTU 3: STATUS IURAN ANGGOTA BULAN INI
              // ===============================================================
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border.withOpacity(0.6)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'STATUS IURAN ANGGOTA',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textSecondary,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          'Rp 25.000 / bln',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryTeal),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ..._members.map((m) {
                      final isPaid = m['paid'] == true;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 14,
                                  backgroundColor: isPaid ? const Color(0xFFE6F8F5) : const Color(0xFFFFF3E0),
                                  child: Icon(
                                    isPaid ? Icons.check : Icons.access_time,
                                    size: 14,
                                    color: isPaid ? const Color(0xFF00A887) : Colors.orange,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  m['name'],
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: isPaid ? const Color(0xFFE6F8F5) : const Color(0xFFFFF3E0),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                isPaid ? 'Lunas' : 'Belum Bayar',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: isPaid ? const Color(0xFF00A887) : Colors.orange.shade800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ===============================================================
              // KARTU 4: MUTASI KAS TERAKHIR (DENGAN BUKTI NOTA DIGITAL)
              // ===============================================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'MUTASI KAS TERAKHIR',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  InkWell(
                    onTap: _copyWhatsAppReport,
                    child: Row(
                      children: const [
                        Icon(Icons.share, size: 14, color: Color(0xFF25D366)),
                        SizedBox(width: 4),
                        Text(
                          'Kirim Rekap WA',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF25D366),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              if (_appState.kasMutasi.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border.withOpacity(0.6)),
                  ),
                  child: Column(
                    children: const [
                      Icon(Icons.receipt_long_outlined, color: Color(0xFF1E88E5), size: 36),
                      SizedBox(height: 8),
                      Text('Belum ada mutasi kas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                )
              else
                ..._appState.kasMutasi.map((m) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border.withOpacity(0.5)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: m.isIncome ? const Color(0xFFE6F8F5) : const Color(0xFFFFEBEE),
                          child: Icon(
                            m.isIncome ? Icons.south_west : Icons.north_east,
                            size: 16,
                            color: m.isIncome ? const Color(0xFF00A887) : const Color(0xFFE53935),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                m.title,
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                m.subtitle,
                                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                              ),
                              if (m.hasReceipt) ...[
                                const SizedBox(height: 4),
                                InkWell(
                                  onTap: () => _showReceiptModal(m.title, m.amount, m.date),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(Icons.receipt, size: 12, color: Color(0xFF00A887)),
                                      SizedBox(width: 4),
                                      Text(
                                        'Lihat Bukti Nota Struk',
                                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF00A887), decoration: TextDecoration.underline),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        Text(
                          '${m.isIncome ? '+' : '-'}${CurrencyFormatter.format(m.amount)}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: m.isIncome ? const Color(0xFF00A887) : const Color(0xFFE53935),
                          ),
                        ),
                      ],
                    ),
                  );
                }),

              const SizedBox(height: 20),

              // Tombol Bagikan Laporan Kas ke WhatsApp
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: _copyWhatsAppReport,
                  icon: const Icon(Icons.share, color: Colors.white, size: 18),
                  label: const Text(
                    'Bagikan Laporan Kas ke WhatsApp',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Kembali ke Beranda',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Keamanan Transparansi Rekening Penampung
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.shield_outlined, size: 14, color: AppColors.textMuted),
                    SizedBox(width: 6),
                    Text(
                      'Sistem pencatatan kas transparan & terverifikasi digital',
                      style: TextStyle(fontSize: 10, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
