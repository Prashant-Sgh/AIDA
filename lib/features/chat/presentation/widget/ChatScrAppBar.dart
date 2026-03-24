import 'package:aida/core/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatScrAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const ChatScrAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    // final toggleTheme = ref.read(themeModeProvider.notifier).toggleTheme();
    return AppBar(
      foregroundColor: Theme.of(context).colorScheme.onSurface,
      backgroundColor: Theme.of(context).colorScheme.background,
      leading: Icon(Icons.list_rounded),
      title: Center(
        child: Text(
          'AIDA',
          style: GoogleFonts.baloo2(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 32,
            fontWeight: FontWeight.w600,
            height: 0.63,
            letterSpacing: 0.96,
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => ref.read(themeModeProvider.notifier).toggleTheme(),
          icon: Icon( themeMode == ThemeMode.light ? Icons.light_mode : Icons.light_mode_outlined),
        )
      ],
    );
  }
}
