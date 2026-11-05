import 'package:flutter/material.dart';

/// ============================================================================
/// BACKGROUND RESMI PUNDIGO (POLKADOT BESAR #ACEDFF & #6CFBCB)
/// ============================================================================
/// Sesuai layer 'HALAMAN PEMBUKA' & 'LOADING SCREEN' di Figma:
/// - Warna kanvas: Putih bersih (Colors.white).
/// - Ellipse 1 (Polkadot Besar Atas): Warna #ACEDFF dengan gradien pendaran lembut.
/// - Ellipse 2 (Polkadot Besar Bawah): Warna #6CFBCB dengan gradien pendaran lembut.
/// - Pusat: Ambient radial glow cyan halus di area logo.
/// ============================================================================
class PundigoBackground extends StatelessWidget {
  final Widget child;

  const PundigoBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Latar Belakang Asli Figma (Polkadot Halus #ACEDFF & #6CFBCB)
          Positioned.fill(
            child: Image.asset(
              'assets/images/pundigo_splash_bg.png',
              fit: BoxFit.cover,
              filterQuality: FilterQuality.high,
            ),
          ),

          // Konten Utama
          child,
        ],
      ),
    );
  }
}

