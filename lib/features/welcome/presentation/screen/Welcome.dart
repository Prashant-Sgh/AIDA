import 'package:aida/features/welcome/presentation/widgets/IntroductionText.dart';
import 'package:aida/features/welcome/presentation/widgets/TopRevealHeader.dart';
import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: TopRevealHeader(
              child: Text("Settingss page"),
            ),
          ),
          Positioned.fill(
            top: 268,
            bottom: 0,
            left: 0,
            right: 0,
            child: IntroductionText(),
          ),
        ],
      ),
    );
  }
}
