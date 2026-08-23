import 'dart:async';

import 'package:aida/core/session/app_session_provider.dart';
import 'package:aida/features/auth/presentation/viewmodels/authentication_viewmodel.dart';
import 'package:aida/features/chat/data/model/Conversation.dart';
import 'package:aida/features/chat/data/model/message.dart';
import 'package:aida/features/chat/data/repository/chat_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatVMProvider = NotifierProvider<ChatViewmodel, ChatState>(
  ChatViewmodel.new,
);

class ChatViewmodel extends Notifier<ChatState> {
  late ChatRepo _chatRepo;
  StreamSubscription? _streamSubscription;

  @override
  ChatState build() {
    _chatRepo = ref.read(chatRepoProvider);
    // Watch auth state and session state to reactively update when they change
    ref.watch(authenticationViewModelProvider);
    ref.watch(appSessionProvider);
    return ChatState(conversation: Conversation(messages: []));
  }

  final _conversationStreamController =
      StreamController<Conversation>.broadcast();

  Stream<Conversation> get conversationStream =>
      _conversationStreamController.stream;

  // Helper to check if user is authenticated (authenticated = true and email is not empty)
  bool get _isAuthenticated {
    final authState = ref.read(authenticationViewModelProvider);
    return authState.authenticated && authState.email != null && authState.email!.isNotEmpty;
  }

  // Helper to get the appropriate identifier (email for auth, sessionId for guest)
  String get _userIdentifier {
    if (_isAuthenticated) {
      return ref.read(authenticationViewModelProvider).email!;
    } else {
      // For guest users, get sessionId from AppSession
      final sessionState = ref.read(appSessionProvider);
      return sessionState.maybeWhen(
        data: (session) => session.sessionId,
        orElse: () => 'guest_${DateTime.now().millisecondsSinceEpoch}',
      );
    }
  }

  // Helper to get conversation identifier
  String get _conversationId => "Default_Conversation_Id";

  // Commented out - using streamConversations instead
  // Future<void> loadConversations() async {
  //   final conversations = await _chatRepo.loadConversation(
  //       userEmail: _authVM.email,
  //       conversationId: "Default_Conversation_Id");
  //
  //   if (conversations != null) {
  //     state = state.copyWith(
  //         conversation: Conversation(messages: conversations), isEmpty: false);
  //   }
  //
  //   _conversationStreamController.add(state.conversation);
  // }

  void startConversationStream() {
    final identifier = _userIdentifier;
    final isAuth = _isAuthenticated;
    final conversationId = _conversationId;
    
    debugPrint("[ChatVM] startConversationStream called - Auth: $isAuth, Identifier: $identifier, ConversationId: $conversationId");
    
    // Cancel any existing subscription first
    _streamSubscription?.cancel();
    
    // Create new subscription based on auth state
    if (isAuth) {
      _streamSubscription = _chatRepo.streamConversations(
        userEmail: identifier,
        conversationId: conversationId,
      ).listen((messages) {
        debugPrint("[ChatVM] Received ${messages.length} messages from SSE stream (auth)");
        state = state.copyWith(
          conversation: Conversation(messages: messages),
          isEmpty: messages.isEmpty,
        );
        _conversationStreamController.add(state.conversation);
      }, onError: (error) {
        debugPrint("[ChatVM] SSE Stream Error (auth): $error");
        state = state.copyWith(isError: true);
      });
    } else {
      _streamSubscription = _chatRepo.streamConversationsGuest(
        sessionId: identifier,
      ).listen((messages) {
        debugPrint("[ChatVM] Received ${messages.length} messages from SSE stream (guest)");
        state = state.copyWith(
          conversation: Conversation(messages: messages),
          isEmpty: messages.isEmpty,
        );
        _conversationStreamController.add(state.conversation);
      }, onError: (error) {
        debugPrint("[ChatVM] SSE Stream Error (guest): $error");
        state = state.copyWith(isError: true);
      });
    }
  }

  void restartConversationStream() {
    debugPrint("[ChatVM] restartConversationStream called - cancelling existing stream and starting new one");
    
    // Cancel existing subscription if any
    _streamSubscription?.cancel();
    
    // Start new stream with fresh parameters
    startConversationStream();
  }

  Future<void> sendMessage(String text) async {
    // debugPrint("\nSending message:- $text");

    final updatedConversation = [
      ...state.conversation.messages,
      MessageObj(
        role: "user",
        content: text,
        createdAt: DateTime.now(),
      ),
    ];

    state = state.copyWith(
      conversation: Conversation(messages: updatedConversation),
    );

    _conversationStreamController.add(state.conversation);

    state = state.copyWith(isWaitingForResponse: true);
    
    final isAuth = _isAuthenticated;
    final identifier = _userIdentifier;
    final conversationId = _conversationId;
    
    String sentResponse;
    
    if (isAuth) {
      sentResponse = await _chatRepo.sendMessage(
        email: identifier,
        conversationId: conversationId,
        message: text,
      );
    } else {
      sentResponse = await _chatRepo.sendMessageGuest(
        message: text,
        sessionId: identifier,
      );
    }

    // debugPrint("\nResponse:- $sentResponse");

    final newConversation = [
      ...state.conversation.messages,
      MessageObj(
        role: "assistant",
        content: sentResponse,
        createdAt: DateTime.now(),
      )
    ];
    state =
        state.copyWith(conversation: Conversation(messages: newConversation));

    _conversationStreamController.add(state.conversation);

    // await loadConversations();
    state = state.copyWith(isWaitingForResponse: false);
  }

  Future<void> clearConversation() async {
    final isAuth = _isAuthenticated;
    final identifier = _userIdentifier;
    final conversationId = _conversationId;

    if (isAuth) {
      await _chatRepo.clearConversation(
          email: identifier, conversationId: conversationId);
      // Restart the stream to get fresh data
      restartConversationStream();
    } else {
      // Guest clear conversation not yet implemented
      debugPrint('[ChatVM] clearConversation: Guest mode - not implemented yet');
      // We could clear local state only
      state = state.copyWith(conversation: Conversation(messages: []), isEmpty: true);
      _conversationStreamController.add(state.conversation);
    }
  }
}

class ChatState {
  ChatState({
    this.conversation = const Conversation(messages: []),
    this.isWaitingForResponse = false,
    this.isEmpty = true,
    this.isLoading = false,
    this.isError = false,
  });

  final Conversation conversation;
  bool isWaitingForResponse;
  bool isEmpty;
  bool isLoading;
  bool isError;

  ChatState copyWith({
    Conversation? conversation,
    bool? isWaitingForResponse,
    bool? isEmpty,
    bool? isLoading,
    bool? isError,
  }) {
    return ChatState(
      conversation: conversation ?? this.conversation,
      isWaitingForResponse: isWaitingForResponse ?? this.isWaitingForResponse,
      isEmpty: isEmpty ?? this.isEmpty,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
    );
  }
}
