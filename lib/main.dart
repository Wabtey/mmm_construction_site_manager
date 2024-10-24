import 'package:flutter/material.dart';
import 'start_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Construction Site Manager',
      theme: ThemeData(
        brightness: Brightness.dark,
        // colorScheme: const ColorScheme.dark(),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
      home: const StartScreen(title: 'Welcome page'),
    );
  }
}
