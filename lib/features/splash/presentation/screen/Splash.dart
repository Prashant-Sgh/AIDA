import 'package:aida/features/splash/presentation/widgets/AIDA_animation.dart';
import 'package:aida/features/splash/presentation/widgets/MetaText.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    // Navigate to Welcome screen after 2 sec
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) context.go('/welcome');
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Stack(children: [
      Center(child: AIDAAnimation()),
      Positioned(bottom: 157, left: 0, right: 0, child: MetaText())
    ]));
  }
}
