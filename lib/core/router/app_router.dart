import 'package:aida/features/chat/presentation/ChatScreen/ChatScreen.dart';
import 'package:aida/features/chat/presentation/screen/ChatScreen.dart';
import 'package:aida/features/splash/presentation/screen/Splash.dart';
import 'package:aida/features/welcome/presentation/screen/Welcome.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
        GoRoute(
      path: '/splash',  // With parameters
      builder: (context, state) => const Splash(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const Welcome(),  // Your home widget
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const Welcome(),  // Your welcome screen
    ),
    GoRoute(
      path: '/chat',  // With parameters
      builder: (context, state) => const ChatScreen(),
    ),

    // DEMO delete after understanding.
    GoRoute(
      path: '/chatUI',  // With parameters
      builder: (context, state) => const Basic(),
    ),
  ],
);