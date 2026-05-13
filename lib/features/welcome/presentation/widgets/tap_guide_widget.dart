import 'package:aida/features/welcome/presentation/screen/Welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class TapGuideWidget extends ConsumerStatefulWidget {
  final VoidCallback onTap;

  const TapGuideWidget({
    super.key,
    required this.onTap,
  });

  @override
  ConsumerState<TapGuideWidget> createState() => _TapHintWidgetState();
}

class _TapHintWidgetState extends ConsumerState<TapGuideWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    /// Example:
    /// final themeMode = ref.watch(themeProvider);

    final bool isDarkMode = true;
    // theme.brightness == Brightness.dark;

    final backgroundColor = isDarkMode
        ? Colors.white.withOpacity(0.12)
        : Colors.black.withOpacity(0.08);

    final borderColor = isDarkMode
        ? Colors.white.withOpacity(0.22)
        : Colors.black.withOpacity(0.12);

    final textColor = isDarkMode
        ? Colors.white.withOpacity(0.9)
        : Colors.black.withOpacity(0.75);

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final scale = 1 + (_controller.value * 0.08);

          return Transform.scale(
            scale: scale,
            child: Container(
              width: 92,
              height: 92,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: backgroundColor,
                border: Border.all(
                  color: borderColor,
                  width: 1.2,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.touch_app_rounded,
                    color: textColor,
                    size: 28,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Tap here',
                    style: GoogleFonts.quicksand(
                      color: textColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.48,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// @Preview()
// Widget previewTapGuideWidget() => previewThis();

// Widget previewThis() {
//   bool hasUserTappedGuide = false;
//   return Stack(
//     children: [
//       if (!hasUserTappedGuide)
//         Positioned(
//           right: 20,
//           bottom: 24,
//           child: TapGuideWidget(
//             onTap: () => hasUserTappedGuide = true,
//           ),
//         ),
//     ],
//   );
// }

@Preview()
Widget previewTapGuideWidget() => previewThis();

Widget previewThis() {
  bool hasUserTappedGuide = false;
  return Welcome();
}
