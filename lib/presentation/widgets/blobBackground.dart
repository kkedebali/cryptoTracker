import 'dart:ui';
import 'package:flutter/material.dart';

class CryptoBackground extends StatelessWidget {
  final Widget child;

  const CryptoBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // En taban siyah renk
      body: Stack(
        children: [
          // --- 1. TURUNCU BLOB (Sol Üst) ---
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.orange.withAlpha(100), // Şeffaflık
              ),
            ),
          ),

          // --- 2. YEŞİL BLOB (Sağ Orta) ---
          Positioned(
            top: 250,
            right: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green.withAlpha(80),
              ),
            ),
          ),

          // --- 3. MAVİ BLOB (Sol Alt) ---
          Positioned(
            bottom: 50,
            left: -50,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withAlpha(90),
              ),
            ),
          ),

          // --- TÜM RENKLERİ BULANIKLAŞTIRAN KATMAN (BLUR) ---
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 90.0, sigmaY: 90.0),
              child: Container(
                color: Colors.black.withAlpha(10), // Hafif karartma katmanı
              ),
            ),
          ),

          // --- 4. ASIL SAYFA İÇERİĞİ (Home sayfan buraya gelecek) ---
          Positioned.fill(child: child),
        ],
      ),
    );
  }
}