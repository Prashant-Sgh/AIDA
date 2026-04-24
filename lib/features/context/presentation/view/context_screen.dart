import 'package:aida/core/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aida/features/context/presentation/viewmodels/context_viewmodel.dart';
import 'package:aida/features/context/presentation/view/context_item_widget.dart';
import 'package:aida/core/theme/CustomColors.dart';

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
    final isDarkMode = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;
    final customColors = theme.extension<CustomColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Context manager',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w500,
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
              : ListView.builder(
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFC724B1),
        onPressed: () {
          // Handle add new context
          null;
        },
        child: Icon(
          Icons.add,
          color: colorScheme.onSurface,
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: customColors.lightCardColor,
          border: Border(
            top: BorderSide(
              color: customColors.lineColor,
              width: 1,
            ),
          ),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFC724B1),
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
            style: theme.textTheme.labelLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
