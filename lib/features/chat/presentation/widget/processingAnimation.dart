import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ProcessingAnimation extends StatelessWidget {
  const ProcessingAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, bottom: 16.0),
      child: SizedBox(
          width: 40,
          height: 40,
          child: Align(
            alignment: Alignment.centerLeft,
            child: LoadingAnimationWidget.waveDots(
              color: Colors.purpleAccent.withAlpha(100),
              size: 60,
            ),
          )),
    );
  }
}
