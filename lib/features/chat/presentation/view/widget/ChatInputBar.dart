import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatInputBar extends StatefulWidget {
  final Future<void> Function(String) sendMessage;
  const ChatInputBar({super.key, required this.sendMessage});

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
    final theme = Theme.of(context);
    final iconColor = theme.colorScheme.onSurface.withOpacity(0.7);
    final singleChildScrollController = ScrollController();
    final textFieldScrollController = ScrollController();
    final backgroundColor = theme.colorScheme.onSurface.withAlpha(15);
    final isEnabled = _controller.text.isNotEmpty;
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
            color: backgroundColor,
            border: Border.all(
              color: theme.colorScheme.onSurface.withAlpha(50),
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
                  controller: singleChildScrollController,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: 20,
                      maxHeight: 100,
                    ),
                    child: TextField(
                      onChanged: (value) => setState(() {
                        _controller.text = value;
                      }),
                      controller: _controller,
                      maxLines: null,
                      autofocus: false,
                      keyboardType: TextInputType.text,
                      cursorColor: theme.colorScheme.onSurface,
                      scrollController: textFieldScrollController,
                      style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: theme.colorScheme.onSurface),
                      decoration: InputDecoration(
                        hintText: 'What would you like to know?',
                        hintStyle: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  const SizedBox(width: 12),
                  IconButton(
                    icon: Icon(Icons.image_outlined, color: iconColor),
                    onPressed: () {},
                    splashRadius: 24,
                  ),
                  IconButton(
                    icon: Icon(Icons.code, color: iconColor),
                    onPressed: () {},
                    splashRadius: 24,
                  ),
                  IconButton(
                    icon: Icon(Icons.mic_none, color: iconColor),
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
                        color: isEnabled ? theme.colorScheme.primary : theme.colorScheme.onSurface.withAlpha(100),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_upward_rounded, size: 14, color: theme.colorScheme.surface),
                        onPressed: isEnabled ? () {
                          widget.sendMessage(_controller.text);
                          _controller.clear();
                      } : null,
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
