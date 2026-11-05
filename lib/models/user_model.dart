/// ============================================================================
/// MODEL DATA PENGGUNA (FIREBASE-READY)
/// ============================================================================
/// Struktur data pengguna PundiGo!. Sudah dilengkapi fungsi [toMap] dan
/// [fromMap] sehingga ketika nanti disambungkan ke Firebase Firestore / Auth,
/// kodenya tidak perlu dirombak lagi.
/// ============================================================================
class UserModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String initials;
  final String? photoUrl; // Foto profil pengguna (opsional)
  final String accountType; // "Akun Basic" atau "Akun Plus"
  final double saldoUtama;
  final double saldoDompet;
  final String pin;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    String? initials,
    this.photoUrl,
    this.accountType = 'Akun Basic',
    this.saldoUtama = 0,
    this.saldoDompet = 0,
    this.pin = '123456',
  }) : initials = (initials != null && initials.isNotEmpty)
            ? initials
            : computeInitials(name);

  /// Menghitung inisial otomatis dari nama lengkap.
  /// Contoh:
  /// - "Arman Wijaya" -> "AW"
  /// - "Dinda Syahfitri" -> "DS"
  /// - "Budi" -> "BU"
  static String computeInitials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'PG';
    final parts = trimmed.split(RegExp(r'\s+')).where((s) => s.isNotEmpty).toList();
    if (parts.isEmpty) return 'PG';
    if (parts.length == 1) {
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    }
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  bool get isPlus => accountType.toLowerCase().contains('plus');
  bool get hasPhoto => photoUrl != null && photoUrl!.trim().isNotEmpty;

  UserModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? initials,
    String? photoUrl,
    bool clearPhoto = false,
    String? accountType,
    double? saldoUtama,
    double? saldoDompet,
    String? pin,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      initials: initials ?? (name != null ? computeInitials(name) : this.initials),
      photoUrl: clearPhoto ? null : (photoUrl ?? this.photoUrl),
      accountType: accountType ?? this.accountType,
      saldoUtama: saldoUtama ?? this.saldoUtama,
      saldoDompet: saldoDompet ?? this.saldoDompet,
      pin: pin ?? this.pin,
    );
  }

  // Format untuk disimpan ke Firebase Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'initials': initials,
      'photoUrl': photoUrl,
      'accountType': accountType,
      'saldoUtama': saldoUtama,
      'saldoDompet': saldoDompet,
      'pin': pin,
    };
  }

  // Format saat membaca dokumen dari Firebase Firestore
  factory UserModel.fromMap(Map<String, dynamic> map) {
    final name = map['name'] ?? '';
    return UserModel(
      id: map['id'] ?? '',
      name: name,
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      initials: map['initials'] ?? computeInitials(name),
      photoUrl: map['photoUrl'],
      accountType: map['accountType'] ?? 'Akun Basic',
      saldoUtama: (map['saldoUtama'] ?? 0).toDouble(),
      saldoDompet: (map['saldoDompet'] ?? 0).toDouble(),
      pin: map['pin'] ?? '123456',
    );
  }
}
