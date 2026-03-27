import 'package:aida/features/chat/data/model/Conversation.dart';

class ConversationHandeler {
  List<Conversation> conversations = [
    Conversation(
        role: 'user',
        message:
            "Hey AIDA, I'm looking to know about this specific project done by Atul on, can you help?"),
    Conversation(role: 'AI', message: "Yes I can help you with that, tell me what specific detail you are looking for.")
  ];
}
