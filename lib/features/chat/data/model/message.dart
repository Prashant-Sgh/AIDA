class MessageObj {
  final String id;
  final String authorId;
  final DateTime? createdAt;
  final String? text;

  const MessageObj({
    required this.id,
    required this.authorId,
    this.createdAt,
    this.text,
  });

  factory MessageObj.fromJson(Map<String, dynamic> json) {
    return MessageObj(
      id: json['id'] as String,
      authorId: json['authorId'] as String,
      createdAt: json['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int)
          : null,
      text: json['text'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorId': authorId,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'text': text,
    };
  }
}
