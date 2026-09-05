import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemePalette {
  final String name;
  final Color backgroundColor;
  final Color primaryColor;
  final Color secondaryColor;
  final Color headerColor;

  const ThemePalette({
    required this.name,
    required this.backgroundColor,
    required this.primaryColor,
    required this.secondaryColor,
    required this.headerColor,
  });
}

class ThemeService {
  static final ThemeService instance = ThemeService._internal();
  ThemeService._internal();

  static const Map<String, ThemePalette> palettes = {
    'Krem Ceria': ThemePalette(
      name: 'Krem Ceria',
      backgroundColor: Color(0xFFFFFDE7),
      primaryColor: Color(0xFF1E88E5),
      secondaryColor: Color(0xFFE24379),
      headerColor: Color(0xFF333333),
    ),
    'Biru Laut': ThemePalette(
      name: 'Biru Laut',
      backgroundColor: Color(0xFFE3F2FD),
      primaryColor: Color(0xFF0288D1),
      secondaryColor: Color(0xFF009688),
      headerColor: Color(0xFF0D47A1),
    ),
    'Hijau Segar': ThemePalette(
      name: 'Hijau Segar',
      backgroundColor: Color(0xFFE8F5E9),
      primaryColor: Color(0xFF2E7D32),
      secondaryColor: Color(0xFFFF8F00),
      headerColor: Color(0xFF1B5E20),
    ),
    'Ungu Ceria': ThemePalette(
      name: 'Ungu Ceria',
      backgroundColor: Color(0xFFF3E5F5),
      primaryColor: Color(0xFF8E24AA),
      secondaryColor: Color(0xFFD81B60),
      headerColor: Color(0xFF4A148C),
    ),
    'Pink Ceria': ThemePalette(
      name: 'Pink Ceria',
      backgroundColor: Color(0xFFFFEBEE),
      primaryColor: Color(0xFFE91E63),
      secondaryColor: Color(0xFFFF6F00),
      headerColor: Color(0xFF880E4F),
    ),
  };

  final ValueNotifier<String> currentThemeName = ValueNotifier('Krem Ceria');

  ThemePalette get currentPalette =>
      palettes[currentThemeName.value] ?? palettes['Krem Ceria']!;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString('user_theme_color');
    if (savedTheme != null && palettes.containsKey(savedTheme)) {
      currentThemeName.value = savedTheme;
    }
  }

  Future<void> setTheme(String themeName) async {
    if (palettes.containsKey(themeName)) {
      currentThemeName.value = themeName;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_theme_color', themeName);
    }
  }
}
