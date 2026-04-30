import 'package:flutter/material.dart';
import 'package:aida/core/theme/app_colors.dart';
import 'package:flutter/widget_previews.dart';
import 'package:google_fonts/google_fonts.dart';


class ContextItemWidget extends StatefulWidget {
  final String contextId;
  final String contextName;
  final String contextDescription;

  const ContextItemWidget({
    Key? key,
    required this.contextId,
    required this.contextName,
    required this.contextDescription,
  }) : super(key: key);

  @override
  State<ContextItemWidget> createState() => _ContextItemWidgetState();
}

class _ContextItemWidgetState extends State<ContextItemWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  late TextEditingController _descriptionController;
  bool _isEditable = false;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _descriptionController = TextEditingController(text: widget.contextDescription);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    if (_isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      child: Column(
        children: [
          // Collapsed state - Header
          Container(
            margin: const EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.lightCardDark : AppColors.lightCard,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDarkMode ? AppColors.lineDark : AppColors.line,
                width: 0.5,
              ),
            ),
            child: InkWell(
              onTap: _toggleExpand,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.contextName,
                      style: GoogleFonts.quicksand(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 17.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (!_isExpanded)(const SizedBox(height: 6)),
                    if (!_isExpanded)(Text(
                      widget.contextDescription,
                      style: GoogleFonts.quicksand(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                    const SizedBox(width: 8),
                    Icon(
                      _isExpanded ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                      color: isDarkMode
                          ? AppColors.secondaryDark
                          : AppColors.secondary,
                    ),
                  ],
                ),
              ),
            ),
          ),
          ScaleTransition(
            scale: _expandAnimation,
            child: ClipRect(
              child: SizeTransition(
                sizeFactor: _expandAnimation,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  decoration: BoxDecoration(
                    color: isDarkMode? Colors.grey[800] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Context description
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0)
                          ),
                          child: TextField(
                            controller: _descriptionController,
                            enabled: _isEditable,
                            style: GoogleFonts.quicksand(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              labelText: "Context Description",
                            ),
                            onChanged: null,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Action buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Theme.of(context).colorScheme.background,
                                side: BorderSide(
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                              ),
                              onPressed: () {
                                // Handle clear action
                                null;
                              },
                              child: Text(
                                'Clear',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(context).colorScheme.onSurface,
                                    ),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.onSurface,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                              ),
                              onPressed: () {
                                // Handle paste action
                                null;
                              },
                              child: Text(
                                'Paste',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: isDarkMode
                                          ? AppColors.backgroundDark
                                          : Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


@Preview(name: 'Context Screen Item')
Widget previewContextItem() {
  return const ContextItemWidget(
    contextId: '1',
    contextName: 'Sample Context',
    contextDescription:
        'This is a sample context description to demonstrate the expanded view of the context item widget.',
  );
}