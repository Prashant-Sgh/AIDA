import 'dart:async';

import 'package:aida/features/auth/presentation/viewmodels/authentication_viewmodel.dart';
import 'package:aida/features/chat/data/model/Conversation.dart';
import 'package:aida/features/chat/data/repository/chat_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatVMProvider = NotifierProvider<ChatViewmodel, ChatState>(
  ChatViewmodel.new,
);

class ChatViewmodel extends Notifier<ChatState> {
  late ChatRepo _chatRepo;
  late AuthenticationViewModel _authVM;

  @override
  ChatState build() {
    _chatRepo = ref.read(chatRepoProvider);
    _authVM = ref.read(authenticationViewModelProvider.notifier);
    return ChatState(conversation: Conversation(messages: []));
  }

  final _conversationStreamController =
      StreamController<Conversation>.broadcast();

  Stream<Conversation> get conversationStream =>
      _conversationStreamController.stream;
  Future<void> clearChat() async {
    state = state.copyWith(conversation: Conversation(messages: []));
  }

  Future<void> loadConversations() async {
    final conversations = await ref.read(chatRepoProvider).loadConversation(
        userEmail: _authVM.email, conversationId: "SMW-Conversation_Testing_01");

    if (conversations != null) {
      state =
          state.copyWith(conversation: Conversation(messages: conversations), isEmpty: false);
    }
  }

  Future<void> sendMessage(String text) async {
    state = state.copyWith(isWaitingForResponse: true);
    await ref.read(chatRepoProvider).sendMessage(
        email: _authVM.email, conversationId: "SMW-Conversation_Testing_01", message: text);
    loadConversations();
    state = state.copyWith(isWaitingForResponse: false);
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
