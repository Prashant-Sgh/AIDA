import 'package:aida/core/theme/CustomColors.dart';
import 'package:aida/features/welcome/presentation/widgets/BaseLine.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatelessWidget {
  final Future<void> Function() onClearChat;
  final bool isMounted;

  const AppDrawer({required this.onClearChat, required this.isMounted, super.key});
  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Drawer(
      backgroundColor:
          Theme.of(context).extension<CustomColors>()!.lightCardColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Drawer header (optional)
          Padding(
            padding: const EdgeInsets.only(
                top: 16.0, bottom: 8.0, left: 16.0, right: 16.0),
            child: Text(
              'AIDA',
              style: TextStyle(
                color: textColor,
                fontSize: 22,
                fontFamily: 'Baloo2Bold',
              ),
            ),
          ),
          // Drawer items
          ListTile(
            // leading: Icon(Icons.open_in_new_rounded, color: textColor),
            title: Text(
              'Works',
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'QuicksandMedium',
              ),
            ),
            onTap: () {
              // Handle tap on the Home item
            },
          ),

          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: BaseLine(
              width: 1,
              dividerHeight: 0.5,
              colour: textColor.withOpacity(0.2),
            ),
          ),
          // Drawer items
          ListTile(
            // leading: Icon(Icons.open_in_new_rounded, color: textColor),
            title: Text(
              'Guide me',
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'QuicksandMedium',
              ),
            ),
            onTap: () {
              if (isMounted) context.go('/welcome');
            },
          ),

          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: BaseLine(
              width: 1,
              dividerHeight: 0.5,
              colour: textColor.withOpacity(0.2),
            ),
          ),
          ListTile(
            // leading: Icon(Icons.delete, color: Colors.red),
            title: Text(
              'Clear Chat',
              style: TextStyle(
                color: Colors.red,
                fontSize: 15,
                fontFamily: 'QuicksandMedium',
              ),
            ),
            onTap: () async{
              onClearChat();
            },
          ),
          // Add more items as needed
        ],
      ),
    );
  }
}
