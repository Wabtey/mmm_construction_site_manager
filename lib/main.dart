import 'package:flutter/material.dart';
import 'package:mmm_construction_site_manager/custom_material_app.dart';
import 'start_screen.dart' as start_screen;

void main() {
  runApp(
    const CustomMaterialApp(
      title: 'Construction Site Manager',
      home: start_screen.StartScreen(title: 'Welcome page'),
    ),
  );
}
