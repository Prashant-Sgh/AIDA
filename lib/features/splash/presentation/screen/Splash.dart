import 'package:aida/features/splash/presentation/widgets/AIDA_animation.dart';
import 'package:aida/features/splash/presentation/widgets/MetaText.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Stack(children: [
      Center(child: AIDAAnimation()),
      Positioned(bottom: 127, left: 0, right: 0, child: MetaText())
    ]));
  }
}
