import 'package:aida/core/theme/CustomColors.dart';
import 'package:aida/features/context/data_layer/model/context_model.dart';
import 'package:aida/features/context/presentation/viewmodels/context_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ContextItemWidget extends ConsumerStatefulWidget {
  final String contextId;
  final String contextName;
  final String contextContent;

  const ContextItemWidget({
    super.key,
    required this.contextId,
    required this.contextName,
    required this.contextContent,
  });

  @override
  ConsumerState<ContextItemWidget> createState() => _ContextItemWidgetState();
}

class _ContextItemWidgetState extends ConsumerState<ContextItemWidget>
    with TickerProviderStateMixin {
  late String _originalContent;
  late final TextEditingController _controller;

  bool _isExpanded = false;
  bool _isUpdated = false;
  Color _cardToggleColor = Colors.white;

  @override
  void initState() {
    super.initState();

    _originalContent = widget.contextContent;

    _controller = TextEditingController(
      text: _originalContent,
    );
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _hasChanged => _controller.text.trim() != _originalContent.trim();

  void _stackInChanged() {
    ref.read(contextVMProvider.notifier).stackInLatestChanges(
          index: widget.contextId,
          latestContext: ContextModel(
            id: widget.contextId,
            name: widget.contextName,
            content: _controller.text,
          ),
        );
  }

  void _saveChanges() {
    ref.read(contextVMProvider.notifier).updateContext(
          updatedContext: ContextModel(
            id: widget.contextId,
            name: widget.contextName,
            content: _controller.text,
          ),
        );
    setState(() {
      _cardToggleColor = Colors.green;
      _originalContent = _controller.text;
    });
  }

  void _deleteContext() {
    setState(() {
      _cardToggleColor = Colors.redAccent;
    });
    ref.read(contextVMProvider.notifier).deleteById(id: widget.contextId);
  }

  Future<void> _toggleUpdateColor() async {
    setState(() {
      _isUpdated = true;
    });
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _isUpdated = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;
    final customColors = theme.extension<CustomColors>()!;
    final textColor = colorScheme.onSurface;
    final cardColor = customColors.contextScrCard;
    final fieldColor = customColors.contextScrExpandedCardTxtField;
    final borderColor = customColors.contextScrCardStroke;
    final expandedColor = customColors.contextScrExpandedCard;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: _isUpdated
            ? _cardToggleColor
            : (_isExpanded ? expandedColor : cardColor),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeInOut,
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 20,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.contextName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.baloo2(
                              fontSize: 19,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _controller.text,
                            maxLines: _isExpanded ? null : 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.quicksand(
                              fontSize: 13,
                              height: 1.5,
                              fontWeight: FontWeight.w500,
                              color: textColor.withOpacity(0.58),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    AnimatedRotation(
                      duration: const Duration(milliseconds: 240),
                      turns: _isExpanded ? 0.5 : 0,
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: textColor.withOpacity(0.72),
                        size: 26,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_isExpanded)
              Padding(
                padding: const EdgeInsets.only(
                  left: 18,
                  right: 18,
                  bottom: 18,
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: fieldColor,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: TextField(
                        controller: _controller,
                        minLines: 4,
                        maxLines: 10,
                        keyboardType: TextInputType.multiline,
                        style: GoogleFonts.quicksand(
                          fontSize: 14,
                          height: 1.6,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Write something...',
                          hintStyle: GoogleFonts.quicksand(
                            color: textColor.withOpacity(0.4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: _ActionButton(
                            text: 'Delete',
                            isDestructive: true,
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return DeleteContextDialog(
                                    onDelete: () async {
                                      _deleteContext();
                                      setState(() {
                                        _isExpanded = false;
                                      });
                                      await _toggleUpdateColor();
                                      await Future.delayed(
                                          const Duration(milliseconds: 520));
                                      ref
                                          .read(contextVMProvider.notifier)
                                          .loadContexts();
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ActionButton(
                            text: 'Save',
                            enabled: _hasChanged,
                            loading: ref.watch(contextVMProvider).updating,
                            onTap: () async {
                              _saveChanges();
                              setState(() {
                                _isExpanded = false;
                              });
                              await _toggleUpdateColor();
                              await Future.delayed(
                                  const Duration(milliseconds: 520));
                              ref
                                  .read(contextVMProvider.notifier)
                                  .loadContexts();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String text;
  final bool enabled;
  final bool loading;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ActionButton({
    required this.text,
    required this.onTap,
    this.enabled = true,
    this.loading = false,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: isDestructive
              ? Colors.red.withOpacity(0.1)
              : (enabled ? textColor : textColor.withOpacity(0.30)),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Center(
          child: loading
              ? CircularProgressIndicator(
                  constraints: const BoxConstraints(
                    maxHeight: 20,
                    maxWidth: 20,
                    minHeight: 20,
                    minWidth: 20,
                  ),
                  strokeWidth: 2,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.black
                      : Colors.white,
                )
              : Text(
                  text,
                  style: GoogleFonts.quicksand(
                    color: isDestructive
                        ? Colors.redAccent
                        : Theme.of(context).brightness == Brightness.dark
                            ? Colors.black
                            : Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
        ),
      ),
    );
  }
}

class DeleteContextDialog extends StatelessWidget {
  final VoidCallback onDelete;

  const DeleteContextDialog({
    super.key,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final customColors = theme.extension<CustomColors>()!;

    final textColor = theme.colorScheme.onSurface;

    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: customColors.contextScrCard,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: customColors.contextScrCardStroke,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Delete Context',
              style: GoogleFonts.baloo2(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'This action cannot be undone later.',
              style: GoogleFonts.quicksand(
                fontSize: 14,
                height: 1.5,
                color: textColor.withOpacity(0.65),
              ),
            ),
            const SizedBox(height: 26),
            Row(
              children: [
                Expanded(
                  child: _DialogButton(
                    text: 'Cancel',
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _DialogButton(
                    text: 'Delete',
                    isDestructive: true,
                    onTap: () {
                      onDelete();
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isDestructive;

  const _DialogButton({
    required this.text,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: isDestructive
              ? Colors.red.withOpacity(0.12)
              : textColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.quicksand(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isDestructive ? Colors.redAccent : textColor,
            ),
          ),
        ),
      ),
    );
  }
}
