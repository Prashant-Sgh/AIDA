import 'package:aida/core/theme/CustomColors.dart';
import 'package:aida/features/context/domain_layer/context_model.dart';
import 'package:aida/features/context/presentation/viewmodels/context_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:aida/core/theme/app_colors.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ContextItemWidget extends ConsumerStatefulWidget {
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
  ConsumerState<ContextItemWidget> createState() => _ContextItemWidgetState();
}

class _ContextItemWidgetState extends ConsumerState<ContextItemWidget>
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

    final _description = widget.contextDescription;
    _descriptionController = TextEditingController(text: _description);
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
    final contextVmState = ref.watch(contextVMProvider);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final customColors = theme.extension<CustomColors>()!;
    final textColor = theme.colorScheme.onSurface;
    final cardColor = customColors.contextScrCard;
    final cardStrokeColor = customColors.contextScrCardStroke;
    final cardExpandedColor = customColors.contextScrExpandedCard;
    final cardExpandedTxtFieldColor =
        customColors.contextScrExpandedCardTxtField;
    final clearBtnTxtColor = customColors.contextScrButtonClearTxt;

    return Container(
      child: Column(
        children: [
          // Collapsed state - Header
          Container(
            margin: const EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: cardStrokeColor,
                width: 0.5,
              ),
            ),
            child: InkWell(
              onTap: _toggleExpand,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 25, top: 12, right: 12, bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 6,
                      child: Text(
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        widget.contextName,
                        style: GoogleFonts.quicksand(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (!_isExpanded) (const SizedBox(height: 6)),
                    if (!_isExpanded)
                      Expanded(
                        flex: 4,
                        child: Text(
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          _descriptionController.text,
                          style: GoogleFonts.quicksand(
                            color: textColor,
                            fontSize: 12.0,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    const SizedBox(width: 8),
                    Icon(
                      _isExpanded
                          ? Icons.expand_less_rounded
                          : Icons.expand_more_rounded,
                      color: textColor,
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
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: cardExpandedColor,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 14),
                        // Context description
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0)),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: cardExpandedTxtFieldColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 17, vertical: 14),
                              child: TextField(
                                controller: _descriptionController,
                                enabled: _isEditable,
                                minLines: 1,
                                maxLines: 6,
                                keyboardType: TextInputType.multiline,
                                style: GoogleFonts.baloo2(
                                  color: textColor.withAlpha(200),
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w100,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder
                                      .none, // Removes the default underline
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  contentPadding: EdgeInsets
                                      .zero, // Removes extra padding inside the field
                                ),
                                onChanged: (value) {
                                  _descriptionController =
                                      TextEditingController(text: value);
                                  var contextVM =
                                      ref.read(contextVMProvider.notifier);
                                  contextVM.stackInLatestChanges(
                                      index: widget.contextId,
                                      latestContext: ContextModel(
                                        id: widget.contextId,
                                        name: widget.contextName,
                                        content: value,
                                      ));
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 35),
                        // Action buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _isEditable = !_isEditable;
                                });
                              },
                              icon: Container(
                                height: 39,
                                width: 96,
                                decoration: BoxDecoration(
                                    color: textColor,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Center(
                                  child: Text(
                                    'Edit',
                                    style: GoogleFonts.quicksand(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: clearBtnTxtColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: null,
                              icon: Container(
                                height: 39,
                                width: 96,
                                decoration: BoxDecoration(
                                    color: theme.colorScheme.surface,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Center(
                                  child: Text(
                                    'Done',
                                    style: GoogleFonts.quicksand(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 19)
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
