import 'package:aida/core/theme/theme_provider.dart';
import 'package:aida/features/welcome/model/AnimationController.dart';
import 'package:aida/features/welcome/presentation/widgets/IntroductionText.dart';
import 'package:aida/features/welcome/presentation/widgets/TapAnimation.dart';
import 'package:aida/features/welcome/presentation/widgets/TopRevealHeader.dart';
import 'package:aida/features/welcome/presentation/widgets/tap_guide_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart' as provider;

class Welcome extends ConsumerStatefulWidget {
  const Welcome({super.key});

  @override
  ConsumerState<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends ConsumerState<Welcome>
    with SingleTickerProviderStateMixin {
  late final MascotAnimationController animationController;
  bool isFirstTap = true;

  @override
  void initState() {
    super.initState();
    animationController =
        MascotAnimationController(this, onAnimationEnd: transitionToChatScr);
    animationController.init();
  }

  @override
  void dispose() {
    // _controller.dispose();
    animationController.dispose();
    super.dispose();
  }

  void transitionToChatScr() {
    context.push('/chat');
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return provider.ChangeNotifierProvider.value(
      value: animationController,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Stack(
          children: [
            Positioned(
              top: 30,
              left: 0,
              right: 0,
              child: IconButton(
                onPressed: () =>
                    ref.read(themeModeProvider.notifier).toggleTheme(),
                icon: Icon(
                  isDarkMode ? Icons.light_mode : Icons.light_mode_outlined,
                  size: 22,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
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

            // Tap_ gesture guide

            if (!isFirstTap) Positioned(
              right: 0,
              left: 0,
              top: 300,
              bottom: 0,
              child: GestureDetector(
                onTap: () => animationController.onTap(),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),

            if (isFirstTap)
              Positioned(
                right: 40,
                bottom: 80,
                child: TapGuideWidget(
                  onTap: () {
                    animationController.onTap();
                    setState(() {
                      isFirstTap = false;
                    });
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
