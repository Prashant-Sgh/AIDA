import 'dart:math';
import 'package:flutter/material.dart';

class MascotAnimationController extends ChangeNotifier {
  final TickerProvider vsync;

  final Function onAnimationEnd;

  MascotAnimationController(this.vsync, {required this.onAnimationEnd});

  late final AnimationController controller;

  late final Animation<Offset> slideAnimation;

  bool showBubble = false; // This will trigger rebuilds
  int animatedElementIndex = 0;

  void init() {
    controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: vsync,
    );
    slideAnimation = Tween<Offset>(
    begin: const Offset(-1.5, 0),
    end: Offset.zero,
  ).animate(CurvedAnimation(
    parent: controller,
    curve: Curves.easeInOutCubicEmphasized,
  ));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // animation helper functions.

  final List<Map<String, String>> elements = [
    {
      'image': 'assets/mascots/Hello-Gesture.png',
      'text': "Hi there! I'm Aida, Atul's AI assistant.\n \nI'm here to help you navigate through this app & provide information about Atul's portfolio."
    },
    {
      'image': 'assets/mascots/Calm-Sit.png',
      'text': "Give the icon above a try to switch between themes."
    },
    {
      'image': 'assets/mascots/Smilling-Glad.png',
      'text':
          "Next, I’ll take you to the chat where you can ask me anything about Atul’s work.\n \nOnce authenticated, you can customize my personality & other settings from the Context screen later."
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
      animatedElementIndex = (animatedElementIndex + 1) % elements.length;
      notifyListeners(); // Notify listeners to rebuild the UI
      animationIn();
    } else {
      // Once all elements have been shown
      // dispose the animation controller using dispose();
      dispose();
      // transition to next screen. It could be chat screen
      onAnimationEnd();
      // animatedElementIndex = 0; // Reset to the first element after the last one
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

String getRandomPokemon() {
  final pokemonNames = [
    'Pikachu',
    'Eevee',
    'Sylveon',
    'Jigglypuff',
    'Bulbasaur',
    'Squirtle',
    'Meowth',
    'Piplup',
    'Togepi',
    'Vulpix',
  ];

  final random = Random();
  return pokemonNames[random.nextInt(pokemonNames.length)];
}
