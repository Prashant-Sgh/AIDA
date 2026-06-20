import 'dart:async';

import 'package:aida/features/auth/presentation/viewmodels/authentication_viewmodel.dart';
import 'package:aida/features/chat/data/model/Conversation.dart';
import 'package:aida/features/chat/data/model/message.dart';
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

  Future<void> loadConversations() async {
    final conversations = await _chatRepo.loadConversation(
        userEmail: "test@aida.com",
        conversationId: "SMW-Conversation_Testing_01");

    if (conversations != null) {
      //   debugPrint("This user conversations are: $conversations");
      state = state.copyWith(
          conversation: Conversation(messages: conversations), isEmpty: false);
    }

    bool hasError = state.isError;

    if (hasError) {
      //   final conversationWithError = [...conversations, Conversation(messages: [MessageObj(text: "Error", isUser: false)])];
      final conversationWithError = [
        ...state.conversation.messages,
        MessageObj(
          role: "assistant",
          content: "Error",
          createdAt: DateTime.now(),
        )
      ];

      state = state.copyWith(
          conversation: Conversation(messages: conversationWithError));
    }

    _conversationStreamController.add(state.conversation);
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
    final sentResponse = await _chatRepo.sendMessage(
      email: _authVM.email,
      // email: "test@aida.com",
      conversationId: "Default_Conversation_Id",
      message: text,
    );

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
    String email = _authVM.email;
    String conversationId = "Default_Conversation_Id";

    await _chatRepo.clearConversation(
        email: email, conversationId: conversationId);
    await loadConversations();
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
