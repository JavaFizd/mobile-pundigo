/// ============================================================================
/// MODEL PATUNGAN PINTAR (SPLIT BILL)
/// ============================================================================
class PatunganModel {
  final String id;
  final String title;
  final double totalAmount;
  final int memberCount;
  final double perPersonAmount;
  final bool isActive;
  final DateTime createdAt;

  PatunganModel({
    required this.id,
    required this.title,
    required this.totalAmount,
    required this.memberCount,
    required this.perPersonAmount,
    this.isActive = true,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'totalAmount': totalAmount,
      'memberCount': memberCount,
      'perPersonAmount': perPersonAmount,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory PatunganModel.fromMap(Map<String, dynamic> map) {
    return PatunganModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      totalAmount: (map['totalAmount'] ?? 0).toDouble(),
      memberCount: map['memberCount'] ?? 1,
      perPersonAmount: (map['perPersonAmount'] ?? 0).toDouble(),
      isActive: map['isActive'] ?? true,
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}

/// ============================================================================
/// MODEL SAKU KELOMPOK (KAS BERSAMA)
/// ============================================================================
class KasKelompokModel {
  final String id;
  final String title;
  final int memberCount;
  final double collectedAmount;
  final double targetAmount;

  KasKelompokModel({
    required this.id,
    required this.title,
    required this.memberCount,
    required this.collectedAmount,
    required this.targetAmount,
  });

  KasKelompokModel copyWith({
    String? id,
    String? title,
    int? memberCount,
    double? collectedAmount,
    double? targetAmount,
  }) {
    return KasKelompokModel(
      id: id ?? this.id,
      title: title ?? this.title,
      memberCount: memberCount ?? this.memberCount,
      collectedAmount: collectedAmount ?? this.collectedAmount,
      targetAmount: targetAmount ?? this.targetAmount,
    );
  }

  double get progressPercentage {
    if (targetAmount <= 0) return 0.0;
    final ratio = collectedAmount / targetAmount;
    return ratio > 1.0 ? 1.0 : ratio;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'memberCount': memberCount,
      'collectedAmount': collectedAmount,
      'targetAmount': targetAmount,
    };
  }

  factory KasKelompokModel.fromMap(Map<String, dynamic> map) {
    return KasKelompokModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      memberCount: map['memberCount'] ?? 1,
      collectedAmount: (map['collectedAmount'] ?? 0).toDouble(),
      targetAmount: (map['targetAmount'] ?? 100000).toDouble(),
    );
  }
}

/// ============================================================================
/// MODEL MUTASI KAS KELOMPOK (DENGAN BUKTI NOTA DIGITAL)
/// ============================================================================
class KasMutasiModel {
  final String title;
  final String subtitle;
  final double amount;
  final bool isIncome;
  final DateTime date;
  final bool hasReceipt;
  final String uploader;

  KasMutasiModel({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isIncome,
    required this.date,
    this.hasReceipt = false,
    required this.uploader,
  });
}

