import 'package:aida/core/theme/theme_provider.dart';
import 'package:aida/features/welcome/model/AnimationController.dart';
import 'package:aida/features/welcome/presentation/widgets/IntroductionText.dart';
import 'package:aida/features/welcome/presentation/widgets/TapAnimation.dart';
import 'package:aida/features/welcome/presentation/widgets/TopRevealHeader.dart';
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
  late MascotAnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController.init();
    animationController = MascotAnimationController(this, onAnimationEnd: transitionToWelcomScr);
  }

  @override
  void dispose() {
    // _controller.dispose();
    animationController.dispose();
    super.dispose();
  }

  void transitionToWelcomScr() {
    context.push('/welcome');
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final changeTheme = ref.read(themeModeProvider.notifier).toggleTheme();
    return provider.ChangeNotifierProvider.value(
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
            // Positioned(
            //   top: 0,
            //   left: 0,
            //   right: 0,
            //   bottom: 0,
            //   child: TopRevealHeader(
            //     child: Text("Settingss page"),
            //   ),
            // ),
            Positioned(
              top: 30,
              left: 0,
              right: 0,
              child: IconButton(
                onPressed: () =>
                    ref.read(themeModeProvider.notifier).toggleTheme(),
                icon: Icon(
                  themeMode == ThemeMode.dark
                      ? Icons.light_mode
                      : Icons.light_mode_outlined,
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
          ],
        ),
      ),
    );
  }
}
