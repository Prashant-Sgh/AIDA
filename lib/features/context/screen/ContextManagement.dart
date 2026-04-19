import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

class ContextMangScreen extends StatelessWidget {
  const ContextMangScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const IconButton(onPressed: null, icon: Icon(Icons.arrow_back_rounded)),
        title: const Text('Context Management'),
        actions: [
          IconButton(onPressed: null, icon: const Icon(Icons.light_mode_outlined)),],
      ),
      body: const Center(
        child: Text('This is the Context Management screen.'),
      ),
    );
  }
}

@Preview(name: 'Context Management')
Widget previewContextManagement() {
  return const ContextMangScreen();
}
