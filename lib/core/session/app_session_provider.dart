import 'dart:async';

import 'package:aida/core/session/app_session.dart';
import 'package:aida/core/session/app_session_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for the [AppSessionService] instance.
final appSessionServiceProvider = Provider<AppSessionService>((ref) {
  return AppSessionService();
});

/// AsyncNotifier to manage the [AppSession] state.
/// 
/// Ensures a single session instance per app lifecycle.
/// The session is initialized when first accessed (e.g., during splash screen).
/// A new session is created when the app is restarted (process death).
class AppSessionNotifier extends AsyncNotifier<AppSession> {
  // Completer to bridge build() and initialize()
  Completer<AppSession>? _initializationCompleter;
  // Flag to track if initialization is actually in progress (fetching session)
  bool _isInitializing = false;

  @override
  Future<AppSession> build() async {
    debugPrint('[OUTPUT] [App Session] Provider build() called - waiting for initialize()');
    // Ensure completer exists; initialize() might set it up first if called concurrently
    _initializationCompleter ??= Completer<AppSession>();
    // Wait for initialize() to complete the completer
    return _initializationCompleter!.future;
  }

  /// Initializes the app session by fetching it from the service.
  /// 
  /// Should be called once during app startup (e.g., in splash screen).
  /// Subsequent calls will return the existing session if already initialized.
  Future<AppSession> initialize() async {
    // If already initialized, return existing session
    if (state is AsyncData<AppSession>) {
      debugPrint('[OUTPUT] [App Session] Session already initialized - ${state.value!.sessionId}');
      return state.value!;
    }

    // Ensure completer exists (in case initialize() is called before build())
    _initializationCompleter ??= Completer<AppSession>();

    // If initialization is already in progress (another call to initialize()),
    // wait for that existing operation to complete.
    if (_isInitializing) {
      debugPrint('[OUTPUT] [App Session] Initialization already in progress (concurrent call), waiting...');
      try {
        return await _initializationCompleter!.future;
      } catch (e) {
        // If the previous attempt failed, we fall through to retry
        debugPrint('[OUTPUT] [App Session] Previous initialization failed, retrying...');
      }
    }

    // Start the actual initialization
    debugPrint('[OUTPUT] [App Session] Initializing new app session...');
    _isInitializing = true;
    state = const AsyncLoading();

    try {
      final service = ref.read(appSessionServiceProvider);
      final session = await service.fetchSession();
      state = AsyncData(session);
      debugPrint('[OUTPUT] [App Session] Session initialized - ${session.sessionId}');
      
      // Complete the completer so build() can resolve
      if (!_initializationCompleter!.isCompleted) {
        _initializationCompleter!.complete(session);
      }
      return session;
    } catch (e, stackTrace) {
      debugPrint('[OUTPUT] [App Session] Failed to initialize session - $e');
      state = AsyncError(e, stackTrace);
      
      // Complete the completer with error so build() can resolve
      if (!_initializationCompleter!.isCompleted) {
        _initializationCompleter!.completeError(e, stackTrace);
      }
      rethrow;
    } finally {
      _isInitializing = false;
    }
  }

  /// Forces a new session to be created (e.g., for testing or manual reset).
  Future<AppSession> reset() async {
    debugPrint('[OUTPUT] [App Session] Resetting session...');
    state = const AsyncLoading();
    
    try {
      final service = ref.read(appSessionServiceProvider);
      final session = await service.fetchSession();
      state = AsyncData(session);
      debugPrint('[OUTPUT] [App Session] Session reset - ${session.sessionId}');
      return session;
    } catch (e, stackTrace) {
      debugPrint('[OUTPUT] [App Session] Failed to reset session - $e');
      state = AsyncError(e, stackTrace);
      rethrow;
    }
  }
}

/// Provider for the [AppSessionNotifier] state.
final appSessionProvider = AsyncNotifierProvider<AppSessionNotifier, AppSession>(
  () => AppSessionNotifier(),
);
