import 'package:aida/features/welcome/model/AnimationController.dart';
import 'package:aida/features/welcome/presentation/widgets/HintBubble.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TapAnimation extends StatefulWidget {
  // final MascotAnimationController animationController;
  // final List<Map<String, String>> elements;
  // final Animation<Offset> slideAnimation;
  // final AnimationController controller;
  // final bool showBubble;
  // final int animatedElementIndex;

  const TapAnimation({
    Key? key,
    // required this.animationController,
    // required this.elements,
    // required this.slideAnimation,
    // required this.controller,
    // required this.showBubble,
    // required this.animatedElementIndex,
  }) : super(key: key);

  @override
  _TapAnimationState createState() => _TapAnimationState();
}

class _TapAnimationState extends State<TapAnimation>
// with SingleTickerProviderStateMixin
{
  // late AnimationController _controller;
  // late Animation<Offset> _slideAnimation;
  // late bool showBubble;
  // late int animatedElementIndex;

  @override
  void initState() {
    super.initState();

    // _controller = widget.animationController.controller;
    // _slideAnimation = widget.animationController.slideAnimation;
    // showBubble = widget.animationController.showBubble;
    // animatedElementIndex = widget.animatedElementIndex;
  }

  @override
  void dispose() {
    // _controller.dispose();
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
