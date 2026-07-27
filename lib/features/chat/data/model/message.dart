class MessageObj {
  final String role;
  final String content;
  final DateTime? createdAt;

  const MessageObj({
    this.role = 'user',
    this.content = '',
    this.createdAt,
  });

  factory MessageObj.fromJson(Map<String, dynamic> json) {
    DateTime? createdAt;

    final rawCreatedAt = json['createdAt'];

    final seconds = rawCreatedAt['_seconds'] as int?;
    final nanoseconds = rawCreatedAt['_nanoseconds'] as int ?? 0;
    if (seconds != null) {
      createdAt = DateTime.fromMillisecondsSinceEpoch(
          seconds * 1000 + nanoseconds ~/ 1000000);
    }

    return MessageObj(
      role: json['role'] as String,
      content: json['content'] as String,
      createdAt: createdAt,
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'role': role,
  //     'content': content,
  //     'createdAt': createdAt?.millisecondsSinceEpoch,
  //   };
  // }
}
