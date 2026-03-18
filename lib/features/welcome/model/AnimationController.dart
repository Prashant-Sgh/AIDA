import 'package:flutter/material.dart';

class MascotAnimationController extends ChangeNotifier {
  final TickerProvider vsync;

  MascotAnimationController(this.vsync);

  late AnimationController controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: vsync,
  );

  late Animation<Offset> slideAnimation = Tween<Offset>(
    begin: const Offset(-1.5, 0),
    end: Offset.zero,
  ).animate(CurvedAnimation(
    parent: controller,
    curve: Curves.easeInOutCubicEmphasized,
  ));

  bool showBubble = false; // This will trigger rebuilds
  int animatedElementIndex = 0;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // animation helper functions.

  final List<Map<String, String>> elements = [
    {
      'image': 'assets/mascots/Hello-Gesture.png',
      'text': "Tap here, I’ll show you something."
    },
    {
      'image': 'assets/mascots/Calm-Sit.png',
      'text': "Hey, I’m Aida. I’m here to guide you..."
    },
    {
      'image': 'assets/mascots/Smilling-Glad.png',
      'text':
          "This app is a AI chatbot. I’m here to help you with any details you need about Atul’s portfolio. Let’s talk, tap on the message bubble. Yes that one."
    },
  ];

  void animationIn() {
    controller.forward();
    showBubble = true;
    notifyListeners();
  }

  void animationOut() {
    void listener(AnimationStatus status) {
      if (status == AnimationStatus.dismissed) {
        handleAnimatedElementIndex();
        controller.removeStatusListener(listener);
      }
    }

    showBubble = false;
    notifyListeners();
    controller.reverse();
    controller.addStatusListener(listener);
  }

  void handleAnimatedElementIndex() {
    if (animatedElementIndex < (elements.length - 1)) {
      // animatedElementIndex = ++animatedElementIndex; // Move to the next element
      animatedElementIndex = (animatedElementIndex + 1) % elements.length;
      notifyListeners(); // Notify listeners to rebuild the UI
      animationIn();
    } else {
      animatedElementIndex = 0; // Reset to the first element after the last one
      notifyListeners(); // Notify listeners to rebuild the UI
    }
  }

  void onTap() {
    if (showBubble) {
      animationOut();
    } else {
      animationIn();
    }
  }
}
