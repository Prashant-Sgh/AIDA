import 'package:aida/features/auth/presentation/view/screen/auth_screen.dart';
import 'package:aida/features/chat/presentation/screen/ChatScreen.dart';
import 'package:aida/features/context/presentation/view/screen/context_screen.dart';
import 'package:aida/features/otp/presentation/view/screen/otp_screen.dart';
import 'package:aida/features/splash/presentation/screen/Splash.dart';
import 'package:aida/features/welcome/presentation/screen/Welcome.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    /// Splash
    GoRoute(
      path: '/splash',
      builder: (context, state) => const Splash(),
    ),

    /// Welcome
    GoRoute(
      path: '/',
      builder: (context, state) => const Welcome(),
    ),

    /// Authentication
    GoRoute(
      path: '/authentication',
      pageBuilder: (context, state) {
        return _buildAnimatedPage(
          state: state,
          child: const AuthenticationScreen(),
        );
      },
    ),

    /// OTP
    GoRoute(
      path: '/otp',
      pageBuilder: (context, state) {
        return _buildAnimatedPage(
          state: state,
          child: const OtpVerificationScreen(),
        );
      },
    ),

    /// Context Screen
    GoRoute(
      path: '/context',
      pageBuilder: (context, state) {
        return _buildAnimatedPage(
          state: state,
          child: const ContextScreen(),
        );
      },
    ),

    /// Chat Screen
    GoRoute(
      path: '/chat',
      pageBuilder: (context, state) {
        return _buildAnimatedPage(
          state: state,
          child: const ChatScreen(),
        );
      },
    ),
  ],
);

/// Shared transition animation
CustomTransitionPage _buildAnimatedPage({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage(
    key: state.pageKey,
    transitionDuration: const Duration(milliseconds: 450),
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );

      final slideAnimation = Tween<Offset>(
        begin: const Offset(0.06, 0),
        end: Offset.zero,
      ).animate(curvedAnimation);

      return FadeTransition(
        opacity: curvedAnimation,
        child: SlideTransition(
          position: slideAnimation,
          child: child,
        ),
      );
    },
  );
}
