import 'package:aida/core/services/secure_storage_service.dart';
import 'package:aida/core/session/app_session_provider.dart';
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
    debugPrint('[OUTPUT] [Splash init] initState started');

    Future.microtask(() async {
      debugPrint('[OUTPUT] [Splash init] Starting app session initialization');
      // Initialize app session during splash screen
      await ref.read(appSessionProvider.notifier).initialize();
      debugPrint('[OUTPUT] [Splash init] App session initialization completed');

      if (!mounted) return;

      debugPrint('[OUTPUT] [Splash init] Starting auth state check');
      await ref.read(authenticationViewModelProvider.notifier).checkAuthState();
      debugPrint('[OUTPUT] [Splash init] Auth state check completed');

      if (!mounted) return;

      final secureStorageService = ref.read(secureStorageServiceProvider);
      final isUserRegistered = await secureStorageService.getFirebaseId();
      debugPrint('[OUTPUT] [Splash init] User registered check: $isUserRegistered');

      if (mounted) {
        final route = isUserRegistered == null ? '/' : '/chat';
        debugPrint('[OUTPUT] [Splash init] Navigating to: $route');
        context.push(route);
      }
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
