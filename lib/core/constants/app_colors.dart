// ==========================================
// BLOOD BANK APP - COLOR SYSTEM
// Light & Dark Theme Colors
// ==========================================

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Brand ──────────────────────────────
  static const primary       = Color(0xFFD32F2F);
  static const primaryDark   = Color(0xFFB71C1C);
  static const primaryLight  = Color(0xFFEF5350);
  static const accent        = Color(0xFFFF6B6B);

  // ── Blood Type Badges ──────────────────
  static const bloodRed      = Color(0xFFD32F2F);
  static const bloodCrimson  = Color(0xFF9B1B1B);

  // ── Light Theme ───────────────────────
  static const lightBg       = Color(0xFFFFF8F8);
  static const lightSurface  = Color(0xFFFFFFFF);
  static const lightCard     = Color(0xFFFFFFFF);
  static const lightBorder   = Color(0xFFF1D7D7);
  static const lightInk      = Color(0xFF1A0A0A);
  static const lightSubtext  = Color(0xFF7A5A5A);

  // ── Dark Theme ────────────────────────
  static const darkBg        = Color(0xFF0D0D0D);
  static const darkSurface   = Color(0xFF1A1A1A);
  static const darkCard      = Color(0xFF222222);
  static const darkBorder    = Color(0xFF3A2A2A);
  static const darkInk       = Color(0xFFF5EEEE);
  static const darkSubtext   = Color(0xFF9E8585);

  // ── Semantic ──────────────────────────
  static const success       = Color(0xFF22C55E);
  static const warning       = Color(0xFFF59E0B);
  static const error         = Color(0xFFEF4444);
  static const info          = Color(0xFF3B82F6);

  // ── Status: Blood Request ─────────────
  static const urgent        = Color(0xFFDC2626);
  static const pending       = Color(0xFFF59E0B);
  static const completed     = Color(0xFF16A34A);
  static const cancelled     = Color(0xFF6B7280);

  // ── Gradients ─────────────────────────
  static const gradientRed = LinearGradient(
    colors: [Color(0xFFE53935), Color(0xFFB71C1C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const gradientDark = LinearGradient(
    colors: [Color(0xFF2C1010), Color(0xFF0D0D0D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const gradientCard = LinearGradient(
    colors: [Color(0xFFFFE4E4), Color(0xFFFFF0F0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Blood Type Colors ─────────────────
  static Color bloodTypeColor(String type) {
    switch (type.trim()) {
      case 'A+': return const Color(0xFFE53935);
      case 'A-': return const Color(0xFFC62828);
      case 'B+': return const Color(0xFF1E88E5);
      case 'B-': return const Color(0xFF1565C0);
      case 'O+': return const Color(0xFF43A047);
      case 'O-': return const Color(0xFF2E7D32);
      case 'AB+': return const Color(0xFF8E24AA);
      case 'AB-': return const Color(0xFF6A1B9A);
      default:   return const Color(0xFF757575);
    }
  }
}
