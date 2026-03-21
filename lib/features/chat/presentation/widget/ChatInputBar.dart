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
    final theme = Theme.of(context);
    final bg = theme.colorScheme.surface;
    final iconColor = theme.colorScheme.onSurface.withOpacity(0.7);
    final scrollController = ScrollController();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: 120,
          maxHeight: 200,
          maxWidth: double.infinity,
        ),
        child: Container(
          // height: 58,
          decoration: BoxDecoration(
            color: theme.colorScheme.onSurface.withAlpha(2),
            border: BoxBorder.all(
              color: theme.colorScheme.onSurface.withAlpha(40),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.12),
                blurRadius: 12,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 26.0, right: 26.0, top: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        maxLines: 3,
                        scrollController: scrollController,
                        style: GoogleFonts.quicksand(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
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
                    const SizedBox(width: 8),
                  ],
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
                      height: 42,
                      width: 42,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_upward_rounded, size: 20),
                        color: theme.colorScheme.onPrimary,
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
