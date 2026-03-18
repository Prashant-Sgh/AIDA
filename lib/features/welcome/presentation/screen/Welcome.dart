import 'package:aida/features/welcome/model/AnimationController.dart';
import 'package:aida/features/welcome/presentation/widgets/IntroductionText.dart';
import 'package:aida/features/welcome/presentation/widgets/TapAnimation.dart';
import 'package:aida/features/welcome/presentation/widgets/TopRevealHeader.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> with SingleTickerProviderStateMixin {
  late MascotAnimationController animationController;

  @override
  void initState() {
    super.initState();

    animationController = MascotAnimationController(this);
  }

  @override
  void dispose() {
    // _controller.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: animationController,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: animationController.onTap,
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Icon(
            Icons.play_arrow,
            color: Theme.of(context).colorScheme.surface,
            size: 30,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
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
            Positioned(
              top: 268,
              bottom: 0,
              left: 0,
              right: 0,
              child: IntroductionText(),
            ),
            Positioned.fill(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Expanded(child: TapAnimation()),
            ),
          ],
        ),
      ),
    );
  }
}
