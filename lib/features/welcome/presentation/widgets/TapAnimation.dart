import 'package:aida/features/welcome/model/AnimationController.dart';
import 'package:aida/features/welcome/presentation/widgets/HintBubble.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TapAnimation extends StatefulWidget {

  const TapAnimation({
    Key? key,
  }) : super(key: key);

  @override
  _TapAnimationState createState() => _TapAnimationState();
}

class _TapAnimationState extends State<TapAnimation>

{


  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MascotAnimationController>(
      builder: (context, animationController, child) {
        return Stack(
        children: [
          Positioned(
            left: 36,
            bottom: 78,
            child: SlideTransition(
              position: animationController.slideAnimation,
              child: Image.asset(
                animationController.elements[animationController.animatedElementIndex]['image'] ??
                  'assets/mascots/Thinking-mode-headshot.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
          Positioned(
            // top: 0,
            left: 198,
            bottom: 240,
            child: AnimatedOpacity(
              opacity: animationController.showBubble ? 1.0 : 0.0,
              // opacity: 1.0,
              duration: const Duration(milliseconds: 300),
              child: AnimatedSlide(
                offset: animationController.showBubble ? Offset.zero : const Offset(-1, 1),
                // offset: Offset.zero,
                duration: Duration(milliseconds: 400),
                curve: Curves.easeOut,
                child: HintBubble(
                    text: animationController.elements[animationController.animatedElementIndex]['text'] ??
                      "Something went wrong. Please debug."),
              ),
            ),
          ),
        ],
      );}
    );
  }
}
