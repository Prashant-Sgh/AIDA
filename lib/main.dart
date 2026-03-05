import 'package:aida/features/splash/presentation/screen/Splash.dart';
import 'package:aida/features/welcome/presentation/screen/Welcome.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Welcome()),
    );
  }
}
