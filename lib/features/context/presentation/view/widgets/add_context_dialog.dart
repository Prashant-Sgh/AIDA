import 'package:aida/core/enums/response_state.dart';
import 'package:aida/core/theme/CustomColors.dart';
import 'package:aida/features/context/data_layer/model/context_model.dart';
import 'package:aida/features/context/presentation/viewmodels/context_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class AddContextDialog extends ConsumerWidget {
  const AddContextDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final colorScheme = theme.colorScheme;

    final customColors = theme.extension<CustomColors>()!;

    final state = ref.watch(contextVMProvider);

    final viewModel = ref.read(contextVMProvider.notifier);

    final contextModel = viewModel.newContextModel;

    final titleController = TextEditingController(
      text: contextModel?.name ?? '',
    );

    final descriptionController = TextEditingController(
      text: contextModel?.content ?? '',
    );

    final textColor = colorScheme.onSurface;

    final backgroundColor = customColors.contextScrCard;

    final borderColor = customColors.contextScrCardStroke;

    final fieldColor = customColors.contextScrExpandedCardTxtField;

    final bool canSave = titleController.text.trim().isNotEmpty &&
        descriptionController.text.trim().isNotEmpty;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: borderColor,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            _DialogHeader(
              textColor: textColor,
            ),

            const SizedBox(height: 24),

            /// Name Field
            ContextNameField(
              controller: titleController,
              backgroundColor: fieldColor,
              textColor: textColor,
              onChanged: (value) {
                viewModel.setNewContextModel(
                  ContextModel(
                    id: contextModel?.id ?? '',
                    name: value,
                    content: descriptionController.text,
                  ),
                );
              },
            ),

            const SizedBox(height: 18),

            /// Description Field
            ContextDescriptionField(
              controller: descriptionController,
              backgroundColor: fieldColor,
              textColor: textColor,
              onChanged: (value) {
                viewModel.setNewContextModel(
                  ContextModel(
                    id: contextModel?.id ?? '',
                    name: titleController.text,
                    content: value,
                  ),
                );
              },
            ),

            const SizedBox(height: 28),

            /// Actions
            DialogActionsRow(
              canSave: canSave,
              textColor: textColor,
              onCancel: () {
                Navigator.pop(context);
              },
              onSave: () async {
                final newContext = ContextModel(
                  id: contextModel?.id ?? '',
                  name: titleController.text.trim(),
                  content: descriptionController.text.trim(),
                );

                viewModel.setNewContextModel(newContext);

                ResponseState responseState =
                    await viewModel.createContext(newContext: newContext);

                if (responseState == ResponseState.success) {
                  debugPrint('SUCCESS SAVING CONTEXT');
                  viewModel.clearNewContextModel();
                  // viewModel.loadContexts();
                } else {
                  debugPrint(
                      'ERROR SAVING CONTEXT... ResponseState: $responseState');
                }

                /// your create logic
                // await viewModel.createContext();

                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogHeader extends StatelessWidget {
  final Color textColor;

  const _DialogHeader({
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create Context',
          style: GoogleFonts.baloo2(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Save a new context for your AI.',
          style: GoogleFonts.quicksand(
            fontSize: 14,
            height: 1.5,
            fontWeight: FontWeight.w500,
            color: textColor.withOpacity(0.65),
          ),
        ),
      ],
    );
  }
}

class ContextNameField extends StatelessWidget {
  final TextEditingController controller;
  final Color backgroundColor;
  final Color textColor;
  final Function(String value) onChanged;

  const ContextNameField({
    super.key,
    required this.controller,
    required this.backgroundColor,
    required this.textColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _InputFieldContainer(
      backgroundColor: backgroundColor,
      child: TextField(
        controller: controller,
        maxLength: 20,
        inputFormatters: [
          LengthLimitingTextInputFormatter(20),
        ],
        style: GoogleFonts.quicksand(
          color: textColor,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        onChanged: onChanged,
        decoration: InputDecoration(
          border: InputBorder.none,
          counterText: '',
          hintText: 'Context name',
          hintStyle: GoogleFonts.quicksand(
            color: textColor.withOpacity(0.4),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class ContextDescriptionField extends StatelessWidget {
  final TextEditingController controller;
  final Color backgroundColor;
  final Color textColor;
  final Function(String value) onChanged;

  const ContextDescriptionField({
    super.key,
    required this.controller,
    required this.backgroundColor,
    required this.textColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _InputFieldContainer(
      backgroundColor: backgroundColor,
      child: TextField(
        controller: controller,
        maxLines: 5,
        style: GoogleFonts.quicksand(
          color: textColor,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        onChanged: onChanged,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Describe this context...',
          hintStyle: GoogleFonts.quicksand(
            color: textColor.withOpacity(0.4),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class DialogActionsRow extends StatelessWidget {
  final bool canSave;
  final Color textColor;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const DialogActionsRow({
    super.key,
    required this.canSave,
    required this.textColor,
    required this.onCancel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: onCancel,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                vertical: 15,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: Text(
              'Cancel',
              style: GoogleFonts.quicksand(
                color: textColor.withOpacity(0.75),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: canSave ? onSave : null,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              disabledBackgroundColor: textColor.withOpacity(0.12),
              backgroundColor: textColor,
              foregroundColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black
                  : Colors.white,
              padding: const EdgeInsets.symmetric(
                vertical: 15,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: Text(
              'Save',
              style: GoogleFonts.quicksand(
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _InputFieldContainer extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;

  const _InputFieldContainer({
    required this.child,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}
