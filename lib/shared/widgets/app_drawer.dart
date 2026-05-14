import 'package:aida/core/theme/CustomColors.dart';
import 'package:aida/core/theme/theme_provider.dart';
import 'package:aida/features/welcome/presentation/widgets/BaseLine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/widget_previews.dart';

class AppDrawer extends ConsumerWidget {
  final Future<void> Function() onClearChat;

  const AppDrawer({
    super.key,
    required this.onClearChat,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// Theme
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final customColors = theme.extension<CustomColors>();

    /// Colors
    final backgroundColor = customColors?.lightCardColor ?? colorScheme.surface;

    final lineColor = colorScheme.onSurface.withOpacity(0.08);

    final textColor = colorScheme.onSurface;

    final secondaryTextColor = colorScheme.onSurface.withOpacity(0.65);

    final dangerColor = Colors.redAccent;

    /// Theme state

    final isDarkMode = theme.brightness == Brightness.dark;

    return Drawer(
      backgroundColor: backgroundColor,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Padding(
                padding: const EdgeInsets.only(
                  top: 12,
                  bottom: 24,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'AIDA',
                        style: GoogleFonts.baloo2(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                    ),

                    /// Theme Toggle
                    IconButton(
                      splashRadius: 22,
                      onPressed: () {
                        ref.read(themeModeProvider.notifier).toggleTheme();
                      },
                      icon: Icon(
                        isDarkMode
                            ? Icons.light_mode_outlined
                            : Icons.light_mode,
                        key: ValueKey(isDarkMode),
                        color: textColor,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),

              _DrawerTile(
                title: 'Admin controll',
                icon: Icons.shield_outlined,
                textColor: textColor,
                onTap: () {
                  context.push('/authentication');
                },
              ),

              _DrawerDivider(
                lineColor: lineColor,
              ),

              _DrawerTile(
                title: 'Works',
                icon: Icons.work_outline_rounded,
                textColor: textColor,
                onTap: () {},
              ),

              _DrawerDivider(
                lineColor: lineColor,
              ),

              _DrawerTile(
                title: 'Guide me',
                icon: Icons.auto_awesome_rounded,
                textColor: textColor,
                onTap: () {
                  context.go('/');
                },
              ),

              _DrawerDivider(
                lineColor: lineColor,
              ),

              _DrawerTile(
                title: 'Clear Chat',
                icon: Icons.delete_outline_rounded,
                textColor: dangerColor,
                onTap: () async {
                  await onClearChat();
                },
              ),

              const Spacer(),

              /// Footer
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 10,
                ),
                child: Text(
                  'Built with intention.',
                  style: GoogleFonts.quicksand(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: secondaryTextColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color textColor;
  final VoidCallback onTap;

  const _DrawerTile({
    required this.title,
    required this.icon,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 14,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: textColor.withOpacity(0.9),
              ),
              const SizedBox(width: 14),
              Text(
                title,
                style: GoogleFonts.quicksand(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerDivider extends StatelessWidget {
  final Color lineColor;

  const _DrawerDivider({
    required this.lineColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 2,
      ),
      child: BaseLine(
        width: 1,
        dividerHeight: 0.4,
        colour: lineColor,
      ),
    );
  }
}
