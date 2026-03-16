import 'package:aida/core/theme/CustomColors.dart';
import 'package:aida/features/welcome/presentation/widgets/BaseLine.dart';
import 'package:aida/features/welcome/presentation/widgets/RevealDivider.dart';
import 'package:flutter/material.dart';

class TopRevealHeader extends StatefulWidget {
  final Widget child;

  const TopRevealHeader({super.key, required this.child});

  @override
  State<TopRevealHeader> createState() => _TopRevealHeaderState();
}

class _TopRevealHeaderState extends State<TopRevealHeader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  bool _isOpen = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.2),
      end: Offset(0, 0.6),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
  }

  void _toggle() {
    if (_isOpen) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    setState(() {
      _isOpen = !_isOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = (_isOpen) ? 160 : 100;
    return SizedBox(
      height: height,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: SizedBox(
              // color: Colors.blue[100],
              height: height,
              width: double.infinity,
              child: Stack(
                children: [
                  /// Sliding Header
                  SlideTransition(
                    position: _slideAnimation,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 70,
                          child: Image(
                            image: AssetImage("assets/icon/settings.png"),
                          ),
                        ),
                        SizedBox(height: 7),
                        BaseLine(
                          width: 353,
                          dividerHeight: 0.4,
                          colour: Theme.of(context).extension<CustomColors>()!.dropDownLineColor,
                        ),
                        SizedBox(height: 7),
                        GestureDetector(
                          onTap: _toggle,
                          onVerticalDragUpdate: (details) {
                            if (details.delta.dy > 5) {
                              _toggle();
                            }
                          },
                          child: (_isOpen)
                              ? Container(
                                  height: 24,
                                  width: double.infinity,
                                  color: Colors.transparent,
                                  child: Center(
                                    child: Icon(
                                      Icons.keyboard_arrow_up,
                                      size: 28,
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 24,
                                  width: double.infinity,
                                  color: Colors.transparent,
                                  child: Center(
                                    child: Icon(
                                      Icons.keyboard_arrow_down,
                                      size: 28,
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 60,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
