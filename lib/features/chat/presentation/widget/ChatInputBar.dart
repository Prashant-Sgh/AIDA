import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatInputBar extends StatefulWidget {
  const ChatInputBar({super.key});

  @override
  State<ChatInputBar> createState() => _ChatInputBar();
}

class _ChatInputBar extends State<ChatInputBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final _iconColor = _theme.colorScheme.onSurface.withOpacity(0.7);
    final _singleChildScrollController = ScrollController();
    final _textFieldScrollController = ScrollController();
    final _backgroundColor = _theme.colorScheme.onSurface.withAlpha(15);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          // minHeight: 200,
          maxHeight: 200,
          maxWidth: double.infinity,
        ),
        child: Container(
          // height: 58,
          decoration: BoxDecoration(
            color: _backgroundColor,
            border: Border.all(
              color: _theme.colorScheme.onSurface.withAlpha(50),
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 12.0),
                child: SingleChildScrollView(
                  controller: _singleChildScrollController,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: 20,
                      maxHeight: 100,
                    ),
                    child: TextField(
                      controller: _controller,
                      maxLines: null,
                      autofocus: false,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.purpleAccent,
                      scrollController: _textFieldScrollController,
                      style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: _theme.colorScheme.onSurface),
                      decoration: InputDecoration(
                        hintText: 'What would you like to know?',
                        hintStyle: _theme.textTheme.bodyMedium?.copyWith(
                          color: _theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                ),

                // child: Row(
                //   children: [
                //     Expanded(
                //       child: TextField(
                //         controller: _controller,
                //         maxLines: 1,
                //         scrollController: scrollController,
                //         style: GoogleFonts.quicksand(
                //             fontWeight: FontWeight.w400,
                //             fontSize: 16,
                //             color: theme.colorScheme.onSurface),
                //         decoration: InputDecoration(
                //           hintText: 'What would you like to know?',
                //           hintStyle: theme.textTheme.bodyMedium?.copyWith(
                //             color: theme.colorScheme.onSurface.withOpacity(0.6),
                //           ),
                //           border: InputBorder.none,
                //           isDense: true,
                //         ),
                //       ),
                //     ),
                //     // const SizedBox(width: 8),
                //   ],
                // ),
              ),
              Row(
                children: [
                  const SizedBox(width: 12),
                  IconButton(
                    icon: Icon(Icons.image_outlined, color: _iconColor),
                    onPressed: () {},
                    splashRadius: 24,
                  ),
                  IconButton(
                    icon: Icon(Icons.code, color: _iconColor),
                    onPressed: () {},
                    splashRadius: 24,
                  ),
                  IconButton(
                    icon: Icon(Icons.mic_none, color: _iconColor),
                    onPressed: () {},
                    splashRadius: 24,
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Container(
                      height: 32,
                      width: 32,
                      decoration: BoxDecoration(
                        color: _theme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_upward_rounded, size: 14),
                        color: _theme.colorScheme.onPrimary,
                        onPressed: () {
                          // send message action
                        },
                        splashRadius: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ),
    );
  }
}
