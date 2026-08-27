import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final Color bgYellow = const Color(0xFFffd500);

class FollowUpSuggestionWidget extends StatelessWidget {
  final List<String> suggestions;
  final Function(String) onTapped;

  const FollowUpSuggestionWidget({
    super.key,
    required this.suggestions,
    required this.onTapped,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    if (suggestions.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 0.0, bottom: 16.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          alignment: WrapAlignment.end,
          crossAxisAlignment: WrapCrossAlignment.end,
          direction: Axis.horizontal, 
          children: suggestions.map((text) {
            return GestureDetector(
              onTap: () => onTapped(text),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 250),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                decoration: BoxDecoration(
                  color: bgYellow,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                    bottomRight:
                        Radius.zero, // Bottom right set to zero as requested
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDarkMode? const Color.fromARGB(255, 238, 255, 0).withOpacity(0.3): Colors.blueGrey.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  text,
                  style: GoogleFonts.quicksand(
                    // color: theme.colorScheme.onPrimary,
                    color: Colors.black,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
