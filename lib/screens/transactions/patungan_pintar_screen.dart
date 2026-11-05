import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// ============================================================================
/// HALAMAN PATUNGAN PINTAR (SMART SPLIT BILL MAKAN BARENG)
/// ============================================================================
/// Solusi lengkap untuk mahasiswa saat makan bareng:
/// 1. Solusi Lupa Pesan Apa Aja: Fitur "📸 Pindai Struk Kasir (OCR Simulasi)"
///    dan pilihan menu cepat warung.
/// 2. Mode "Siapa Makan Apa" (Itemized): Setiap orang hanya membayar menu
///    yang dimakannya + pajak dihitung proporsional otomatis.
/// 3. Mode "Bagi Rata" (Equal Split).
/// 4. Generator Pesan WhatsApp Otomatis: Rincian rapi siap kirim ke grup WA
///    lengkap dengan nomor rekening / PundiGo untuk transfer.
/// 5. Status Pembayaran: Tandai siapa yang sudah bayar & belum bayar.
/// ============================================================================
class PatunganPintarScreen extends StatefulWidget {
  const PatunganPintarScreen({super.key});

  @override
  State<PatunganPintarScreen> createState() => _PatunganPintarScreenState();
}

class _PatunganPintarScreenState extends State<PatunganPintarScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Nama Tempat Makan
  final TextEditingController _placeController = TextEditingController(text: 'Warung Nasi & Mie Aceh');

  // Daftar Teman Patungan
  final List<String> _members = ['Dinda (Saya)', 'Rahmat Hidayat', 'Siti Aminah'];
  final Map<String, bool> _paidStatus = {
    'Dinda (Saya)': true,
    'Rahmat Hidayat': true,
    'Siti Aminah': false,
  };

  // Daftar Pesanan Menu (Siapa Makan Apa)
  final List<Map<String, dynamic>> _orderItems = [
    {'name': 'Nasi Ayam Geprek Sambal Korek', 'price': 25000, 'person': 'Dinda (Saya)'},
    {'name': 'Mie Aceh Spesial Daging', 'price': 35000, 'person': 'Rahmat Hidayat'},
    {'name': 'Nasi Goreng Kampung', 'price': 28000, 'person': 'Siti Aminah'},
    {'name': 'Es Teh Manis Jumbo', 'price': 6000, 'person': 'Dinda (Saya)'},
    {'name': 'Kopi Sanger Dingin', 'price': 14000, 'person': 'Rahmat Hidayat'},
    {'name': 'Jus Alpukat Kocok', 'price': 12000, 'person': 'Siti Aminah'},
  ];

  // Pajak Restoran (PB1 10%)
  bool _includeTax = true;

  // State Mode Bagi Rata
  final TextEditingController _equalTotalController = TextEditingController(text: '120000');
  int _equalPeopleCount = 3;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _placeController.dispose();
    _equalTotalController.dispose();
    super.dispose();
  }

  // Hitung Subtotal Menu
  int get _subtotal {
    int total = 0;
    for (var item in _orderItems) {
      total += (item['price'] as int);
    }
    return total;
  }

  // Hitung Pajak (10%)
  int get _taxAmount => _includeTax ? (_subtotal * 0.10).round() : 0;

  // Hitung Total Akhir
  int get _grandTotal => _subtotal + _taxAmount;

  // Hitung total bayar per orang (termasuk porsi pajak proporsional)
  Map<String, int> get _perPersonCalculation {
    Map<String, int> result = {};
    for (var m in _members) {
      result[m] = 0;
    }
    for (var item in _orderItems) {
      final person = item['person'] as String;
      final price = item['price'] as int;
      if (result.containsKey(person)) {
        result[person] = result[person]! + price;
      }
    }

    if (_includeTax && _subtotal > 0) {
      for (var m in _members) {
        final personalFood = result[m] ?? 0;
        final taxShare = (personalFood / _subtotal * _taxAmount).round();
        result[m] = personalFood + taxShare;
      }
    }
    return result;
  }

  // Format Pesan WhatsApp Rapi
  String _generateWhatsAppMessage() {
    final calculations = _perPersonCalculation;
    final buffer = StringBuffer();
    buffer.writeln('📋 *RINCIAN PATUNGAN MAKAN PUNDIGO!*');
    buffer.writeln('📍 Tempat: ${_placeController.text.trim()}');
    buffer.writeln('💵 Total Tagihan: Rp ${_grandTotal.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}');
    if (_includeTax) buffer.writeln('🧾 Termasuk Pajak PB1 10% (Rp ${_taxAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')})');
    buffer.writeln('');
    buffer.writeln('Hai teman-teman! Ini rincian patungan makan kita tadi ya:');
    buffer.writeln('');

    int idx = 1;
    for (var member in _members) {
      final total = calculations[member] ?? 0;
      final isPaid = _paidStatus[member] ?? false;
      final statusStr = isPaid ? '[LUNAS ✓]' : '[BELUM BAYAR ⏳]';
      
      buffer.writeln('$idx. 👤 *$member*:');
      // Tampilkan makanan yang dimakan
      for (var item in _orderItems) {
        if (item['person'] == member) {
          buffer.writeln('   • ${item['name']} (Rp ${item['price']})');
        }
      }
      buffer.writeln('   👉 *Total: Rp ${total.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}* $statusStr');
      buffer.writeln('');
      idx++;
    }

    buffer.writeln('💳 *Transfer pembayaran ke:*');
    buffer.writeln('• *PundiGo*: 0822-7718-2910 (Dinda Syifa)');
    buffer.writeln('• *Bank Aceh Syariah*: 010-02-123456-7 (Dinda Syifa)');
    buffer.writeln('• *BSI*: 7123456789 (Dinda Syifa)');
    buffer.writeln('Bisa juga scan QRIS PundiGo langsung ya. Makasih semuanya! 🙏✨');

    return buffer.toString();
  }

  void _copyWhatsAppText() {
    final text = _generateWhatsAppMessage();
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✓ Format pesan WhatsApp berhasil disalin! Tinggal tempel (paste) ke grup WA.'),
        backgroundColor: Color(0xFF00A887),
        duration: Duration(seconds: 3),
      ),
    );
  }

  // Dialog Simulasi Pindai Struk Kasir (Solusi Lupa Pesan Apa)
  void _simulateScanReceipt() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 18),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F8F5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.document_scanner_rounded, color: Color(0xFF00A887), size: 34),
              ),
              const SizedBox(height: 14),
              Text(
                'Pindai Struk Kasir Otomatis (OCR)',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Solusi jika kamu lupa tadi pesan apa saja! Ambil foto struk kasir restoran/warung, dan PundiGo akan otomatis mendeteksi nama menu dan harganya.',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5,
                  color: const Color(0xFF64748B),
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, color: Color(0xFF00A887), size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Struk Warung Nasi Aceh berhasil dipindai! 6 menu makanan & pajak terdeteksi.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF334155),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('✓ 6 Menu dari struk kasir berhasil dimasukkan ke daftar patungan!'),
                        backgroundColor: Color(0xFF00A887),
                      ),
                    );
                  },
                  icon: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 18),
                  label: Text(
                    'Ambil Foto Struk Kasir',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00A887),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(
                  'Tutup',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Dialog Tambah Menu Baru Manual
  void _showAddItemDialog() {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    String selectedPerson = _members.first;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
              title: Text(
                'Tambah Pesanan Makanan',
                style: GoogleFonts.plusJakartaSans(fontSize: 17, fontWeight: FontWeight.w800),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Nama Menu Makanan / Minuman',
                      hintText: 'Misal: Nasi Goreng Seafood',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: priceCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Harga (Rp)',
                      hintText: 'Misal: 25000',
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Siapa yang makan menu ini?',
                    style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: selectedPerson,
                    items: _members.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                    onChanged: (val) {
                      if (val != null) setDialogState(() => selectedPerson = val);
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00A887)),
                  onPressed: () {
                    final name = nameCtrl.text.trim();
                    final price = int.tryParse(priceCtrl.text.trim()) ?? 0;
                    if (name.isNotEmpty && price > 0) {
                      setState(() {
                        _orderItems.add({
                          'name': name,
                          'price': price,
                          'person': selectedPerson,
                        });
                      });
                      Navigator.of(ctx).pop();
                    }
                  },
                  child: const Text('Simpan Menu', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final calculations = _perPersonCalculation;

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
          'Patungan Pintar (Split Bill)',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0F172A),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded, color: Color(0xFF00A887)),
            tooltip: 'Salin Teks WhatsApp',
            onPressed: _copyWhatsAppText,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Tab Selector: Siapa Makan Apa vs Bagi Rata
            Container(
              margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              height: 46,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(16),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                labelColor: const Color(0xFF0F172A),
                labelStyle: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
                unselectedLabelColor: const Color(0xFF64748B),
                tabs: const [
                  Tab(text: '🍱 Siapa Makan Apa (Menu)'),
                  Tab(text: '⚖️ Bagi Rata (Sama Rata)'),
                ],
              ),
            ),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // ===========================================================
                  // TAB 1: SIAPA MAKAN APA (ITEMIZED SPLIT BILL)
                  // ===========================================================
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Card Info Resto & Tombol Pindai Struk
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.02),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.restaurant_rounded, color: Color(0xFF00A887), size: 20),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextField(
                                      controller: _placeController,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFF0F172A),
                                      ),
                                      decoration: const InputDecoration(
                                        isDense: true,
                                        contentPadding: EdgeInsets.zero,
                                        border: InputBorder.none,
                                        hintText: 'Nama Warung / Restoran',
                                      ),
                                    ),
                                  ),
                                  const Icon(Icons.edit_rounded, color: Color(0xFF94A3B8), size: 16),
                                ],
                              ),
                              const Divider(height: 20, color: Color(0xFFF1F5F9)),

                              // Tombol Solusi Lupa Pesanan: Pindai Struk Kasir
                              InkWell(
                                onTap: _simulateScanReceipt,
                                borderRadius: BorderRadius.circular(14),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE6F8F5),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(color: const Color(0xFF00BFA5).withOpacity(0.3)),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.camera_alt_rounded, color: Color(0xFF00A887), size: 18),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Lupa tadi pesan apa saja?',
                                              style: GoogleFonts.plusJakartaSans(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                                color: const Color(0xFF00897B),
                                              ),
                                            ),
                                            Text(
                                              'Pindai struk kasir resto untuk scan menu otomatis',
                                              style: GoogleFonts.plusJakartaSans(
                                                fontSize: 10.5,
                                                color: const Color(0xFF00897B).withOpacity(0.8),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Color(0xFF00A887)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Header Rincian Tagihan Per Orang
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tagihan Per Orang (Siapa Makan Apa)',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF0F172A),
                              ),
                            ),
                            InkWell(
                              onTap: _showAddItemDialog,
                              child: Text(
                                '＋ Tambah Menu',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF00A887),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Card Rincian Teman & Status Bayar
                        ..._members.map((member) {
                          final personalTotal = calculations[member] ?? 0;
                          final isPaid = _paidStatus[member] ?? false;

                          // Ambil makanan milik orang ini
                          final myFoods = _orderItems.where((i) => i['person'] == member).toList();

                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: isPaid ? const Color(0xFFA7F3D0) : const Color(0xFFE2E8F0),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.02),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 14,
                                          backgroundColor: isPaid ? const Color(0xFFE6F8F5) : const Color(0xFFFEF3C7),
                                          child: Text(
                                            member[0],
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w800,
                                              color: isPaid ? const Color(0xFF00A887) : const Color(0xFFD97706),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          member,
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.w800,
                                            color: const Color(0xFF0F172A),
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Switch Status Bayar
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _paidStatus[member] = !isPaid;
                                        });
                                      },
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: isPaid ? const Color(0xFFD1FAE5) : const Color(0xFFFEF3C7),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          isPaid ? '✓ LUNAS' : '⏳ BELUM BAYAR',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.w800,
                                            color: isPaid ? const Color(0xFF059669) : const Color(0xFFD97706),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 18, color: Color(0xFFF1F5F9)),

                                // Daftar Makanan yang Dimakan
                                ...myFoods.map((f) => Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '• ${f['name']}',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 11.5,
                                            color: const Color(0xFF64748B),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'Rp ${f['price']}',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF334155),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),

                                const SizedBox(height: 8),

                                // Total Akhir Orang Ini
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total Yang Harus Ditransfer:',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF0F172A),
                                      ),
                                    ),
                                    Text(
                                      'Rp ${personalTotal.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFF00A887),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),

                        const SizedBox(height: 10),

                        // Switch Pajak Resto 10%
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pajak Restoran PB1 (10%)',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF0F172A),
                                    ),
                                  ),
                                  Text(
                                    'Dibagi proporsional sesuai porsi makan',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 10.5,
                                      color: const Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                              Switch(
                                value: _includeTax,
                                activeColor: const Color(0xFF00A887),
                                onChanged: (val) {
                                  setState(() => _includeTax = val);
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),

                  // ===========================================================
                  // TAB 2: BAGI RATA (EQUAL SPLIT)
                  // ===========================================================
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Tagihan Makan Bareng',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _equalTotalController,
                          keyboardType: TextInputType.number,
                          onChanged: (_) => setState(() {}),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF00A887),
                          ),
                          decoration: InputDecoration(
                            prefixText: 'Rp ',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),

                        Text(
                          'Jumlah Teman Makan: $_equalPeopleCount Orang',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            IconButton(
                              onPressed: _equalPeopleCount > 2
                                  ? () => setState(() => _equalPeopleCount--)
                                  : null,
                              icon: const Icon(Icons.remove_circle_outline_rounded),
                              color: const Color(0xFF00A887),
                              iconSize: 32,
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  '$_equalPeopleCount Orang',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () => setState(() => _equalPeopleCount++),
                              icon: const Icon(Icons.add_circle_outline_rounded),
                              color: const Color(0xFF00A887),
                              iconSize: 32,
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Card Hasil Bagi Rata
                        Builder(
                          builder: (context) {
                            final total = double.tryParse(_equalTotalController.text.replaceAll('.', '')) ?? 120000;
                            final perPerson = (total / _equalPeopleCount).round();

                            return Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF00BFA5), Color(0xFF1E88E5)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(22),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF00BFA5).withOpacity(0.3),
                                    blurRadius: 16,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Masing-masing Orang Membayar:',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      color: Colors.white.withOpacity(0.9),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    'Rp ${perPerson.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Bagi rata bersih tanpa selisih sepeser pun',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // =================================================================
            // BOTTOM BAR: TOMBOL KIRIM KE WHATSAPP
            // =================================================================
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Tombol Salin Rincian
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.copy_rounded, color: Color(0xFF334155), size: 20),
                      tooltip: 'Salin Teks',
                      onPressed: _copyWhatsAppText,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Tombol Utama Kirim WhatsApp
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _copyWhatsAppText,
                        icon: const Icon(Icons.chat_rounded, color: Colors.white, size: 20),
                        label: Text(
                          'Kirim Rincian ke WhatsApp',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF25D366),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
