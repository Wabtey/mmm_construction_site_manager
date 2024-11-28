import 'package:flutter/material.dart';

class CustomMaterialApp extends StatelessWidget {
  final Widget home;
  final String title;

  const CustomMaterialApp({super.key, required this.home, required this.title});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        brightness: Brightness.light,
        // useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        // useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: home,
    );
  }
}
