import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../models/transaction_model.dart';
import '../models/feature_models.dart';
import 'dummy_data.dart';

/// ============================================================================
/// STATE MANAGEMENT SEDERHANA (APP STATE)
/// ============================================================================
/// Catatan untuk Dosen:
/// Menggunakan ChangeNotifier murni bawaan Flutter tanpa dependensi rumit,
/// sehingga sangat mudah dipelajari dan dipahami alurnya.
/// Semua perubahan data (transfer, top up, ganti profil) langsung
/// terupdate secara reaktif di layar aplikasi.
/// ============================================================================
class AppState extends ChangeNotifier {
  // Singleton pattern agar state dapat diakses di seluruh screen
  static final AppState instance = AppState._internal();
  factory AppState() => instance;
  AppState._internal();

  UserModel _user = DummyData.currentUser;
  bool _isBalanceVisible = true;
  final List<TransactionModel> _transactions = List.from(DummyData.initialTransactions);
  KasKelompokModel _kasKelompok = DummyData.defaultKas;
  final List<KasMutasiModel> _kasMutasi = [
    KasMutasiModel(
      title: 'Beli ATK & Print Makalah',
      subtitle: 'Nota No. 0429 • Fotokopi Kampus',
      amount: 35000,
      isIncome: false,
      date: DateTime.now().subtract(const Duration(days: 1)),
      hasReceipt: true,
      uploader: 'Dinda (Bendahara)',
    ),
    KasMutasiModel(
      title: 'Iuran Kas: Rahmat Hidayat',
      subtitle: 'Transfer via PundiGo!',
      amount: 25000,
      isIncome: true,
      date: DateTime.now().subtract(const Duration(days: 2)),
      hasReceipt: false,
      uploader: 'Rahmat Hidayat',
    ),
    KasMutasiModel(
      title: 'Iuran Kas: Maya Lestari',
      subtitle: 'Transfer via Bank Aceh',
      amount: 25000,
      isIncome: true,
      date: DateTime.now().subtract(const Duration(days: 3)),
      hasReceipt: false,
      uploader: 'Maya Lestari',
    ),
  ];

  // Getters
  UserModel get user => _user;
  bool get isBalanceVisible => _isBalanceVisible;
  List<TransactionModel> get transactions => List.unmodifiable(_transactions);
  KasKelompokModel get kasKelompok => _kasKelompok;
  List<KasMutasiModel> get kasMutasi => List.unmodifiable(_kasMutasi);


  // Sembunyikan atau tampilkan saldo utama (Ikon Mata di Dashboard)
  void toggleBalanceVisibility() {
    _isBalanceVisible = !_isBalanceVisible;
    notifyListeners();
  }

