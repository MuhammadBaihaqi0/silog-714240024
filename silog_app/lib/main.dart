import 'package:flutter/material.dart';

import 'data/preferensi.dart';
import 'tampilan/daftar_pengiriman_page.dart';

void main() => runApp(const SiLogApp());

/// Tugas 3: StatefulWidget agar dapat men-toggle dark mode
class SiLogApp extends StatefulWidget {
  const SiLogApp({super.key});

  /// Metode statis untuk toggle dark mode dari widget lain
  static void toggleDarkMode(BuildContext context) {
    final state = context.findAncestorStateOfType<SiLogAppState>();
    state?.toggleDarkMode();
  }

  @override
  State<SiLogApp> createState() => SiLogAppState();
}

class SiLogAppState extends State<SiLogApp> {
  final _pref = Preferensi();
  ThemeMode _themeMode = ThemeMode.light;

  @override
  void initState() {
    super.initState();
    _muatPreferensi();
  }

  Future<void> _muatPreferensi() async {
    final gelap = await _pref.modeGelap();
    if (!mounted) return;
    setState(() {
      _themeMode = gelap ? ThemeMode.dark : ThemeMode.light;
    });
  }

  Future<void> toggleDarkMode() async {
    final baruGelap = _themeMode == ThemeMode.light;
    await _pref.setModeGelap(baruGelap);
    if (!mounted) return;
    setState(() {
      _themeMode = baruGelap ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SiLog',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B5E20),
        ),
        cardTheme: CardThemeData(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B5E20),
          brightness: Brightness.dark,
        ),
        cardTheme: CardThemeData(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        appBarTheme: const AppBarTheme(centerTitle: true),
      ),
      home: const DaftarPengirimanPage(),
    );
  }
}
