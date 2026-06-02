import 'package:aida/features/auth/presentation/viewmodels/authentication_viewmodel.dart';
import 'package:aida/features/chat/data/repository/messageManager.dart';
import 'package:aida/features/context/presentation/view/widgets/add_context_dialog.dart';
import 'package:aida/features/context/presentation/viewmodels/context_state.dart';
import 'package:aida/shared/widgets/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aida/features/context/presentation/viewmodels/context_viewmodel.dart';
import 'package:aida/features/context/presentation/view/widgets/context_item_widget.dart';
import 'package:aida/core/theme/CustomColors.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ContextScreen extends ConsumerStatefulWidget {
  const ContextScreen({super.key});

  @override
  ConsumerState<ContextScreen> createState() => _ContextScreenState();
}

class _ContextScreenState extends ConsumerState<ContextScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(contextVMProvider.notifier).loadContexts();
    });
  }

  @override
  Widget build(BuildContext context) {
    /// Theme
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final customColors = theme.extension<CustomColors>()!;

    /// Colors
    final textColor = colorScheme.onSurface;
    final backgroundColor = customColors.contextScrBackground;

    /// Providers
    final authState = ref.watch(authenticationViewModelProvider);
    final contextVM = ref.watch(contextVMProvider);
    final messageManager = ref.watch(messageManagerProvider);

    /// Local state
    final isContextNotSaved =
        ref.read(contextVMProvider.notifier).hasDataChanged;

    return Scaffold(
      backgroundColor: backgroundColor,

      /// APP BAR
      appBar: AppBar(
        title: Text(
          'Context manager',
          style: GoogleFonts.baloo2(
            color: textColor,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
        backgroundColor: colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              ref.read(contextVMProvider.notifier).loadContexts();
            },
            icon: Icon(
              Icons.replay_rounded,
              color: textColor,
            ),
          ),
        ],
      ),

      /// BODY
      body: Stack(
        children: [
          _buildBodyContent(
            context: context,
            ref: ref,
            contextVM: contextVM,
            customColors: customColors,
            textColor: textColor,
            backgroundColor: backgroundColor,
            isContextNotSaved: isContextNotSaved,
          ),
        ],
      ),

      /// FAB
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorScheme.surface,
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => const AddContextDialog(),
          );
        },
        child: Icon(
          Icons.add,
          color: textColor,
        ),
      ),

      /// DRAWER
      drawer: AppDrawer(
        onClearChat: messageManager.clearChat,
      ),
    );
  }
}

/// ==========================================================
/// BODY CONTENT
/// ==========================================================

Widget _buildBodyContent({
  required BuildContext context,
  required WidgetRef ref,
  required ContextState contextVM,
  required CustomColors customColors,
  required Color textColor,
  required Color backgroundColor,
  required bool isContextNotSaved,
}) {
  final theme = Theme.of(context);

  /// LOADING
  if (contextVM.isLoading) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 34,
            width: 34,
            child: CircularProgressIndicator(
              strokeWidth: 2.4,
              color: customColors.dropDownLineColor,
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Loading your contexts...',
            style: GoogleFonts.quicksand(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textColor.withOpacity(0.72),
            ),
          ),
        ],
      ),
    );
  }

  /// EMPTY / ERROR STATES
  if (contextVM.error != null) {
    /// EMPTY STATE
    if (contextVM.errorCode == 204) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 82,
                width: 82,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: customColors.contextScrCard,
                  border: Border.all(
                    color: customColors.contextScrCardStroke,
                  ),
                ),
                child: Icon(
                  Icons.auto_awesome_mosaic_rounded,
                  size: 34,
                  color: textColor.withOpacity(0.72),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'No contexts yet',
                style: GoogleFonts.baloo2(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Create your first context using the + button below.',
                textAlign: TextAlign.center,
                style: GoogleFonts.quicksand(
                  fontSize: 14,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                  color: textColor.withOpacity(0.62),
                ),
              ),
            ],
          ),
        ),
      );
    }

    /// ERROR STATE
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 82,
              width: 82,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red.withOpacity(0.08),
                border: Border.all(
                  color: Colors.red.withOpacity(0.18),
                ),
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 36,
                color: Colors.redAccent.withOpacity(0.9),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Something went wrong',
              style: GoogleFonts.baloo2(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              contextVM.error ?? 'Unknown error occurred',
              textAlign: TextAlign.center,
              style: GoogleFonts.quicksand(
                fontSize: 14,
                height: 1.5,
                fontWeight: FontWeight.w500,
                color: textColor.withOpacity(0.62),
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                ref.read(contextVMProvider.notifier).loadContexts();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: textColor,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  'Try Again',
                  style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.w700,
                    color: theme.scaffoldBackgroundColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// SUCCESS STATE
  return Stack(
    children: [
      ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: contextVM.allContexts.length,
        itemBuilder: (context, index) {
          final contextItem = contextVM.allContexts[index];

          return ContextItemWidget(
            contextId: contextItem.id,
            contextName: contextItem.name,
            contextContent: contextItem.content,
          );
        },
      ),

      /// UPDATE BUTTON
      Positioned(
        bottom: 6,
        left: 16,
        right: 80,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: textColor,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: isContextNotSaved
                ? () {
                    ref.read(contextVMProvider.notifier).updateContextModels();
                  }
                : null,
            child: Text(
              'Update',
              style: GoogleFonts.quicksand(
                color: backgroundColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
