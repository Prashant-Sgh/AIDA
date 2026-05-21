import 'package:aida/features/auth/presentation/viewmodels/authentication_viewmodel.dart';
import 'package:aida/features/splash/presentation/widgets/AIDA_animation.dart';
import 'package:aida/features/splash/presentation/widgets/MetaText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class Splash extends ConsumerStatefulWidget {
  const Splash({super.key});

  @override
  ConsumerState<Splash> createState() => _SplashState();
}

class _SplashState extends ConsumerState<Splash> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await ref.read(authenticationViewModelProvider.notifier).checkAuthState();

      if (!mounted) return;

      context.go('/');
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Stack(children: [
      Center(child: AIDAAnimation()),
      Positioned(bottom: 157, left: 0, right: 0, child: MetaText())
    ]));
  }
}
