import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const SqlGeneratorApp());
}

class SqlGeneratorApp extends StatelessWidget {
  const SqlGeneratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQL Script Generator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB), // Professional Blue
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.grey.shade900,
        ),
      ),
      themeMode: ThemeMode.system,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
      },
    );
  }
}
