import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ثيمات التطبيق - الوضع النهاري والليلي
// متوافق مع Material Design 3

class AppTheme {
  // الألوان الأساسية
  static const Color primaryColor = Color(0xFF6366F1); // Indigo
  static const Color secondaryColor = Color(0xFF8B5CF6); // Violet
  static const Color accentColor = Color(0xFFEC4899); // Pink

  // ألوان الملاحظات (للتمييز البصري)
  static const List<Color> noteColors = [
    Color(0xFFFEF3C7), // أصفر فاتح
    Color(0xFFDBEAFE), // أزرق فاتح
    Color(0xFFD1FAE5), // أخضر فاتح
    Color(0xFFFCE7F3), // وردي فاتح
    Color(0xFFE9D5FF), // بنفسجي فاتح
    Color(0xFFFFEDD5), // برتقالي فاتح
    Color(0xFFE0E7FF), // نيلي فاتح
  ];

  // الثيم النهاري
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xFFFAFAFA),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.cairo(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    ),
    textTheme: GoogleFonts.cairoTextTheme(),
    cardTheme: CardThemeData(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
  );

  // الثيم الليلي
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: GoogleFonts.cairo(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    textTheme: GoogleFonts.cairoTextTheme(ThemeData.dark().textTheme),
    cardTheme: CardThemeData(
      elevation: 1,
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade800),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade800),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      filled: true,
      fillColor: const Color(0xFF2A2A2A),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
  );

  // ألوان الملاحظات في الوضع الليلي
  static List<Color> getDarkNoteColors() {
    return [
      const Color(0xFF3D3520), // أصفر داكن
      const Color(0xFF1E3A5F), // أزرق داكن
      const Color(0xFF1F3F2F), // أخضر داكن
      const Color(0xFF4A1F35), // وردي داكن
      const Color(0xFF3D2F4F), // بنفسجي داكن
      const Color(0xFF4A2F1F), // برتقالي داكن
      const Color(0xFF2F2F4F), // نيلي داكن
    ];
  }
}
