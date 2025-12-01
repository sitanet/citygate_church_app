import 'package:flutter/material.dart';

class AppColors {
  // Primary Church Colors
  static const Color primary = Color(0xFFD4AF37); // Gold
  static const Color secondary = Color(0xFF8B1A1A); // Deep Red
  static const Color accent = Color(0xFFE74625); // Orange-Red
  
  // Neutral Colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Colors.white;
  static const Color onSurface = Color(0xFF1A1A1A);
  static const Color surfaceVariant = Color(0xFFF0F0F0);
  
  // Text Colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textLight = Colors.white;
  
  // Status Colors
  static const Color live = Color(0xFFFF3333);
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53E3E);
  
  // Gradients
  static const List<Color> primaryGradient = [
    Color(0xFFD4AF37),
    Color(0xFFB8860B),
  ];
  
  static const List<Color> darkGradient = [
    Color(0xFF2D1B69),
    Color(0xFF1A1A1A),
  ];
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        background: AppColors.background,
        onSurface: AppColors.onSurface,
      ),
      
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textPrimary,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class AppStyles {
  static BoxDecoration get primaryGradientBox => BoxDecoration(
    gradient: const LinearGradient(
      colors: AppColors.primaryGradient,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(12),
  );
  
  static BoxDecoration get darkGradientBox => BoxDecoration(
    gradient: const LinearGradient(
      colors: AppColors.darkGradient,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(12),
  );
  
  static BoxShadow get cardShadow => BoxShadow(
    color: Colors.black.withOpacity(0.1),
    blurRadius: 8,
    offset: const Offset(0, 2),
  );
}