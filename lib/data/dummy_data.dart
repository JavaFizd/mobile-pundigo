import '../models/user_model.dart';
import '../models/transaction_model.dart';
import '../models/feature_models.dart';

/// ============================================================================
/// DATA DUMMY LOKAL PUNDIGO (TEMPAT UJI COBA DOSEN)
/// ============================================================================
/// Catatan Khusus untuk Dosen / Penguji:
/// - Jika ingin menguji perubahan data (misal: ganti nama user, ubah nominal saldo,
///   atau tambah riwayat transaksi baru), cukup ubah nilai di file ini!
/// - Format data ini 100% identik dengan dokumen Firebase Firestore yang akan
///   digunakan pada tahap integrasi backend berikutnya.
/// ============================================================================
class DummyData {
  // Profil Pengguna Utama (Sesuai Desain Figma DASHBOARD-3.png: Saldo Rp100.000)
  static UserModel currentUser = UserModel(
    id: 'user_001',
    name: 'Dinda Syahfitri',
    phone: '+62 825-0180-0288',
    email: 'alhamdulillah.dinda@gmail.com',
    initials: 'DS',
    accountType: 'Akun Basic',
    saldoUtama: 0,
    saldoDompet: 0,
    pin: '170845',
  );

  // Penerima Transfer Rekomendasi (Sesuai Desain Figma: Naufal Daffa)
  static UserModel demoRecipient = UserModel(
    id: 'user_002',
    name: 'Naufal Daffa',
    phone: '0825-0180-1800',
    email: 'naufal.daffa@gmail.com',
    initials: 'ND',
    accountType: 'Akun Terverifikasi',
  );

  // Riwayat Transaksi Akun Baru (Awalnya kosong, bertambah otomatis saat Top Up / Transfer)
  static List<TransactionModel> initialTransactions = [];

  // Kas Kelompok Aktif (Sesuai Desain Figma)
  static KasKelompokModel defaultKas = KasKelompokModel(
    id: 'kas_001',
    title: 'KAS KELOMPOK TUGAS UI/UX',
    memberCount: 4,
    collectedAmount: 0,
    targetAmount: 100000,
  );
}
