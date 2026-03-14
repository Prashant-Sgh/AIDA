import 'package:aida/features/welcome/model/AnimationController.dart';
import 'package:aida/features/welcome/presentation/widgets/HintBubble.dart';
import 'package:flutter/material.dart';

class TapAnimation extends StatefulWidget {
  final List<Map<String, String>> elements;
  final MascotAnimationController animationController;
  final AnimationController controller;
  final bool showBubble;
  final int animatedElementIndex;

  const TapAnimation({
    Key? key,
    required this.elements,
    required this.animationController,
    required this.controller,
    required this.showBubble,
    required this.animatedElementIndex,
  }) : super(key: key);

  @override
  _TapAnimationState createState() => _TapAnimationState();
}

class _TapAnimationState extends State<TapAnimation>
// with SingleTickerProviderStateMixin
{
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late bool showBubble;
  late int animatedElementIndex;

  @override
  void initState() {
    super.initState();

    _controller = widget.controller;
    _slideAnimation = widget.animationController.slideAnimation;
    showBubble = widget.showBubble;
    animatedElementIndex = widget.animatedElementIndex;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return 
    // Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.center,
      // mainAxisSize: MainAxisSize.max,
      // children: [
        Stack(
          children: [
            Positioned(
              // left: 36,
              // bottom: 78,
              child: SlideTransition(
                position: _slideAnimation,
                child: Image.asset(
                  widget.elements[animatedElementIndex]['image'] ??
                      'assets/mascots/Thinking-mode-headshot.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              // top: 0,
              // left: 198,
              // bottom: 250,
              child: AnimatedOpacity(
                opacity: showBubble ? 1.0 : 0.0,
                // opacity: 1.0,
                duration: const Duration(milliseconds: 300),
                child: AnimatedSlide(
                  offset: showBubble ? Offset.zero : const Offset(-1, 1),
                  // offset: Offset.zero,
                  duration: Duration(milliseconds: 400),
                  curve: Curves.easeOut,
                  child: HintBubble(
                      text: widget.elements[animatedElementIndex]['text'] ??
                          "Something went wrong. Please debug."),
                ),
              ),
            ),
          // ],
        // ),
      ],
    );
  }
}
