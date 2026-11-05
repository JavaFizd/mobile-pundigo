import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/pg_logo.dart';
import 'login_screen.dart';
import 'otp_screen.dart';

/// ============================================================================
/// HALAMAN DAFTAR AKUN BARU
/// ============================================================================
/// Catatan untuk Dosen:
/// - Sesuai desain Figma:
///   1. 'DAFTAR AKUN (SEBELUM INPUT, SANDI TUTUP).png' (Form kosong & tombol abu-abu).
///   2. 'DAFTAR AKUN (SETELAH INPUT, SANDI TUTUP).png' (Form terisi & tombol aktif).
/// - Berisi form input Nama, Nomor HP (+62), Email (@), dan Sandi (toggle mata).
/// - Validasi persetujuan syarat & ketentuan via Checkbox.
/// - Menawarkan 2 metode pengiriman OTP: WhatsApp dan SMS.
/// - Dilengkapi tombol bantu 'Simulasi Otomatis' & 'Kosongkan' untuk memudahkan
///   pengujian kedua state Figma tersebut.
/// ============================================================================
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _agreeTerms = false;

  void _fillSampleData() {
    setState(() {
      _nameController.text = 'Dinda Syahfitri';
      _phoneController.text = '82501800288';
      _emailController.text = 'alhamdulillah.dinda@gmail.com';
      _passwordController.text = 'PundiGo123!';
      _agreeTerms = true;
    });
  }

  void _clearForm() {
    setState(() {
      _nameController.clear();
      _phoneController.clear();
      _emailController.clear();
      _passwordController.clear();
      _agreeTerms = false;
    });
  }

  bool get _isFormValid =>
      _nameController.text.trim().isNotEmpty &&
      _phoneController.text.trim().isNotEmpty &&
      _emailController.text.trim().isNotEmpty &&
      _passwordController.text.trim().isNotEmpty &&
      _agreeTerms;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onTextChanged);
    _phoneController.addListener(_onTextChanged);
    _emailController.addListener(_onTextChanged);
    _passwordController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (mounted) setState(() {});
  }

  void _submitOtp(String method) {
    if (!_isFormValid) {
      if (!_agreeTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Harap setujui Syarat Penggunaan & Kebijakan Privasi terlebih dahulu.'),
            backgroundColor: AppColors.danger,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Harap lengkapi semua kolom formulir pendaftaran.'),
            backgroundColor: AppColors.danger,
          ),
        );
      }
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OtpScreen(
          name: _nameController.text.trim(),
          phoneNumber: '+62 ${_phoneController.text.trim()}',
          email: _emailController.text.trim(),
          method: method,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.removeListener(_onTextChanged);
    _phoneController.removeListener(_onTextChanged);
    _emailController.removeListener(_onTextChanged);
    _passwordController.removeListener(_onTextChanged);
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isValid = _isFormValid;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Atas: Logo PG & Tulisan PundiGo! (Diberi margin atas 52dp agar tidak terpotong notch/status bar HP)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const PgLogo(size: 32),
                  Text(
                    'PundiGo!',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Banner Biru: "Daftar Akun Baru"
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00BFA5), Color(0xFF1E88E5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daftar Akun Baru',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Buat akun PundiGo! kamu untuk menikmati akses transfer gratis, split bill cerdas, dan bunga tabungan harian.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.95),
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // Baris Kontrol Form: Informasi Akun & Tombol Simulasi Cepat
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Informasi Akun',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF334155),
                    ),
                  ),
                  Row(
                    children: [
                      if (_nameController.text.isNotEmpty || _phoneController.text.isNotEmpty)
                        GestureDetector(
                          onTap: _clearForm,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              'Kosongkan',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFEF4444),
                              ),
                            ),
                          ),
                        ),
                      GestureDetector(
                        onTap: _fillSampleData,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6F8F5),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFF00A887).withOpacity(0.35)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.flash_on_rounded, size: 14, color: Color(0xFF00A887)),
                              const SizedBox(width: 3),
                              Text(
                                '⚡ Isi Contoh',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF00A887),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Input 1: Nama Pengguna
              CustomTextField(
                label: 'Nama Pengguna',
                hintText: 'Contoh: Dinda Syahfitri',
                controller: _nameController,
              ),

              const SizedBox(height: 16),

              // Input 2: Nomor Ponsel (+62)
              CustomTextField(
                label: 'Nomor Ponsel',
                hintText: '81234567890 (tanpa angka 0 di awal)',
                prefixText: '+62',
                keyboardType: TextInputType.phone,
                controller: _phoneController,
              ),

              const SizedBox(height: 16),

              // Input 3: Alamat Email
              CustomTextField(
                label: 'Alamat Email',
                hintText: 'Masukkan Alamat Email (@gmail.com)',
                prefixIcon: const Icon(
                  Icons.alternate_email_rounded,
                  color: Color(0xFF94A3B8),
                  size: 19,
                ),
                showPrefixDivider: true,
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
              ),

              const SizedBox(height: 16),

              // Input 4: Kata Sandi
              CustomTextField(
                label: 'Kata Sandi',
                hintText: 'Masukkan Kata Sandi',
                obscureText: _obscurePassword,
                prefixIcon: const Icon(
                  Icons.key_rounded,
                  color: Color(0xFF94A3B8),
                  size: 19,
                ),
                showPrefixDivider: true,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: const Color(0xFF94A3B8),
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
                controller: _passwordController,
              ),

              const SizedBox(height: 16),

              // Checkbox Persetujuan Syarat & Ketentuan
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 22,
                    height: 22,
                    child: Checkbox(
                      value: _agreeTerms,
                      activeColor: const Color(0xFF00BFA5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      side: const BorderSide(
                        color: Color(0xFF00BFA5),
                        width: 1.6,
                      ),
                      onChanged: (val) {
                        setState(() {
                          _agreeTerms = val ?? false;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Saya setuju dengan Syarat Penggunaan dan Kebijakan Privasi PundiGo!',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF475569),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Tombol 1: Kirim OTP via WhatsApp
              InkWell(
                onTap: () => _submitOtp('WhatsApp'),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: isValid
                        ? const LinearGradient(
                            colors: [Color(0xFF00BFA5), Color(0xFF1E88E5)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          )
                        : null,
                    color: isValid ? null : const Color(0xFFD6D6D6),
                    boxShadow: isValid
                        ? [
                            BoxShadow(
                              color: const Color(0xFF00BFA5).withOpacity(0.28),
                              blurRadius: 14,
                              offset: const Offset(0, 6),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Kirim kode OTP via WhatsApp',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Tombol 2: Kirim OTP via SMS
              InkWell(
                onTap: () => _submitOtp('SMS'),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: isValid ? Colors.white : const Color(0xFFD6D6D6),
                    border: isValid
                        ? Border.all(color: const Color(0xFF00BFA5), width: 1.5)
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Kirim kode OTP via SMS',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isValid ? const Color(0xFF00A887) : Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: isValid ? const Color(0xFF00A887) : Colors.white,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Footer: Sudah punya akun? Masuk di sini
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Sudah punya akun? ',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                        );
                      },
                      child: Text(
                        'Masuk di sini',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF00BFA5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

