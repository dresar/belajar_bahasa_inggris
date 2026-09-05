import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pages/main_navigation_shell.dart';
import 'services/background_music_service.dart';
import 'services/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  await ThemeService.instance.init();
  runApp(const EnglishLearningApp());
  // Asynchronous non-blocking background music init
  BackgroundMusicService.instance.init();
}

class EnglishLearningApp extends StatelessWidget {
  const EnglishLearningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: ThemeService.instance.currentThemeName,
      builder: (context, themeName, child) {
        final palette = ThemeService.instance.currentPalette;
        return MaterialApp(
          title: 'Belajar Bahasa Inggris SD',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            fontFamily: 'Roboto',
            scaffoldBackgroundColor: palette.backgroundColor,
            colorScheme: ColorScheme.fromSeed(
              seedColor: palette.primaryColor,
              primary: palette.primaryColor,
              secondary: palette.secondaryColor,
            ),
          ),
          home: const MainNavigationShell(),
        );
      },
    );
  }
}
