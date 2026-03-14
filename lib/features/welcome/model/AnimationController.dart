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

  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // animation helper functions.

  final List<Map<String, String>> elements = [
    {'assets/mascots/Mascot-Hello.png': 'Welcome to our app!'},
    {'assets/mascots/Mascot-Calmly-sitting.png': 'Discover new features!'},
    {'assets/mascots/Mascot-Glad.png': 'Get started now!'},
  ];

  int animatedElementIndex = 0;

  void animationIn() {
    controller.forward();
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        showBubble = true;
        notifyListeners(); // Notify listeners to rebuild the UI
      }
    });
  }

  void animationOut() {
    controller.reverse();
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        showBubble = false;
        notifyListeners(); // Notify listeners to rebuild the UI
      }
    });
  }

  void onTap() {
    if (animatedElementIndex < elements.length - 1) {
      animationOut();
      animatedElementIndex = animatedElementIndex + 1; // Notify listeners to rebuild the UI
    } else {
      // Reset to the first element after the last one
      animatedElementIndex = 0; // Notify listeners to rebuild the UI
      animationIn();
    }
  }
}
