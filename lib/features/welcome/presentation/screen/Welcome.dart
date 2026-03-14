import 'package:aida/features/welcome/model/AnimationController.dart';
import 'package:aida/features/welcome/presentation/widgets/HintBubble.dart';
import 'package:aida/features/welcome/presentation/widgets/IntroductionText.dart';
import 'package:aida/features/welcome/presentation/widgets/MascotHints.dart';
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
  // late AnimationController _controller;
  // late Animation<Offset> _slideAnimation;

  // Offset offset = const Offset(-1.5, 0); // Start off-screen to the left

  // bool isMascotOnScreen = false;
  // bool showBubble = false;

  // void showHint() {
  //   setState(() {
  //     showBubble = !showBubble;
  //   });
  // }

  // void animateMascot() {
  //   setState(() {
  //     if (isMascotOnScreen) {
  //       _controller.reverse();
  //       isMascotOnScreen = false;
  //     } else {
  //       _controller.forward();
  //       isMascotOnScreen = true;
  //     }
  //   });
  // }

  // void toggleMascotAnimation() {
  //   animateMascot();
  //   _controller.addStatusListener(
  //     (status) {
  //       if (status == AnimationStatus.completed) {
  //         showHint();
  //       }
  //       if (status == AnimationStatus.reverse) {
  //         showHint();
  //       }
  //     },
  //   );
  // }

  late MascotAnimationController animationController;

  @override
  void initState() {
    super.initState();

    // _controller = AnimationController(
    //   duration: const Duration(milliseconds: 500),
    //   vsync: this,
    // );

    // _slideAnimation = Tween<Offset>(
    //   begin: const Offset(-1.5, 0), // Start off-screen to the left
    //   end: Offset.zero, // End at normal position (on-screen)
    // ).animate(CurvedAnimation(
    //   parent: _controller,
    //   curve: Curves.easeInOutCubicEmphasized,
    // ));

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
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: animationController.onTap,
        backgroundColor: const Color(0xFF2C2C2C),
        child: const Icon(
          Icons.play_arrow,
          color: Colors.white,
          size: 30,
        ),
      ),
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
          Positioned(
            top: 268,
            bottom: 0,
            left: 0,
            right: 0,
            child: IntroductionText(),
          ),
          // Positioned(
          //   left: 36,
          //   bottom: 78,
          //   child: SlideTransition(
          //     position: _slideAnimation,
          //     child: Image.asset(
          //       "assets/mascots/welcome/Mascot-01.png",
          //       fit: BoxFit.contain,
          //     ),
          //   ),
          // ),
          // Positioned(
          //   // top: 0,
          //   left: 198,
          //   bottom: 250,
          //   child: AnimatedOpacity(
          //     opacity: showBubble ? 1.0 : 0.0,
          //     // opacity: 1.0,
          //     duration: const Duration(milliseconds: 300),
          //     child: AnimatedSlide(
          //       offset: showBubble ? Offset.zero : const Offset(-1, 1),
          //       // offset: Offset.zero,
          //       duration: Duration(milliseconds: 400),
          //       curve: Curves.easeOut,
          //       child: const HintBubble(
          //           text: "Tap here. I'll show you \nsomething."),
          //     ),
          //   ),
          // ),
          Positioned(
            // top: 0,
            left: 36,
            right: 0,
            bottom: 78,
            child: ChangeNotifierProvider.value(
              value: animationController,
              builder: (context, child) {
                return TapAnimation(
                  elements: animationController.elements,
                  animationController: animationController,
                  controller: animationController.controller,
                  showBubble: animationController.showBubble,
                  animatedElementIndex:
                      animationController.animatedElementIndex,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
