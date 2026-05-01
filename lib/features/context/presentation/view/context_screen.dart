import 'package:aida/core/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aida/features/context/presentation/viewmodels/context_viewmodel.dart';
import 'package:aida/features/context/presentation/view/context_item_widget.dart';
import 'package:aida/core/theme/CustomColors.dart';
import 'package:google_fonts/google_fonts.dart';

class ContextScreen extends ConsumerStatefulWidget {
  const ContextScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ContextScreen> createState() => _ContextScreenState();
}

class _ContextScreenState extends ConsumerState<ContextScreen> {
  @override
  void initState() {
    super.initState();
    // Load contexts when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(contextVMProvider.notifier).loadContexts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final contextState = ref.watch(contextVMProvider);
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;
    final isDarkMode = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;
    final customColors = theme.extension<CustomColors>()!;
    final backgroundColor = customColors.contextScrBackground;

    return Scaffold(
      backgroundColor: backgroundColor,
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
        backgroundColor: colorScheme.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: colorScheme.onSurface,
          ),
          onPressed: () {
            // Handle menu action
            null;
          },
        ),
        actions: [
          IconButton(
            onPressed: () => ref.read(themeModeProvider.notifier).toggleTheme(),
            icon: Icon(
              isDarkMode ? Icons.light_mode : Icons.light_mode_outlined,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
      body: contextState.isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: customColors.dropDownLineColor,
              ),
            )
          : contextState.error != null
              ? Center(
                  child: Text(
                    'Error: ${contextState.error}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.red,
                    ),
                  ),
                )
              : Stack(
                  children: [
                    ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: contextState.allContexts.length,
                      itemBuilder: (context, index) {
                        final contextItem = contextState.allContexts[index];
                        return ContextItemWidget(
                          contextId: contextItem.id,
                          contextName: contextItem.name,
                          contextDescription: contextItem.content,
                        );
                      },
                    ),
                    Positioned(
                      bottom: 6,
                      left: 16,
                      right: 80,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 16),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: textColor,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            // Handle update action
                            null;
                          },
                          child: Text(
                            'Update',
                            style: GoogleFonts.quicksand(
                              color: backgroundColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorScheme.surface,
        onPressed: () {
          // Handle add new context
          null;
        },
        child: Icon(
          Icons.add,
          color: textColor,
        ),
      ),
    );
  }
}
