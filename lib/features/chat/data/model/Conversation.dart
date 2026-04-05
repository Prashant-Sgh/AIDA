class Conversation {
  final String id;
  final DateTime? time;
  final bool isUser;
  final String message;

  const Conversation(
      {required this.id,
      required this.time,
      required this.isUser,
      required this.message});

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] as String,
      time: json['time'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['time'] as int)
          : null,
      isUser: (json['isUser'] as int) == 1 ? true : false,
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'time': time?.millisecondsSinceEpoch.toInt() ?? DateTime.now().millisecondsSinceEpoch.toInt(),
      'isUser': isUser,
      'message': message,
    };
  }
}
