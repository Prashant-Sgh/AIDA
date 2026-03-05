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
      begin: const Offset(0, -0.1),
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
            child: Container(
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
                          // color: Colors.green[200],
                          child: Center(
                            child: Icon(Icons.settings, size: 28),
                          ),
                        ),
                        GestureDetector(
                          onTap: _toggle,
                          onVerticalDragUpdate: (details) {
                            if (details.delta.dy > 5) {
                              _toggle();
                            }
                          },
                          child: (_isOpen)
                              ? Container(
                                  height: 30,
                                  width: double.infinity,
                                  color: Colors.transparent,
                                  child: Center(
                                      child: Icon(Icons.keyboard_arrow_up)),
                                )
                              : Container(
                                  height: 30,
                                  width: double.infinity,
                                  color: Colors.transparent,
                                  child: Center(
                                    child: Icon(Icons.keyboard_arrow_down),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 60,
                    color: Colors.white,
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
