import 'package:flutter/material.dart';

class AppColors {
  // Cores primárias
  static const Color primary = Color(0xFF1E88E5);
  static const Color primaryDark = Color(0xFF1565C0);
  static const Color primaryLight = Color(0xFF64B5F6);
  static const Color accent = Color(0xFF00ACC1);

  // Elementos de interface
  static const Color border = Color(0xFFE0E0E0);

  // Gradientes
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFE3F2FD),
      Color(0xFFFFFFFF),
    ],
  );

  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Colors.white;

  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);

  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFA726);

  static const Color cardBackground = Colors.white;
  static const Color divider = Color(0xFFBDBDBD);

  // Status colors para indicações
  static const Color statusPending = Color(0xFFFFA726); // Laranja
  static const Color statusContacted = Color(0xFF42A5F5); // Azul
  static const Color statusConverted = Color(0xFF66BB6A); // Verde
  static const Color statusRejected = Color(0xFFEF5350); // Vermelho
}
