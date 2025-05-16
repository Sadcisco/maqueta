import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'screens/main_screen.dart';
import 'theme/app_theme.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema Agrícola',
      theme: AppTheme.theme,
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
