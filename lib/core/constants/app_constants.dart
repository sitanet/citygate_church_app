import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'The CityGate Church';
  static const String appTagline = 'Where heaven meets earth';
}

enum AppStatus { initial, loading, success, error }

enum ContentType { video, audio, live }

enum ServiceCategory {
  morningDew,
  feastOfGlory,
  wordAndPrayer,
  schoolOfChrist,
  kingdomBusiness,
  sundayService,
}

extension ServiceCategoryExtension on ServiceCategory {
  String get displayName {
    switch (this) {
      case ServiceCategory.morningDew:
        return 'The Morning Dew';
      case ServiceCategory.feastOfGlory:
        return 'Feast of Glory';
      case ServiceCategory.wordAndPrayer:
        return 'Word & Prayer';
      case ServiceCategory.schoolOfChrist:
        return 'The School of Christ';
      case ServiceCategory.kingdomBusiness:
        return 'Kingdom Business';
      case ServiceCategory.sundayService:
        return 'Sunday Service';
    }
  }
  
  Color get color {
    switch (this) {
      case ServiceCategory.morningDew:
        return const Color(0xFFFFD700);
      case ServiceCategory.feastOfGlory:
        return const Color(0xFFE74625);
      case ServiceCategory.wordAndPrayer:
        return const Color(0xFF8B1A1A);
      case ServiceCategory.schoolOfChrist:
        return const Color(0xFF2D1B69);
      case ServiceCategory.kingdomBusiness:
        return const Color(0xFF9C27B0);
      case ServiceCategory.sundayService:
        return const Color(0xFFD4AF37);
    }
  }
  
  // Add hex color string getter
  String get hexColor {
    switch (this) {
      case ServiceCategory.morningDew:
        return '#FFD700';
      case ServiceCategory.feastOfGlory:
        return '#E74625';
      case ServiceCategory.wordAndPrayer:
        return '#8B1A1A';
      case ServiceCategory.schoolOfChrist:
        return '#2D1B69';
      case ServiceCategory.kingdomBusiness:
        return '#9C27B0';
      case ServiceCategory.sundayService:
        return '#D4AF37';
    }
  }
}

// Helper function to convert hex string to Color
Color hexToColor(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}