  // Mendaftarkan akun baru dari awal (Simulasi Pendaftaran Akun Baru)
  void registerNewUser({
    required String name,
    required String phone,
    required String email,
    required String pin,
    String? photoUrl,
  }) {
    final cleanName = name.trim().isEmpty ? 'Dinda Syahfitri' : name.trim();
    final initials = UserModel.computeInitials(cleanName);

    String formattedPhone = phone.trim();
    if (formattedPhone.isEmpty) {
      formattedPhone = '+62 825-0180-0288';
    } else if (!formattedPhone.startsWith('+62')) {
      if (formattedPhone.startsWith('0')) {
        formattedPhone = '+62 ${formattedPhone.substring(1)}';
      } else if (formattedPhone.startsWith('62')) {
        formattedPhone = '+$formattedPhone';
      } else {
        formattedPhone = '+62 $formattedPhone';
      }
    }

    _user = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: cleanName,
      phone: formattedPhone,
      email: email.trim().isEmpty ? 'alhamdulillah.dinda@gmail.com' : email.trim(),
      initials: initials,
      photoUrl: photoUrl,
      accountType: 'Akun Basic',
      saldoUtama: 0,
      saldoDompet: 0,
      pin: pin.isNotEmpty ? pin : '170845',
    );
    _transactions.clear();
    _kasKelompok = DummyData.defaultKas.copyWith(collectedAmount: 0);
    _isBalanceVisible = true;
    notifyListeners();
  }

  // Update profil pengguna (Nama, No HP, Email, dan Foto Profil)
  void updateUserProfile({
    String? name,
    String? phone,
    String? email,
    String? photoUrl,
    bool clearPhoto = false,
  }) {
    _user = _user.copyWith(
      name: name ?? _user.name,
      phone: phone ?? _user.phone,
      email: email ?? _user.email,
      photoUrl: clearPhoto ? null : (photoUrl ?? _user.photoUrl),
      clearPhoto: clearPhoto,
    );
    notifyListeners();
  }

  // Upgrade akun ke PundiGo! Plus
  void upgradeToPlus() {
    _user = _user.copyWith(accountType: 'Akun Plus');
    notifyListeners();
  }

  // Melakukan transfer saldo
  bool transferSaldo(double amount, String recipientName) {
    if (_user.saldoUtama < amount) return false;

    // Kurangi saldo utama
    _user = _user.copyWith(saldoUtama: _user.saldoUtama - amount);

    // Tambahkan riwayat transaksi baru di posisi teratas
    _transactions.insert(
      0,
      TransactionModel(
        id: 'TRX-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
        title: 'Transfer ke $recipientName',
        subtitle: 'Hari ini • Sukses',
        date: DateTime.now(),
        amount: amount,
        isIncome: false,
        status: 'Sukses',
        referenceNumber: 'PG-TRF-${DateTime.now().millisecondsSinceEpoch}',
        category: 'Transfer',
      ),
    );

    notifyListeners();
    return true;
  }

  // Melakukan Top Up saldo
  void topUpSaldo(double amount, {String method = 'Indomaret'}) {
    _user = _user.copyWith(saldoUtama: _user.saldoUtama + amount);

    _transactions.insert(
      0,
      TransactionModel(
        id: 'TRX-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
        title: 'Top Up $method',
        subtitle: 'Hari ini • Sukses',
        date: DateTime.now(),
        amount: amount,
        isIncome: true,
        status: 'Sukses',
        referenceNumber: 'PG-IDM-${DateTime.now().millisecondsSinceEpoch}',
        category: 'TopUp',
      ),
    );

    notifyListeners();
  }

  // Menambah iuran kas kelompok
  bool setorKas(double amount, {String uploader = 'Dinda Syahfitri'}) {
    if (_user.saldoUtama >= amount) {
      _user = _user.copyWith(saldoUtama: _user.saldoUtama - amount);
      _kasKelompok = KasKelompokModel(
        id: _kasKelompok.id,
        title: _kasKelompok.title,
        memberCount: _kasKelompok.memberCount,
        collectedAmount: _kasKelompok.collectedAmount + amount,
        targetAmount: _kasKelompok.targetAmount,
      );
      _kasMutasi.insert(
        0,
        KasMutasiModel(
          title: 'Iuran Kas: $uploader',
          subtitle: 'Transfer via PundiGo!',
          amount: amount,
          isIncome: true,
          date: DateTime.now(),
          hasReceipt: false,
          uploader: uploader,
        ),
      );
      notifyListeners();
      return true;
    }
    return false;
  }

  // Mencatat pengeluaran kas kelompok oleh bendahara dengan bukti nota
  bool catatPengeluaranKas({
    required String title,
    required double amount,
    String subtitle = 'Nota terlampir • Telah diverifikasi',
    bool hasReceipt = true,
  }) {
    if (_kasKelompok.collectedAmount >= amount) {
      _kasKelompok = KasKelompokModel(
        id: _kasKelompok.id,
        title: _kasKelompok.title,
        memberCount: _kasKelompok.memberCount,
        collectedAmount: _kasKelompok.collectedAmount - amount,
        targetAmount: _kasKelompok.targetAmount,
      );
      _kasMutasi.insert(
        0,
        KasMutasiModel(
          title: title,
          subtitle: subtitle,
          amount: amount,
          isIncome: false,
          date: DateTime.now(),
          hasReceipt: hasReceipt,
          uploader: 'Dinda (Bendahara)',
        ),
      );
      notifyListeners();
      return true;
    }
    return false;
  }


  // Pembelian Token Listrik PLN
  bool bayarTokenListrik({required double amount, required String idPelanggan, required String tokenCode}) {
    if (_user.saldoUtama < amount) return false;

    _user = _user.copyWith(saldoUtama: _user.saldoUtama - amount);
    _transactions.insert(
      0,
      TransactionModel(
        id: 'TRX-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
        title: 'Token Listrik PLN',
        subtitle: 'ID: $idPelanggan • Sukses',
        date: DateTime.now(),
        amount: amount,
        isIncome: false,
        status: 'Sukses',
        referenceNumber: 'PG-PLN-${DateTime.now().millisecondsSinceEpoch}',
        category: 'Tagihan',
      ),
    );
    notifyListeners();
    return true;
  }

  // Pembelian Pulsa & Paket Data
  bool beliPulsa({required double amount, required String phone, required String packageName}) {
    if (_user.saldoUtama < amount) return false;

    _user = _user.copyWith(saldoUtama: _user.saldoUtama - amount);
    _transactions.insert(
      0,
      TransactionModel(
        id: 'TRX-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}',
        title: 'Pulsa / Paket Data',
        subtitle: '$phone ($packageName) • Sukses',
        date: DateTime.now(),
        amount: amount,
        isIncome: false,
        status: 'Sukses',
        referenceNumber: 'PG-PLS-${DateTime.now().millisecondsSinceEpoch}',
        category: 'Pulsa',
      ),
    );
    notifyListeners();
    return true;
  }
}

